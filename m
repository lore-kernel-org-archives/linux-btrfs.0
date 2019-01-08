Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086CBC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 14:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCED8206C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 14:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfAHO3G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:29:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:49784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728604AbfAHO3G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 09:29:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F841AE52;
        Tue,  8 Jan 2019 14:29:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C5BA5DA7E8; Tue,  8 Jan 2019 15:28:34 +0100 (CET)
Date:   Tue, 8 Jan 2019 15:28:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove impossible condition from mergable_maps
Message-ID: <20190108142834.GF23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181218131002.12480-1-nborisov@suse.com>
 <20190107191019.GD23615@twin.jikos.cz>
 <29983e2d-b525-5b9f-0f37-eb06614cc454@suse.com>
 <88996f56-2740-c3be-1a5c-72a7f40af1f8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88996f56-2740-c3be-1a5c-72a7f40af1f8@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 03:47:13PM +0800, Qu Wenruo wrote:
> On 2019/1/8 下午3:30, Nikolay Borisov wrote:
> > On 7.01.19 г. 21:10 ч., David Sterba wrote:
> >> On Tue, Dec 18, 2018 at 03:10:02PM +0200, Nikolay Borisov wrote:
> >>> We can never have extents marked as EXTENT_MAP_DELALLOC since this
> >>> value is only ever used by btrfs_get_extent_fiemap. In this case the
> >>> extent map is created by btrfs_get_extent_fiemap and is never really
> >>> published, this flag is used to return the corresponding userspace one.
> >>> Considering this, it's pointless having a check for EXTENT_MAP_DELALLOC
> >>> in mergable_maps. Just remove it.
> >>
> >> An assert would be good and a comment at EXTENT_MAP_DELALLOC definition
> >> repeating what's in the changelog. Otherwise ok.
> > 
> > Do we really need the assert though, it's plainly obvious
> > EXTENT_MAP_DELALLOC is only set in a single function?
> 
> IMHO ASSERT() is not for now, but for the future.
> Later on maybe some modification would change when and who sets DELALLOC
> bit.

Agreed, that's exactly the point. We want to catch when DELALLOC is
accidentally found during normal extent merging.
