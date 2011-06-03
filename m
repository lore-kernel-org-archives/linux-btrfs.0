From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH][RESEND] btrfs: separate superblock items out of fs_info
Date: Fri, 3 Jun 2011 18:36:43 +0200
Message-ID: <20110603163643.GV12709@twin.jikos.cz>
References: <1307031202-14029-1-git-send-email-dsterba@suse.cz>
 <20110602213643.6d62caef@sf>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110602213643.6d62caef@sf>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2011 at 09:36:43PM +0300, Sergei Trofimovich wrote:
> ...
> > @@ -801,6 +800,15 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
> >  	fs_info->fs_devices = fs_devices;
> >  	tree_root->fs_info = fs_info;
> >  
> > +	fs_info->super_copy = kzalloc(sizeof(struct btrfs_super_block),
> > +			GFP_NOFS);
> > +	fs_info->super_for_commit = kzalloc(sizeof(struct btrfs_super_block),
> > +			GFP_NOFS);
> 
> In light of http://thread.gmane.org/gmane.comp.file-systems.btrfs/11004/focus=11038
> what do you think of allocating BTRFS_SUPER_INFO_SIZE instead of sizeof?

that it's absolutely correct fix. Although allocator would provide a 4kb
buffer (slab) and the rest of the 2.5-4kb space would remain untouched,
this could bite later, when this assumption would not hold.

Passed through xfstests and a few fs_mark rounds.
Patch updated in git://repo.or.cz/linux-2.6/btrfs-unstable.git #cleanups


david
