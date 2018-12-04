Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AB0C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 967DD2082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:34:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 967DD2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbeLDKen (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:34:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:39550 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeLDKen (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 05:34:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 369A9B04D
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 10:34:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5D766DA907; Tue,  4 Dec 2018 11:34:20 +0100 (CET)
Date:   Tue, 4 Dec 2018 11:34:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs-progs: image: Fix error when restoring
 multi-disk image to single disk
Message-ID: <20181204103419.GG17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127083828.23861-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 04:38:23PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/image_recover
> 
> The base commit is as usual, the latest stable tag, v4.19.
> 
> 
> Test case misc/021 will fail if using latest upstream kernel.
> 
> This is due to the enhanced code in kernel to check block group <->
> chunk <-> dev extent mapping.
> 
> This means from the very beginning, btrfs-image can't really restore a
> multi-disk image to single-disk one correctly.
> 
> The problem is, although we modified chunk item, we didn't modify block
> group item's flags or dev extents.
> 
> This patch will reset block group flags, then rebuild the whole
> dev extents by removing existing ones first, then re-add the correct
> dev extents calculated from chunk map.
> 
> Now it could pass all misc tests and fsck tests.
> 
> Changelog:
> v2:
> - Parameter list cleanup
>   * Use trans->fs_info to remove fs_info parameter
>   * Remove trans parameter for function who doesn't need
> - Merge dev extents removal code with rebuild code
> - Refactor btrfs_alloc_dev_extent() into 2 functions
>   * btrfs_insert_dev_extent() for convert and dev extent rebuild
>   * btrfs_alloc_dev_extent() for old use case
>   
> Qu Wenruo (5):
>   btrfs-progs: image: Refactor fixup_devices() to
>     fixup_chunks_and_devices()
>   btrfs-progs: image: Fix block group item flags when restoring
>     multi-device image to single device
>   btrfs-progs: volumes: Refactor btrfs_alloc_dev_extent() into two
>     functions
>   btrfs-progs: image: Remove all existing dev extents for later rebuild
>   btrfs-progs: misc-tests/021: Do extra btrfs check before mounting

Merged to devel, thanks. I've switched strerror(-ret) to the errno
pattern.
