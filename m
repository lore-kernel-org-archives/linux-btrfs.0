Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56131C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DAC020811
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfC1Pqv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:46:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:50360 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726108AbfC1Pqv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:46:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1CEC9AC31;
        Thu, 28 Mar 2019 15:46:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 460DDDA8D8; Thu, 28 Mar 2019 16:48:02 +0100 (CET)
Date:   Thu, 28 Mar 2019 16:48:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCh v2 0/9] btrfs: tree-checker: More enhancement for fuzzed
Message-ID: <20190328154802.GN29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320063717.31770-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:37:08PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> It can be fetched from github:
> https://github.com/adam900710/linux/tree/tree_checker_enhancement
> Which is based on my previous write time tree checker patchset (based on
> v5.1-rc1 tag)
> 
> Thanks for the report from Yoon Jungyeon <jungyeon@gatech.edu>, we have
> more fuzzed image to torture btrfs.
> 
> Those images exposed the following problems:
> 
> - Chunk check is not comprehensive nor early enough
>   Chunk item check lacks profile bits check (e.g RAID|DUP profile is
>   invalid).
>   And for certain fuzzed image, the other copy can be valid, current
>   check timming is after tree block read, so no way to retry the other
>   copy.
> 
>   Address the check timing in the 1st~4th patch, while for the profile bits,
>   check it in the 7th patch.
> 
> - Lack of device item check
>   Address it in the 5nd patch.
> 
> - First key and level check be exploited by cached extent buffer
>   Cached bad extent buffer can avoid first key and level check.
>   This is addressed in the 6rd patch.
> 
> - Inode type mismatch can lead to NULL dereference in endio function
>   If an inode claims itself as symlink but still has regular file
>   extent, then endio function will cause NULL pointer dereference.
>   Fix it by do extra inode mode and dir item type cross check, at
>   get_extent() time and inode lookup time.
>   Addressed in the last 2 patches.
> 
> Changelog:
> v2:
> - Split patches for btrfs_check_chunk_valid() merge into tree-checker.
> - Rebase to v5.1-rc1 based write_time_tree_checker branch.
> - Add reviewed-by tags.
> 
> Qu Wenruo (9):
>   btrfs: Move btrfs_check_chunk_valid() to tree-check.[ch] and export it
>   btrfs: tree-checker: Make chunk item checker more readable
>   btrfs: tree-checker: Make btrfs_check_chunk_valid() return EUCLEAN
>     instead of EIO
>   btrfs: tree-checker: Check chunk item at tree block read time
>   btrfs: tree-checker: Verify dev item
>   btrfs: Check the first key and level for cached extent buffer
>   btrfs: tree-checker: Enhance chunk checker to validate chunk profiler
>   btrfs: tree-checker: Verify inode item
>   btrfs: inode: Verify inode mode to avoid NULL pointer dereference

Patchset merged to misc-next, thanks. There were some fixups to comments
and changelogs. The inode item check part that checks nlink is
unchanged, it'll be removed eventually when we agree that on the reasoning
behind it.
