Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7410DC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 11:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E88B20874
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 11:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbeLRLvq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 06:51:46 -0500
Received: from mout.gmx.net ([212.227.15.19]:58723 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbeLRLvp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 06:51:45 -0500
Received: from Damenlys-MBP.lan ([180.102.114.90]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lk8CY-1h6ciZ3X0U-00cBJj; Tue, 18
 Dec 2018 12:51:38 +0100
Subject: Re: [PATCH 00/13] btrfs-progs: check: Fix
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181218104646.29599-1-wqu@suse.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <2e3efeb4-e985-d7f6-f115-4f40e30724b9@gmx.com>
Date:   Tue, 18 Dec 2018 19:51:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20181218104646.29599-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lV49HN1ogc6wxdjJzkSQLksVFNVA8Tv1/1We0gayA9mcaQqIgDM
 MJz51CfgN8Rk/jRETNFafc03FHw3Y67LFSYCiQCP/CYufqo/VJAjlGS1a0+dsX5bxZ2QqA1
 C11FK5u0vCCxwJ5dPetaidvpswnZfSfykJPcxnUT6jqDFYedFNTeX9rJUQvudyh2KAX+47+
 w94+tQa+SlYVAggoTZX1Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CRB8ed/D4Ks=:m3GimaLNx5FKroBp5p5swU
 kI+bzgRUbEMXkT6LXcTt4/jsYW5VtAivsOpYZ0hO65Fsu/uiAyQbLibGF87oQsCsIwml1o2fh
 9PiYfc5sIgzp0pjW9P2pwK4d5P0RRzStkeiAoQEg341t+rbp7mLgvB9ZU8NBmNHBi8ehYZtMK
 7LBJ88D+iAR2kMp3qLdSR2fFdSsc4WU/oVp/ckoKYIv1Ml1FoZQgumCjlBRdWy05vNWHC0CTf
 XIG5IIRBUZEiyPzyQ4YCcMbqZt9pdGFcInx5sy9dFNN8kU5WMtgwbR8Uj58vO8nhZbb9dCoSs
 djobwGp3xTPackV52nJzgTXBCei5dP6Q0PuP9xxtm7N7Bd9Opa7wHMJCaSQey0NAOEh1hvOhs
 GFf+HtGt7ixkFOtnysSX258w2PmK1xIWXXWbhtBByE45Z3AMH774tSShttKW5yKXnUHkOY6P2
 RBSZx0D9+CmlmRxu1uWP5Pu4HNa9TUHJDydlojfsWGi1gcy5Mrcn4a6PPEKd8ANYLqB/HeWpL
 r16WlQd2x+KICg2vzZ9WINJJ70f+brYMofNo46TILoVd0irArZLvQOWwxnZVlVjUdLi/c0UT5
 KZ0+Lv4wEC96yGRJDYMvTMVm/Zv6Tdc0sd0HsWlMSympnO1I03rC0h3iNwdIzigQ4Afi7vWSf
 2d2CBexmms9/JT/vua553gWbqm1pN2wBZ3Ux/yb5tQKCVrl1oI4cF4hSXJFtPYIkLqwij2Mr2
 6zfK231GxcOW70V7rZ+2YpscsHtW9fZIb7hNg9l7U179CX6ncFCVbbJeUMJwCEKgcpd7PRqi8
 2LbQ4NopLPk6TzwLZc4iXep+QIup9chn2INK/v6RikKSVSCmi5S5bEyaac7tEY9jbGBpEo+oc
 Q9Mgc2j+dSfpRfvhaXCq2t+ADb9CYSlRJOcRXgeNGg8zrMeFPSqXkHOVR4EXCY
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/18 6:46 PM, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/file_extents_fixes
> 
> The base commit is devel branch:
> commit e1e7519c2d225554004b55a5c19eb196db92285a (david/devel)
> Author: Qu Wenruo <wqu@suse.com>
> Date:   Thu Oct 25 15:35:47 2018 +0800
> 
>      btrfs-progs: tests: check: Make 026-bad-dir-item-name verify if btrfs-check can also repair
>      
>      Just remove the customized 'test.sh', then generic fsck test will do the
>      check-repair-check.
> 
> Originally for fsck-tests/001-bad-file-extent-bytenr we're going to fix
> it by resetting the corrupted file extent, using the disk bytenr from
> data backref.
> 
> However in real world, extent tree is the most fragile one while fs tree
> is more reliable.
> This means fixing using extent tree can sometimes be more dangerous, and
> causing extra corruption from repair.
> 
> Further more, that test case is a big blockage for any later
> modification on file extent repair code.
> 
> So the goal of this patchset is to change the repair behavior from
> rebuilding file extents using data backref, to dropping invalid file
> extents and modify extent tree.
> 
> Despite above change, we have some small bug fixes for:
> - False alert for file extents gap
> - Bad data backref -> file extent search in repair mode
> 
> The patchset is mostly from Fujitsu guys (Lu, Su Yue, Su Yanjun).
> My work here is:

Thanks a lot for your nice work.


Su

> - Solve rebase conflicts
>    Mostly with DIR_ITEM hash mismatch patchset
> 
> - Commit message/comment update
>    Make them a little more reader friendly
> 
> - Reorder the patchset
>    Make small fixes first.
> 
> Lu Fengqi (2):
>    btrfs-progs: lowmem: fix false alert about the existence of gaps in
>      the check_file_extent
>    btrfs-progs: tests: add case for inode lose one file extent
> 
> Su Yanjun (4):
>    btrfs-progs: Revert "btrfs-progs: Add repair and report function for
>      orphan file extent."
>    btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to
>      corresponding root."
>    btrfs-progs: check: fix wrong @offset used in find_possible_backrefs()
>    btrfs-progs: check: Delete file extent item with unaligned disk bytenr
> 
> Su Yue (7):
>    btrfs-progs: lowmem: add argument path to punch_extent_hole()
>    btrfs-progs: lowmem: move nbytes check before isize check
>    btrfs-progs: lowmem: fix false alert if extent item has been repaired
>    btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
>    btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
>    btrfs-progs: lowmem: delete unaligned bytes extent data under repair
>    btrfs-progs: fsck-test: enable lowmem repair for case 001
> 
>   check/main.c                                  | 584 +++++++++++-------
>   check/mode-lowmem.c                           | 293 +++++----
>   check/mode-original.h                         |  30 +-
>   ctree.h                                       |  10 +-
>   disk-io.c                                     |   2 +-
>   .../.lowmem_repairable                        |   0
>   .../.lowmem_repairable                        |   0
>   .../default_case.img                          | Bin 0 -> 3072 bytes
>   8 files changed, 543 insertions(+), 376 deletions(-)
>   create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable
>   create mode 100644 tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
>   create mode 100644 tests/fsck-tests/038-missing-one-file-extent/default_case.img
> 
