From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] btrfs: fix double-free 'tree_root' in 'btrfs_mount()'
Date: Mon, 7 Nov 2011 04:10:05 -0500
Message-ID: <20111107091005.GA17056@infradead.org>
References: <1320657127-3561-1-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Arne Jansen <sensille@gmx.net>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: slyich@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320657127-3561-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2011 at 12:12:07PM +0300, slyich@gmail.com wrote:
>     bdev=/dev/ubda
>     btr_root=/btr
>     /mkfs.btrfs $bdev
>     mount $bdev $btr_root
>     mkdir $btr_root/subvols/
>     cd $btr_root/subvols/
>     /btrfs su cr foo
>     /btrfs su cr bar
>     mount $bdev -osubvol=subvols/foo $btr_root/subvols/bar
>     umount $btr_root/subvols/bar

Can you please send this as a new testcase for xfstests?

