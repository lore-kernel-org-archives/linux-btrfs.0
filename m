Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54398 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaK3P1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 10:27:14 -0500
MIME-Version: 1.0
In-Reply-To: <8881abdb8836e2d70f705baacc0fe491e75d66d4.1417335583.git.osandov@osandov.com>
References: <cover.1417335583.git.osandov@osandov.com> <8881abdb8836e2d70f705baacc0fe491e75d66d4.1417335583.git.osandov@osandov.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 30 Nov 2014 10:26:43 -0500
Message-ID: <CAJhHMCDNtQi0y8iYBXVJGwUAyK_sT74KmoZ-RwV_J0JPV3SgAA@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: refactor btrfs_device->name updates
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 3:26 AM, Omar Sandoval <osandov@osandov.com> wrote:
> The rcu_string API introduced some new sparse errors but also revealed existing
> ones. First of all, the name in struct btrfs_device should be annotated as
> __rcu to prevent unsafe reads. Additionally, updates should go through
> rcu_dereference_protected to make it clear what's going on. This introduces
> some helper functions that factor out this functionality.
>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6e04f27..2298a70 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -54,7 +54,7 @@ struct btrfs_device {
>
>         struct btrfs_root *dev_root;
>
> -       struct rcu_string *name;
> +       struct rcu_string __rcu *name;
>
>         u64 generation;
>

Since rcu_strings are rcu specific, why not annotate the char pointer
in 'struct rcu_string' with __rcu annotation? That should catch all
error-prone users of rcu_string.

-- 
Pranith
