From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Wed, 16 Mar 2011 15:07:36 -0700
Message-ID: <m2mxkulnx3.fsf@firstfloor.org>
References: <cover.1299941055.git.sensille@gmx.net>
	<7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net>
	(Arne Jansen's message of "Sat, 12 Mar 2011 15:50:42 +0100")
List-ID: <linux-btrfs.vger.kernel.org>


Arne Jansen <sensille@gmx.net> writes:
> +	 */
> +	mutex_lock(&fs_info->scrub_lock);
> +	atomic_inc(&fs_info->scrubs_running);
> +	mutex_unlock(&fs_info->scrub_lock);

It seems odd to protect an atomic_inc with a mutex. 
Is that done for some side effect? Otherwise you either
don't need atomic or don't need the lock.

That seems to be all over the source file.

> +int btrfs_scrub_pause(struct btrfs_root *root)
> +{
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	mutex_lock(&fs_info->scrub_lock);


As I understand it you take that mutex on every transaction
commit, which is a fast path for normal IO. 

For me that looks like a scalability problem with enough
cores. Did you do any performance testing of this on a system
with a reasonable number of cores?

btrfs already has enough scalability problems, please don't
add new ones.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
