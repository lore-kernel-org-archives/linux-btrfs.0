Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37907 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaI0Fpc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 01:45:32 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so4685512pab.18
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 22:45:32 -0700 (PDT)
Date: Fri, 26 Sep 2014 22:46:34 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Move BTRFS RCU string to common library
Message-ID: <20140927054634.GA8516@molino.home.network>
References: <cover.1411796033.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1411796033.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 26, 2014 at 10:36:47PM -0700, Omar Sandoval wrote:
> This patch series makes the generic RCU string library used internally by BTRFS
> accessible by anyone.
> 
> The first patch makes printk_ratelimited pass on the return value from printk.
> Version 3 gives the temporary return variable a unique name to avoid name
> clashes.
> 
> The second patch moves the RCU string header and updates the BTRFS code that
> depends on it. Version 3 adds the __rcu annotation to the relevant functions.
> 
> Version 3 also adds Paul's ack and Josh's review.
> 
> Omar Sandoval (2):
>   Return a value from printk_ratelimited
>   Move BTRFS RCU string to common library
> 
>  fs/btrfs/check-integrity.c |  6 +--
>  fs/btrfs/dev-replace.c     | 19 +++++-----
>  fs/btrfs/disk-io.c         |  6 +--
>  fs/btrfs/extent_io.c       |  4 +-
>  fs/btrfs/ioctl.c           |  4 +-
>  fs/btrfs/raid56.c          |  2 +-
>  fs/btrfs/rcu-string.h      | 56 ----------------------------
>  fs/btrfs/scrub.c           | 15 ++++----
>  fs/btrfs/super.c           |  2 +-
>  fs/btrfs/volumes.c         | 14 +++----
>  include/linux/printk.h     |  4 +-
>  include/linux/rcustring.h  | 92 ++++++++++++++++++++++++++++++++++++++++++++++
>  12 files changed, 132 insertions(+), 92 deletions(-)
>  delete mode 100644 fs/btrfs/rcu-string.h
>  create mode 100644 include/linux/rcustring.h
> 

I forgot to mention: this patch series is against 3.17-rc6.

-- 
Omar
