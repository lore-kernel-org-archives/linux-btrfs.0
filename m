Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAFEC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 15:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7990320827
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 15:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7990320827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbeKFAfo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:35:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:37786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729349AbeKFAfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 19:35:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D3F8B023
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 15:15:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B73DDAF91; Mon,  5 Nov 2018 16:15:20 +0100 (CET)
Date:   Mon, 5 Nov 2018 16:15:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Enhance btrfs_verify_dev_extents() to do more
 checks on dev extents
Message-ID: <20181105151520.GX9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181005094555.31177-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005094555.31177-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 05:45:53PM +0800, Qu Wenruo wrote:
> Inspired by Hans' possible flawed DUP chunk allocator, add the following
> dev extents checker:
> 
> 1) Dev extent overlap check
>    Dev extents don't use extent_cache so it can't report dev extents
>    overlap.
>    So manually check dev extents overlap.
>    This check is pretty simple since we're already iterating dev extents
>    by its physical offset, we only need to remember previous checked dev
>    extents to do such check.
> 
> 2) Dev extent end check
>    No dev extent should go beyond device boundary.
> 
> These two checks are pretty cheap so it shouldn't bring any performance
> overhead.
> 
> Changelog:
> v2:
>   Add "Link:" tag for the first patch.
>   Move the actual check into verify_one_dev_extent() for the 2nd patch.

Moved from for-next topic branch to misc-next, with some changelog
updates. Thanks.
