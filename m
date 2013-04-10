Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab3DJQO4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 12:14:56 -0400
Date: Wed, 10 Apr 2013 18:14:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
Message-ID: <20130410161452.GR18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net>
 <20130405130503.GR1876@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130405130503.GR1876@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 05, 2013 at 09:05:03AM -0400, Josef Bacik wrote:
> On Fri, Apr 05, 2013 at 05:38:16AM -0600, Jan Schmidt wrote:
> > +static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
> > +{
> > +       struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> > +       struct btrfs_ioctl_quota_rescan_args *qsa;
> > +       int ret = 0;
> > +
> > +       if (!capable(CAP_SYS_ADMIN))
> > +               return -EPERM;
> > +
> > +       qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
> > +       if (IS_ERR(qsa))
> > +               return PTR_ERR(qsa);
> > +
> 
> IIRC kzalloc returns NULL if something was wrong, not an ERR_PTR().  Thanks,

And we can get rid of kzalloc/kfree entirely,
btrfs_ioctl_quota_rescan_args is only 2x u64.

david
