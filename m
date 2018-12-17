Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756EEC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 18:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EF0D20874
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 18:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbeLQSzg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 13:55:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:33858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728301AbeLQSzf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 13:55:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 319C3ACAB
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 18:55:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 26330DA9C3; Mon, 17 Dec 2018 19:55:11 +0100 (CET)
Date:   Mon, 17 Dec 2018 19:55:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/6] btrfs-progs: check: Detect invalid dev extents
 and device items
Message-ID: <20181217185510.GT23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181008123044.13413-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008123044.13413-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 08, 2018 at 08:30:38PM +0800, Qu Wenruo wrote:
> This patchset can be fetch from github:
> https://github.com/adam900710/btrfs-progs/tree/dev_extents_check
> 
> Hans van Kranenburg reported a case where btrfs DUP chunk allocator
> could allocate invalid dev extents, either overlaps with existing dev
> extents or beyond device boundary.
> 
> This patchset enhances the btrfs-progs side to detect such problems.
> With hand crafted test image for it.
> 
> Link: https://www.spinics.net/lists/linux-btrfs/msg82370.html
> 
> Changelog:
> v2:
>   Fix a bug in the 1st patch which makes lowmem mode never checks
>   overlap dev extents.
>   Fix test case bug which never passes due to wrong script.
> v3:
>   Add btrfs-image fixes to make test cases happy.
> 
> Qu Wenruo (6):
>   btrfs-progs: image: Use correct device size when restoring
>   btrfs-progs: lowmem check: Add check for overlapping dev extents
>   btrfs-progs: original check: Add ability to detect bad dev extents
>   btrfs-progs: lowmem check: Add dev_item check for used bytes and total
>     bytes
>   btrfs-progs: original check: Add dev_item check for used bytes and
>     total bytes
>   btrfs-progs: fsck-tests: Add test image for dev extents beyond device
>     boundary

Added to devel with some fixups, thanks.
