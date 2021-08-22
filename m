Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4E3C4338F
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Aug 2021 06:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C276124E
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Aug 2021 06:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhHVGDI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 02:03:08 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42836 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhHVGDI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Aug 2021 02:03:08 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 5F578B4160F; Sun, 22 Aug 2021 02:02:27 -0400 (EDT)
Date:   Sun, 22 Aug 2021 02:02:27 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Regression in v5.14-rc1: f2165627319f btrfs: compression: don't
 try to compress if we don't have enough pages
Message-ID: <20210822060227.GA27656@hungrycats.org>
References: <20210822055115.GD29026@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210822055115.GD29026@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Aug 22, 2021 at 01:51:15AM -0400, Zygo Blaxell wrote:

I trimmed my cut+paste too eagerly...

> Before this commit:
> 
> 	# head /dev/zero -c 4095 > inline
> 	# compsize inline
	Processed 1 file, 0 regular extents (0 refs), 1 inline.
> 	Type       Perc     Disk Usage   Uncompressed Referenced  
> 	TOTAL        0%       18B         3.9K         3.9K       
> 	zstd         0%       18B         3.9K         3.9K       
> 
> After this commit:
> 
> 	# head /dev/zero -c 4095 > inline                                                                        
> 	# compsize inline                                                                                        
> 	Processed 1 file, 1 regular extents (1 refs), 0 inline.                                                                                      
> 	Type       Perc     Disk Usage   Uncompressed Referenced                                                                                     
> 	TOTAL      100%      4.0K         4.0K         4.0K                                                                                          
> 	none       100%      4.0K         4.0K         4.0K                                                                                          
> 
> This change makes the metadata sizes of trees of small files (e.g. source
> checkouts) blow up.
> 
> It looks like we need to look at the offset of the extent, as well as
> its length.
