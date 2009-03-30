From: Andi Kleen <andi@firstfloor.org>
Subject: Re: PATCH] btrfs: Check transaction start
Date: Mon, 30 Mar 2009 19:39:44 +0200
Message-ID: <873acunc4f.fsf@basil.nowhere.org>
References: <499392D4.5020709@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <499392D4.5020709@suse.com> (Jeff Mahoney's message of "Wed, 11 Feb 2009 22:09:08 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Jeff Mahoney <jeffm@suse.com> writes:
>  		wake_up_process(root->fs_info->cleaner_kthread);
> @@ -2197,10 +2199,12 @@ int btrfs_commit_super(struct btrfs_root
>  	btrfs_clean_old_snapshots(root);
>  	mutex_unlock(&root->fs_info->cleaner_mutex);
>  	trans = btrfs_start_transaction(root, 1);
> +	BUG_ON(IS_ERR(trans));

Would it make sense to use a different macro for things that
are expected to be fixed later? BUG_ON_I_SUCK() or TMP_BUG_ON() or 
something like that?
I think that would make it clearer that things are only temporary.
At least it should be documented somewhere.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
