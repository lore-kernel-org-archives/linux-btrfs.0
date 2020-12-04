Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F9BC19425
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Dec 2020 17:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1378322CAD
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Dec 2020 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbgLDRp2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 12:45:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:37470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgLDRp2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Dec 2020 12:45:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3A98BACBD;
        Fri,  4 Dec 2020 17:44:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AA4A3DA7E3; Fri,  4 Dec 2020 18:43:12 +0100 (CET)
Date:   Fri, 4 Dec 2020 18:43:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [PATCH] btrfs: free-space-cache: Fix error return code in
 __load_free_space_cache
Message-ID: <20201204174312.GY6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Zhihao Cheng <chengzhihao1@huawei.com>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
References: <20201120010804.440598-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120010804.440598-1-chengzhihao1@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 20, 2020 at 09:08:04AM +0800, Zhihao Cheng wrote:
> Fix to return the error code(instead always 0) when memory allocating
> failed in __load_free_space_cache().

Hm right the error handling flow in that function is a mess and the
error values are not set. Your patch is a minimal fix so I'll add it,
the function could use some cleanups though. Thanks.
