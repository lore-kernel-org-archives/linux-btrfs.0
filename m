Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.efficios.com ([78.47.125.74]:43198 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbaIROHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 10:07:04 -0400
Date: Thu, 18 Sep 2014 14:03:10 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Message-ID: <39127609.24822.1411048990717.JavaMail.zimbra@efficios.com>
In-Reply-To: <1411032491-26813-1-git-send-email-osandov@osandov.com>
References: <1411032491-26813-1-git-send-email-osandov@osandov.com>
Subject: Re: [PATCH] Move BTRFS RCU string to common library
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----- Original Message -----
> From: "Omar Sandoval" <osandov@osandov.com>
> To: "Chris Mason" <clm@fb.com>, "Josef Bacik" <jbacik@fb.com>, linux-btrfs@vger.kernel.org, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, "Josh Triplett" <josh@joshtriplett.org>, "Steven Rostedt" <rostedt@goodmis.org>,
> "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
> linux-kernel@vger.kernel.org
> Sent: Thursday, September 18, 2014 5:28:11 AM
> Subject: [PATCH] Move BTRFS RCU string to common library
> 
> The RCU-friendy string API used internally by BTRFS is generic enough for
> common use. This doesn't add any new functionality, but instead just moves
> the
> code and documents the existing API.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

[...]
> --- /dev/null
> +++ b/include/linux/rcustring.h
> @@ -0,0 +1,84 @@
> +/*
> + * RCU-friendly strings
> + *
> + * Copyright (C) 2012 Red Hat.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, you can access it online at
> + * http://www.gnu.org/licenses/gpl-2.0.html.
> + */
> +
> +#ifndef _LINUX_RCUSTRING_H
> +#define _LINUX_RCUSTRING_H
> +
> +struct rcu_string {
> +	struct rcu_head rcu;
> +	char str[0];
> +};
> +
> +/**
> + * rcu_string_strdup() - create an RCU string from a string
> + * @src: The string to copy
> + * @flags: Flags for kmalloc
> + */
> +static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t
> flags)
> +{
> +	size_t len = strlen(src) + 1;
> +	struct rcu_string *ret = kmalloc(sizeof(struct rcu_string) +
> +					 (len * sizeof(char)), flags);

Just a nit: not sure if we want that much code within declarations ?

Splitting declarations and non-trivial initial assignments might be a
bit clearer in this case.


> +	if (!ret)
> +		return ret;
> +	memcpy(ret->str, src, len);
> +	return ret;
> +}
> +
> +/**
> + * rcu_string_free() - free an RCU string
> + * @str: The string
> + */
> +static inline void rcu_string_free(struct rcu_string *str)
> +{
> +	if (str)
> +		kfree_rcu(str, rcu);
> +}
> +
> +/*
> + * rcu_string_dereference() - dereference an RCU string
> + * @str: The string
> + *
> + * Like rcu_dereference, this must be done in an RCU critical section.
> + */
> +static inline char *rcu_string_dereference(struct rcu_string *rcu_str)
> +{
> +	return rcu_dereference(rcu_str)->str;
> +}
> +
> +/**
> + * printk_in_rcu() - printk in an RCU read-side critical section

printk returns an integer, perhaps this macro should take it into
account ?

> + */
> +#define printk_in_rcu(fmt, ...) do {	\
> +	rcu_read_lock();		\
> +	printk(fmt, __VA_ARGS__);	\
> +	rcu_read_unlock();		\
> +} while (0)

The usual coding style for those define (using tabs to end lines):

#define printk_in_rcu(fmt, ...)    \
do {                               \
   ....                            \
} while (0)

> +
> +/**
> + * printk_ratelimited_in_rcu() - printk in an RCU read-side critical section

Same as above: printk_ratelimit returns an integer.

Thanks,

Mathieu

> + */
> +#define printk_ratelimited_in_rcu(fmt, ...) do {	\
> +	rcu_read_lock();				\
> +	printk_ratelimited(fmt, __VA_ARGS__);		\
> +	rcu_read_unlock();				\
> +} while (0)
> +
> +#endif
> --
> 2.1.0
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
