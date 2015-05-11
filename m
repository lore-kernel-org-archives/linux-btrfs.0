Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbbEKPh1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 11:37:27 -0400
Date: Mon, 11 May 2015 17:37:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 5/6] Btrfs: unify subvol= and subvolid= mounting
Message-ID: <20150511153724.GO23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <074cb88847c0034aa1fc28f78f69c3dd1d5bd938.1428614837.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <074cb88847c0034aa1fc28f78f69c3dd1d5bd938.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:34:55PM -0700, Omar Sandoval wrote:
> @@ -1321,7 +1438,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		return ERR_PTR(error);
>  	}
>  
> -	if (subvol_name) {
> +	if (subvol_name || subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
>  		/* mount_subvol() will free subvol_name. */
>  		return mount_subvol(subvol_name, subvol_objectid, flags,
>  				    device_name, data);

The story is that I've used this patchset as a base for my per-subvolume
mount flags because it made the mount path cleaner, so it's possible that
the issue I saw was related to my changes.

The modified 'if' above did not catch subvol_objectid == 0. I'm not sure
now how it got there, btrfs_parse_early_options recognizes 0 and
switches it to 5.

My testing script is quite simple and does only

  mount -o compress-force=lzo,subvol=/subv1 $dev mnt
  mount -o compress-force=zlib,subvol=/subv2 $dev mnt2

after mkfs. The first pass would resolve the path to the subvol root and
replace the options with subvolid=0, calls mount_subvol, vfs_kern_mount
than in turn goes back to btrfs_mount. Unless I'm missing something,
this should also work, because parse_early_options is called again and
does subvolid=0 -> subvol_objectid=5 . Oh well, more debugging needed,
not a blocker for this patchset.
