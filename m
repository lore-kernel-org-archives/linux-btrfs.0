From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 08 Dec 2011 20:22:19 +0100
Message-ID: <1335463.NujyoKUyEg@venice>
References: <bb747e0c-d6d8-4f60-a3f6-cf64c856515e@mail.placs.net> <d0ff909c-00a0-4f34-a1dc-6be0a8fdd832@mail.placs.net> <slrnje12mm.7db.stephane.chazelas@spam.is.invalid>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnje12mm.7db.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 08 December, 2011 10:00:54 Stephane CHAZELAS wrote:
> Because of the same uuid, the btrfs commands like filesystem
> show will not always give sensible outputs. I tried to rename
> the fsid by changing it in the superblocks, but it looks like it
> is alsa included in a few other places where changing it
> manually breaks some checksums, so I guess someone would have to
> write a tool to do that job. I'm surprised it doesn't exist
> already (or maybe it does and I'm not aware of it?).

The fs-uuid is recorded in the header of every tree block.

>From fs/btrfs/ctree.h

[...]
/*
 * every tree block (leaf or node) starts with this header.
 */
struct btrfs_header {
        /* these first four must match the super block */
        u8 csum[BTRFS_CSUM_SIZE];
        u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
[...]

Moreover I would be worried more about the uuid of the device than the 
filesystem one...




-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
