Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab2FLNXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 09:23:13 -0400
Date: Tue, 12 Jun 2012 09:23:08 -0400
From: Josef Bacik <josef@redhat.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com
Subject: Re: [PATCH 2/2] Btrfs: implement ->show_devname
Message-ID: <20120612132307.GA1565@localhost.localdomain>
References: <1338920193-7843-1-git-send-email-josef@redhat.com>
 <1338920193-7843-2-git-send-email-josef@redhat.com>
 <4FD6F0B5.3000703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD6F0B5.3000703@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 03:33:09PM +0800, Miao Xie wrote:
> On tue, 5 Jun 2012 14:16:33 -0400, Josef Bacik wrote:
> > Because btrfs can remove the device that was mounted we need to have a
> > ->show_devname so that in this case we can print out some other device in
> > the file system to /proc/mount.  We keep track of what device we called
> > mount() with so that we can print out the correct one if it is still
> > available, but otherwise we just pick the first device that has the lowest
> > device id.  This was inspired (and copied in the case of btrfs_show_devname)
> > from Miao Xie's patch.  Thanks,
> 
> In fact, it is hard  to keep track of the device that was mounted although we
> add a flag to mark it unless we pass ->mnt_devname into ->show_devname(). For
> example:
>   # mkfs.btrfs <disk1> <disk2>
>   # mount <disk1> <mnt1>
>   # mount <disk2> <mnt2>
>   # cat /proc/mounts
>   <disk2> <mnt1> ...
>   <disk2> <mnt2> ...
> 
> The mounted device of the first mount operation was changed.
> 
> Maybe we are overnice, and we needn't keep track of that device, and just
> print out the name of the device which has the lowest device id.
> 

Hah oops didn't think of that.  I think you are right, doing the lowest dev id
is probably the most consistent thing to do, what do you think Chris?  Thanks,

Josef
