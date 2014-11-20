Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34365 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbaKTWK6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 17:10:58 -0500
Received: by mail-pd0-f170.google.com with SMTP id fp1so3867315pdb.15
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 14:10:58 -0800 (PST)
Date: Thu, 20 Nov 2014 14:10:50 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7] Move BTRFS RCU string to common library
Message-ID: <20141120221050.GA15560@mew.dhcp4.washington.edu>
References: <1415463217.23530.26.camel@perches.com>
 <1415873901-5618-1-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415873901-5618-1-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 13, 2014 at 02:18:21AM -0800, Omar Sandoval wrote:
> The RCU-friendly string API used internally by BTRFS is generic enough for
> common use. This doesn't add any new functionality, but instead just moves the
> code and documents the existing API.
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> Alright, here's one more go at it.
> 
> v7: Add arguments to kernel doc for printk wrappers, use ##__VA_ARGS
> v6: Add header dependencies to rcustring.h
> v5: Rebase against v3.18-rc3
> v4: Don't return anything from the printk wrappers on the assumption that
> printk will return void someday
> v3: Add __rcu annotation to relevant functions, add Paul's ack and Josh's
> review
> 
>  fs/btrfs/check-integrity.c |  6 +--
>  fs/btrfs/dev-replace.c     | 19 ++++-----
>  fs/btrfs/disk-io.c         |  6 +--
>  fs/btrfs/extent_io.c       |  4 +-
>  fs/btrfs/ioctl.c           |  4 +-
>  fs/btrfs/raid56.c          |  2 +-
>  fs/btrfs/rcu-string.h      | 56 --------------------------
>  fs/btrfs/scrub.c           | 15 +++----
>  fs/btrfs/super.c           |  2 +-
>  fs/btrfs/volumes.c         | 14 +++----
>  include/linux/rcustring.h  | 99 ++++++++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 136 insertions(+), 91 deletions(-)
>  delete mode 100644 fs/btrfs/rcu-string.h
>  create mode 100644 include/linux/rcustring.h
> 
Ping -- does everything look good here?

-- 
Omar
