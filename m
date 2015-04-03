Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33210 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbDCVIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 17:08:39 -0400
Received: by pdbnk13 with SMTP id nk13so52406958pdb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 14:08:38 -0700 (PDT)
Date: Fri, 3 Apr 2015 14:08:37 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, "Eric W. Biederman" <ebiederm@xmission.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Timo Kokkonen <timo.kokkonen@offcode.fi>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: prevent deletion of mounted subvolumes
Message-ID: <20150403210837.GA13535@mew.dhcp4.washington.edu>
References: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
 <20150330123034.GB32051@suse.cz>
 <20150330184135.GA27227@mew.dhcp4.washington.edu>
 <87k2xwv6y8.fsf@x220.int.ebiederm.org>
 <20150401070328.GA27048@mew>
 <20150401112242.GG6821@suse.cz>
 <20150402034954.GA25368@mew.Belkin>
 <20150402150225.GJ6821@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150402150225.GJ6821@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 02, 2015 at 05:02:25PM +0200, David Sterba wrote:
> On Wed, Apr 01, 2015 at 08:49:54PM -0700, Omar Sandoval wrote:
> > Hm, yeah, that's unfortunate, thanks for pointing that out. It looks
> > like we can get the subvolume ID reliably:
> > 
> > ----
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 05fef19..a74ddb3 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -1024,6 +1024,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
> >  	struct btrfs_root *root = info->tree_root;
> >  	char *compress_type;
> >  
> > +	seq_printf(seq, ",subvolid=%llu",
> > +		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
> 
> yes, subvolid is reliable, but not very friendly from users' POV. I'd
> like to see subvol=/path there. Possibly we can have both.

So are you saying that we should try to fix the bug in userspace by
first getting subvol/subvolid in /proc/mounts, or do you want to keep
that a separate issue? Just asking because you didn't comment on the
kernel-side fix. Here's a concrete implementation of what I'm talking
about: https://github.com/osandov/linux/tree/btrfs-delete-mounted-subvol.

-- 
Omar
