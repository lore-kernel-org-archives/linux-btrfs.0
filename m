Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab3GQRtE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 13:49:04 -0400
Date: Wed, 17 Jul 2013 10:49:00 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] label cli hangs until balance is completed
Message-ID: <20130717174900.GD13965@lenny.home.zabbo.net>
References: <51E655D1.5020309@oracle.com>
 <51E65F5A.6050501@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51E65F5A.6050501@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 17, 2013 at 11:09:46AM +0200, Stefan Behrens wrote:
> On Wed, 17 Jul 2013 16:29:05 +0800, Anand Jain wrote:
> >  'btrfs fi label /btrfs' will hang until balance is completed.
> >  (and probably even set label would hang). This is because we
> >  are trying to hold volume_mutex lock which balance will hold
> >  during its tenure.
> > 
> > -------
> > static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
> > ::
> >         mutex_lock(&root->fs_info->volume_mutex);
> >         ret = copy_to_user(arg, label, len);
> >         mutex_unlock(&root->fs_info->volume_mutex);
> > --------
> > 
> >  I doubt if get label would need such a heavy weight lock?
> >  Do we have any other lock which could fit better here ?
> >  Any comments ?
> 
> Just use the uuid_mutex instead of the volume_mutex.

I wouldn't copy_to_user() with the lock held.  That nests all of readpage
and mkwrite under the mutex creating more possibilities for deadlocks.

Whatever lock is chosen, I'd have get copy the label onto the kernel
stack before sending it to user space.

- z
