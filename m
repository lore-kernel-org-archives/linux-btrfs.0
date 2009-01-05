From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs filesystem freeze
Date: Mon, 05 Jan 2009 16:24:55 -0500
Message-ID: <1231190695.4290.148.camel@think.oraclecorp.com>
References: <551034715@web.de> <494EE585.5090209@oracle.com>
	 <1231170278.4290.85.camel@think.oraclecorp.com>
	 <3d0408630901051314i12ead163ye6936424a40047b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: devzero@web.de, linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630901051314i12ead163ye6936424a40047b5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 05:14 +0800, Yan Zheng wrote:
> 2009/1/5 Chris Mason <chris.mason@oracle.com>:

> > Which call to iput is causing problems?  We're going to run into
> > starvation problems if file deletes use join.
> >
> 
> btrfs_commit_transaction->create_pending_snapshots->
> create_pending_snapshot->btrfs_lookup_dentry->
> fixup_tree_root_location->btrfs_read_fs_root->
> btrfs_read_fs_root_no_name->btrfs_orphan_cleanup->iput

Ugh.  we need to move the orphan cleanup out of the read_fs_root calls.
Could you please move it to the cleaner_kthread?  Just run through the
dirty roots and call the orphan cleanup on each.

-chris


