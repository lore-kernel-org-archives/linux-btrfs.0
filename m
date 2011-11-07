From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix double-free 'tree_root' in 'btrfs_mount()'
Date: Mon, 7 Nov 2011 10:57:20 -0500
Message-ID: <20111107155720.GB4265@shiny>
References: <1320657127-3561-1-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Arne Jansen <sensille@gmx.net>, David Sterba <dsterba@suse.cz>
To: slyich@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320657127-3561-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2011 at 12:12:07PM +0300, slyich@gmail.com wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> On error path 'tree_root' is treed in 'free_fs_info()'.
> No need to free it explicitely. Noticed by SLUB in debug mode:

Nice, thanks for the patch.

-chris
