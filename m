Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47608 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaKIHcj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Nov 2014 02:32:39 -0500
Received: by mail-pd0-f172.google.com with SMTP id r10so5863021pdi.17
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Nov 2014 23:32:39 -0800 (PST)
Date: Sat, 8 Nov 2014 23:32:34 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Joe Perches <joe@perches.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6] Move BTRFS RCU string to common library
Message-ID: <20141109073234.GA28668@mew.home.network>
References: <1415407155.23530.24.camel@perches.com>
 <1415436384-13691-1-git-send-email-osandov@osandov.com>
 <1415463217.23530.26.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415463217.23530.26.camel@perches.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 08, 2014 at 08:13:37AM -0800, Joe Perches wrote:
> On Sat, 2014-11-08 at 00:46 -0800, Omar Sandoval wrote:
> > The RCU-friendly string API used internally by BTRFS is generic enough for
> > common use. This doesn't add any new functionality, but instead just moves the
> > code and documents the existing API.
> 
> Some more trivia, can be updated later if desired.
> 
> > diff --git a/include/linux/rcustring.h b/include/linux/rcustring.h
> > new file mode 100644
> []
> > +
> > +/**
> > + * printk_in_rcu() - printk in an RCU read-side critical section
> 
> It'd be nice to show the arguments for kernel-doc here
My impression is that referencing printk tells you everything you need to know,
but for completeness' sake, that sounds fair.

> > + */
> > +#define printk_in_rcu(fmt, ...)			\
> > +	do {					\
> > +		rcu_read_lock();		\
> > +		printk(fmt, __VA_ARGS__);	\
> 
> This should use ##__VA_ARGS__ to allow the
> compiler to elide the comma when using
> 
> 	printk_in_rcu("Hello World!");
> 
Luckily, there's probably no sane reason anyone would do a printk_in_rcu
without the varargs, but once again, it's probably good hygiene.

Anyone else have anything to add? Otherwise, I'll wrap this up in another
iteration of the patch.

Thanks!
-- 
Omar
