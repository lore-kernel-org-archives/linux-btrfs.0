Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53541 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751766AbdJFRsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:48:08 -0400
Date: Fri, 6 Oct 2017 19:46:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH v3 0/5] Enhance tree block validation checker
Message-ID: <20171006174624.GA3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170929064849.15086-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170929064849.15086-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 06:48:44AM +0000, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/checker_enhance
> 
> It's based on David's misc-next branch, with following commit as base:
> a5e50b4b444c ("btrfs: Add checker for EXTENT_CSUM")
> 
> According to David's suggestion, enhance the output format of tree block
> validation checker.
> 
> And move them into one separate file: tree-checker.c.
> 
> Also added a output format rule to try to make all output message
> follow the same format.
> 
> Some example output using btrfsck fsck-test images looks like:
> 
> For unagliend file extent member:
> ---
> BTRFS critical (device loop0): corrupt leaf: root=1 block=29360128 slot=7 ino=257 file_offset=0, invalid disk_bytenr for file extent, have 755944791, should be aligned to 4096
> ---
> 
> For bad leaf holes:
> ---
> BTRFS critical (device loop0): corrupt leaf: root=1 block=29360128 slot=28, discontinious item end, have 9387 expect 15018
> ---
> 
> Changelog:
> v2:
>   Unify the error string format, so it should be easier to grep them
>   from dmesg. Thanks Nikolay for pointing this out.
>   Remove unused CORRUPT() macro.
> v3:
>   Replace EIO with EUCLEAN in 2nd patch. Thanks Nikolay for pointing
>   this out.
>   Correct "btrfs-progs:" to "btrfs:" for 1st patch.
> 
> Qu Wenruo (5):
>   btrfs: Move leaf and node validation checker to tree-checker.c
>   btrfs: tree-checker: Enhance btrfs_check_node output
>   btrfs: tree-checker: Enhance output for btrfs_check_leaf
>   btrfs: tree-checker: Enhance output for check_csum_item
>   btrfs: tree-checker: Enhance output for check_extent_data_item

As the comments are mostly cosmetic, I'm going to add V3 to for-next so
we have more testing coverage and expecting v4.
