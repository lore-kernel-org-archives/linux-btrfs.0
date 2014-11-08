Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:60588 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753725AbaKHQNm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Nov 2014 11:13:42 -0500
Message-ID: <1415463217.23530.26.camel@perches.com>
Subject: Re: [PATCH v6] Move BTRFS RCU string to common library
From: Joe Perches <joe@perches.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Date: Sat, 08 Nov 2014 08:13:37 -0800
In-Reply-To: <1415436384-13691-1-git-send-email-osandov@osandov.com>
References: <1415407155.23530.24.camel@perches.com>
	 <1415436384-13691-1-git-send-email-osandov@osandov.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2014-11-08 at 00:46 -0800, Omar Sandoval wrote:
> The RCU-friendly string API used internally by BTRFS is generic enough for
> common use. This doesn't add any new functionality, but instead just moves the
> code and documents the existing API.

Some more trivia, can be updated later if desired.

> diff --git a/include/linux/rcustring.h b/include/linux/rcustring.h
> new file mode 100644
[]
> +
> +/**
> + * printk_in_rcu() - printk in an RCU read-side critical section

It'd be nice to show the arguments for kernel-doc here

> + */
> +#define printk_in_rcu(fmt, ...)			\
> +	do {					\
> +		rcu_read_lock();		\
> +		printk(fmt, __VA_ARGS__);	\

This should use ##__VA_ARGS__ to allow the
compiler to elide the comma when using

	printk_in_rcu("Hello World!");

> +		rcu_read_unlock();		\
> +	} while (0)
> +
> +/**
> + * printk_ratelimited_in_rcu() - printk_ratelimited in an RCU read-side critical
> + * section
> + */
> +#define printk_ratelimited_in_rcu(fmt, ...)		\
> +	do {						\
> +		rcu_read_lock();			\
> +		printk_ratelimited(fmt, __VA_ARGS__);	\
> +		rcu_read_unlock();			\
> +	} while (0)
> +
> +#endif

Here too

