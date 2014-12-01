Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40475 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaLADP7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 22:15:59 -0500
Received: by mail-pa0-f42.google.com with SMTP id et14so10141457pad.15
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 19:15:59 -0800 (PST)
Date: Sun, 30 Nov 2014 19:15:55 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Pranith Kumar <bobby.prani+lkml@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
Message-ID: <20141201031555.GB14040@mew>
References: <cover.1417335583.git.osandov@osandov.com>
 <6566ef127f0d7ad4d33dd90362dd76e431359ef8.1417335583.git.osandov@osandov.com>
 <CAJhHMCD6voVEry=CkSyu5FpjiYXzh1aWxNq2_gmxasHqgV+csA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJhHMCD6voVEry=CkSyu5FpjiYXzh1aWxNq2_gmxasHqgV+csA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 10:11:41AM -0500, Pranith Kumar wrote:
> On Sun, Nov 30, 2014 at 3:26 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > A naked read of the value of an RCU pointer isn't safe. Put the whole access in
> > an RCU critical section, not just the pointer dereference.
> >
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> 
> You can use rcu_access_pointer() in the if() condition check rather
> than increasing the read critical section. We should try to keep the
> critical section as small as possible.
> 
> Also, since we have rcu_str_deref() we can use that instead of
> rcu_dereference() on device->name. Thoughts?
> 
That's right, I forgot about rcu_access_pointer. The difference is probably
negligible, and I doubt the performance of this ioctl is very important. Since
we're going to be dereferencing the pointer anyways in some (most?) cases, I
think this is a bit more readable.

-- 
Omar
