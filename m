Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:38188 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753409AbdGXOCc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:02:32 -0400
Received: by mail-qk0-f193.google.com with SMTP id t2so9985825qkc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 07:02:32 -0700 (PDT)
Date: Mon, 24 Jul 2017 10:02:30 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: dsterba@suse.cz, josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/3] btrfs: don't allow trans ioctl on a directory
Message-ID: <20170724140229.GC9406@destiny>
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
 <20170724124229.GQ2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170724124229.GQ2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 02:42:29PM +0200, David Sterba wrote:
> On Fri, Jul 21, 2017 at 01:29:07PM -0400, josef@toxicpanda.com wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > We need to use file->private_data for readdir on directories, so just
> > don't allow user space transactions on directories.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/ioctl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index bedeec6..ddb3811 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -3968,6 +3968,9 @@ static long btrfs_ioctl_trans_start(struct file *file)
> >  	struct btrfs_trans_handle *trans;
> >  	int ret;
> >  
> > +	if (S_ISDIR(inode->i_mode))
> > +		return -EINVAL;
> 
> You can't do this, starting a transaction on a directory needs to work.
> The most natural way to run the ioctl is on the mount point.
> 
> The file private data would need to be able to hold multipe values, so
> you can add
> 
> struct btrfs_inode {
> 	...
> 	struct priv_data {
> 		void *for_readdir;
> 		void *for_tranc_ioctl;
> 	};
> 	...
> };
> 
> then set file->file_private = &btrfs_inode->priv_data; and update all
> uses to check for the embedded pointers.
> 

Blah I really want to just jetison the user space transaction stuff altogether
so I was hoping this would be a first step.  But yeah we can do it your way too.
Thanks,

Josef
