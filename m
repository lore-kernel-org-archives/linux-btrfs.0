Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757562AbdJKR7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:59:38 -0400
Date: Wed, 11 Oct 2017 19:57:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH v4 0/5] Enhance tree block validation checker
Message-ID: <20171011175752.GB3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 09, 2017 at 01:51:01AM +0000, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/checker_enhance
> 
> It's based on David's misc-next branch, with following commit as base:
> a5e50b4b444c ("btrfs: Add checker for EXTENT_CSUM")
> 
> According to David's suggestion, enhance the output format of tree block
> validation checker.
> 
> And move them into separate files: tree-checker.[ch].
> 
> Also added a output format rule to try to make all output message
> follow the same format.
> 
> Some example output using btrfs-progs fsck-test images looks like:
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
> v4:
>   Code style change suggested by David.
>   Use more easy-to-understand error message for NULL node pointer,
>   suggested by Nikolay.
>   Helper macro enhancement, including naming change and argument
>   protection suggested by David.
>   Separate tree-checker.h suggested by David.

Patches merged to the devel queue, with updates. The strings that
overflow 80 chars should be un-indented, plase do that in future
patches. Thanks.
