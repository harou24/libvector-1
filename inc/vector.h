/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   vector.h                                           :+:    :+:            */
/*                                                     +:+                    */
/*   By: sverschu <sverschu@student.codam.n>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2020/08/06 17:14:23 by sverschu      #+#    #+#                 */
/*   Updated: 2020/09/20 00:02:15 by sverschu      ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

/*
** inspired upon:
** stackoverflow.com/questions/3456446/a-good-c-equivalent-of-stl-vector
*/

#ifndef VECTOR_H
# define VECTOR_H

# include <sys/types.h>
# include <stddef.h>

typedef enum	e_ops
{
	E_OPS_BEGIN,
	V_CREATE,
	V_DESTROY,
	V_CLEAR,
	V_CLONE,
	V_PUSHFRONT,
	V_PUSHBACK,
	V_PUSHAT,
	V_PEEKFRONT,
	V_PEEKBACK,
	V_PEEKAT,
	V_POPFRONT,
	V_POPBACK,
	V_POPAT,
	V_FIND_NTH,
	V_FIND_NTH_REV,
	V_SIZE,
	E_OPS_END
}				t_ops;

void	*vector(void **root, t_ops op, size_t n, void *obj);

/*
** Important:
** - V_FIND_NTH / V_FIND_NTH_REV expect as 'void *obj' a function pointer of
**   the type 'int (*f)(void *obj)' which returns above zero if the object
**   is a match.
**
** - V_DESTROY takes as 'size_t n' as boolean wheter or not to call free on
**   it's members.
*/

#endif
