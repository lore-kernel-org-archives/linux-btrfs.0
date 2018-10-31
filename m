Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A68CC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 17:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFDD32080A
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 17:19:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFDD32080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbeKACSX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 22:18:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:35932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728128AbeKACSX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 22:18:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D56EFB125;
        Wed, 31 Oct 2018 17:19:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 447D4DAB9E; Wed, 31 Oct 2018 18:19:17 +0100 (CET)
Date:   Wed, 31 Oct 2018 18:19:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/3] btrfs-progs: check: lowmem: Factor out inline extent
 checking code in its own function
Message-ID: <20181031171916.GJ9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180913120507.18197-1-nborisov@suse.com>
 <20180913120507.18197-2-nborisov@suse.com>
 <09347419-aba9-7fdb-e756-109ed8d3eaee@fujitsu.com>
 <7bc87724-9d43-e487-140b-fc184cd83873@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc87724-9d43-e487-140b-fc184cd83873@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 11:43:20AM +0200, Nikolay Borisov wrote:
> >> --- a/check/mode-lowmem.c
> >> +++ b/check/mode-lowmem.c
> >> @@ -1800,6 +1800,87 @@ static int repair_inline_ram_bytes(struct btrfs_root *root,
> >>  	return ret;
> >>  }
> >>  
> >> +
> >> +static int check_file_extent_inline(struct btrfs_root *root,
> >> +				    struct btrfs_path *path, u64 *size,
> >> +				    u64 *end)
> >> +{
> >> +	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
> >> +				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
> >> +	struct extent_buffer *node = path->nodes[0];
> >> +	struct btrfs_item *e = btrfs_item_nr(0);
> >                                btrfs_item_nr(path->slots[0])
> > 
> > I think this fixes the problem.
> 
> Indeed, the original code uses path->slots[0] as the slot whereas I've
> fixed that at slow 0, which of course is not always going to be the case.
> 
> David will you fold this in the original patch ?

Yes I'll fold it. Thanks.
