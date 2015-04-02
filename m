Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33841 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbbDBDt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 23:49:57 -0400
Received: by pdbni2 with SMTP id ni2so75961009pdb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 20:49:56 -0700 (PDT)
Date: Wed, 1 Apr 2015 20:49:54 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Timo Kokkonen <timo.kokkonen@offcode.fi>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: prevent deletion of mounted subvolumes
Message-ID: <20150402034954.GA25368@mew.Belkin>
References: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
 <20150330123034.GB32051@suse.cz>
 <20150330184135.GA27227@mew.dhcp4.washington.edu>
 <87k2xwv6y8.fsf@x220.int.ebiederm.org>
 <20150401070328.GA27048@mew>
 <20150401112242.GG6821@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150401112242.GG6821@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 01, 2015 at 01:22:42PM +0200, David Sterba wrote:
> On Wed, Apr 01, 2015 at 12:03:28AM -0700, Omar Sandoval wrote:
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -1024,6 +1024,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
> >  	struct btrfs_root *root = info->tree_root;
> >  	char *compress_type;
> >  
> > +	if (dentry != dentry->d_sb->s_root) {
> > +		seq_puts(seq, ",subvol=");
> > +		seq_dentry(seq, dentry, " \t\n\\");
> 
> Unfortunatelly this does not work if the default subvolume is not the
> toplevel one and the implicit mount (ie. without subvol=) is used. Then
> this leads to subvol=/ although it should be subvol=/the/default .
> 
> There was a patch to build the path in the show_options callback, but it
> looked too heavy (taking locks, doing lookups). This is unrelated to the
> problem reported by Timo, though the fix might also fix this one.

Hm, yeah, that's unfortunate, thanks for pointing that out. It looks
like we can get the subvolume ID reliably:

----
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef19..a74ddb3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1024,6 +1024,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	struct btrfs_root *root = info->tree_root;
 	char *compress_type;
 
+	seq_printf(seq, ",subvolid=%llu",
+		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	if (btrfs_test_opt(root, DEGRADED))
 		seq_puts(seq, ",degraded");
 	if (btrfs_test_opt(root, NODATASUM))
----

With that, userspace has enough information to determine whether a
subvolume is mounted. That would be racy with concurrent mounts,
though...

Just to throw another idea out there, what about doing something like my
VFS patch, but then making it optional whether the kernel should error
out on a mounted subvolume, e.g., with a flag to the ioctl? btrfs-progs
could default to the original EBUSY behavior for users who depend on it,
but we could add a "force" flag to `btrfs subvolume delete` in order to
avert the DoS situation Eric wants to avoid. Thoughts on that?

-- 
Omar
