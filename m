Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab3AHROc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 12:14:32 -0500
Date: Tue, 8 Jan 2013 18:14:28 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: dsterba@suse.cz, util-linux@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
Message-ID: <20130108171427.GO20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50E9C267.3050302@inwind.it>
 <20130107163327.GK20089@twin.jikos.cz>
 <50EB11E0.8030403@tiscalinet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EB11E0.8030403@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 07:20:16PM +0100, Goffredo Baroncelli wrote:
> On 01/07/2013 05:33 PM, David Sterba wrote:
> > It can have as much as 4 superblock backup copies:
> > 
> > Superblock offset 0 is 65536 (0x10000, block=16/0x10)
> > Superblock offset 1 is 67108864 (0x4000000, block=16384/0x4000)
> > Superblock offset 2 is 274877906944 (0x4000000000, block=67108864/0x4000000)
> > Superblock offset 3 is 1125899906842624 (0x4000000000000, block=274877906944/0x4000000000)
> > Superblock offset 4 is 4611686018427387904 (0x4000000000000000, block=1125899906842624/0x4000000000000)
> 
> Are you sure ?
> 
> Regarding the btrfs-progs suite, I looked at the btrfs_read_dev_super():
> [..]
>         for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>                 bytenr = btrfs_sb_offset(i);
>                 ret = pread64(fd, &buf, sizeof(buf), bytenr);
> 
> Where BTRFS_SUPER_MIRROR_MAX is 3.

My bad, sorry, I was using the values from an old script that computed
the values with a wrong upper limit.

david
