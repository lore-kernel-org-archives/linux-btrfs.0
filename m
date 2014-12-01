Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61412 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaLACwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 21:52:09 -0500
Received: by mail-pd0-f182.google.com with SMTP id r10so9982836pdi.27
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 18:52:09 -0800 (PST)
Date: Sun, 30 Nov 2014 18:52:05 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: refactor btrfs_device->name updates
Message-ID: <20141201025205.GA14040@mew>
References: <cover.1417335583.git.osandov@osandov.com>
 <8881abdb8836e2d70f705baacc0fe491e75d66d4.1417335583.git.osandov@osandov.com>
 <CAJhHMCDNtQi0y8iYBXVJGwUAyK_sT74KmoZ-RwV_J0JPV3SgAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJhHMCDNtQi0y8iYBXVJGwUAyK_sT74KmoZ-RwV_J0JPV3SgAA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 10:26:43AM -0500, Pranith Kumar wrote:
> On Sun, Nov 30, 2014 at 3:26 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > The rcu_string API introduced some new sparse errors but also revealed existing
> > ones. First of all, the name in struct btrfs_device should be annotated as
> > __rcu to prevent unsafe reads. Additionally, updates should go through
> > rcu_dereference_protected to make it clear what's going on. This introduces
> > some helper functions that factor out this functionality.
> >
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index 6e04f27..2298a70 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -54,7 +54,7 @@ struct btrfs_device {
> >
> >         struct btrfs_root *dev_root;
> >
> > -       struct rcu_string *name;
> > +       struct rcu_string __rcu *name;
> >
> >         u64 generation;
> >
> 
> Since rcu_strings are rcu specific, why not annotate the char pointer
> in 'struct rcu_string' with __rcu annotation? That should catch all
> error-prone users of rcu_string.
> 
Because the whole structure is RCU'd, not just the str part of it. If str is
annotated as __rcu, when we (correctly) rcu_dereference an rcu_string and then
access the str member, we'll still get sparse warnings.

In any case, the above code does what I want it to do. See the following
(non-sense but illustrative) example:

#include <linux/rcustring.h>

static void example_func(void)
{
	struct rcu_string __rcu *example;
	char *str;
	str = example->str;
}

  CHECK   /home/osandov/linux/example/example.c
/home/osandov/linux/example/example.c:7:13: warning: incorrect type in assignment (different address spaces)
/home/osandov/linux/example/example.c:7:13:    expected char *str
/home/osandov/linux/example/example.c:7:13:    got char [noderef] <asn:4>*<noident>

-- 
Omar
