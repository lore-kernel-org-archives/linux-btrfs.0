Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754878AbcKYS0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 13:26:45 -0500
Date: Fri, 25 Nov 2016 19:26:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/19] Offline scrub support
Message-ID: <20161125182633.GA12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have comments regarding the code organization, not really the raid56
functionality itself.

On Fri, Oct 28, 2016 at 10:31:36AM +0800, Qu Wenruo wrote:
> For any one who wants to try it, it can be get from my repo:
> https://github.com/adam900710/btrfs-progs/tree/fsck_scrub
> 
> Currently, I only tested it on SINGLE/DUP/RAID1/RAID5 filesystems, with
> mirror or parity or data corrupted.
> The tool are all able to detect them and give recoverbility report.
> 
> Several reports on kernel scrub screwing up good data stripes are in ML
> for sometime.
> 
> The reason seems to be lack of csum check before and after reconstruction, and
> unfinished parity write seems also involved.
> 
> To get a comparable tool for kernel scrub, we need a user-space tool to
> act as benchmark to compare their different behaviors.
> 
> So here is the RFC patch set for user-space scrub.
> 
> Which can do:
> 
> 1) All mirror/backup check for non-parity based stripe
>    Which means for RAID1/DUP/RAID10, we can really check all mirrors
>    other than the 1st good mirror.
> 
>    Current "--check-data-csum" option will be finally replace by scrub.
>    As it doesn't really check all mirrors, if it hits a good copy, then
>    resting copies will just be ignored.
> 
> 2) Comprehensive RAID5/6 full stripe check
>    It will take full use of btrfs csum(both tree and data).
>    It will only recover the full stripe if all recovered data matches
>    with its csum.
> 
> In fact, it can already expose one new btrfs kernel bug.
> For example, after screwing up a data stripe, kernel did repairs using
> parity, but recovered full stripe has wrong parity.
> Need to scrub again to fix it.
> 
> And this patchset also introduced new map_block() function, which is
> more flex than current btrfs_map_block(), and has a unified interface
> for all profiles.
> Check the 6th and 7th patch for details.
> 
> They are already used in RAID5/6 scrub, but can also be used for other
> profiles too.
> 
> The to-do list has been shortened, since RAID6 and new check logical is
> introduced.
> 1) Repair support
>    In fact, current tool can already report recoverability, repair is
>    not hard to implement.
> 
> 2) Test cases
>    Need to make the infrastructure able to handle multi-device first.
> 
> 3) Make btrfsck able to handle RAID5 with missing device
>    Now it doesn't even open RAID5 btrfs with missing device, even though
>    scrub should be able to handle it.
> 
> Changelog:
> V0.8 RFC:
>    Initial RFC patchset
> 
> v1:
>    First formal patchset.
>    RAID6 recovery support added, mainly copied from kernel radi6 lib.
>    Cleaner recovery logical.
> 
> Qu Wenruo (19):
>   btrfs-progs: raid56: Introduce raid56 header for later recovery usage
>   btrfs-progs: raid56: Introduce tables for RAID6 recovery
>   btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
>   btrfs-progs: raid56: Allow raid6 to recover data and p
>   btrfs-progs: Introduce wrapper to recover raid56 data
>   btrfs-progs: Introduce new btrfs_map_block function which returns more
>     unified result.

Any files copied from kernel sources must retain original license (ok),
and possibly mention the modifications in case we need to sync the files
in the future. If the file name is different from kernel, mention that
at the beginning of our local copy.

Move them to kernel-lib (also mktables).

Don't put the generic raid56 functions to the btrfs raid56.c file but
create another one in kernel-lib/.

>   btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
>   btrfs-progs: check/csum: Introduce function to read out one data csum
>   btrfs-progs: check/scrub: Introduce structures to support fsck scrub
>   btrfs-progs: check/scrub: Introduce function to scrub mirror based
>     tree block
>   btrfs-progs: check/scrub: Introduce function to scrub mirror based
>     data blocks
>   btrfs-progs: check/scrub: Introduce function to scrub one extent
>   btrfs-progs: check/scrub: Introduce function to scrub one data stripe
>   btrfs-progs: check/scrub: Introduce function to verify parities
>   btrfs-progs: extent-tree: Introduce function to check if there is any
>     extent in given range.
>   btrfs-progs: check/scrub: Introduce function to recover data parity
>   btrfs-progs: check/scrub: Introduce a function to scrub one full
>     stripe
>   btrfs-progs: check/scrub: Introduce function to check a whole block
>     group
>   btrfs-progs: fsck: Introduce offline scrub function

Most of the new functions are not documented and the changelog is not
very verbose either, it's highly desired to add the comments to the
functions describing what the function does in general.

Don't create the the subdirectory for check/, yet. I'll do that myself
soon, possibly within 4.9 release. Then the check/ directory will be
ready to take more code.

I don't like the --scrub argument added to check, as it's overloading
the subcommand too much. As we already have 'scrub' for kernel, we'll
have to come up with a better UI. For the time being, using --scrub as
you have now is fine, but will have to be changed.
