Return-Path: <SRS0=M5eb=BV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20B5C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Aug 2020 10:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 950B62075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Aug 2020 10:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHKK3v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 06:29:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:56722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgHKK3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Aug 2020 06:29:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7AE00AC7C;
        Tue, 11 Aug 2020 10:30:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8095DDA83C; Tue, 11 Aug 2020 12:28:48 +0200 (CEST)
Date:   Tue, 11 Aug 2020 12:28:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Pavel Machek <pavel@denx.de>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com, sashal@kernel.org, wqu@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jungyeon@gatech.edu, stable@kernel.org
Subject: Re: [PATCH] btrfs: fix error value in btrfs_get_extent
Message-ID: <20200811102848.GN2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Pavel Machek <pavel@denx.de>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com, sashal@kernel.org, wqu@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jungyeon@gatech.edu, stable@kernel.org
References: <20200803093506.GA19472@amd>
 <4e88eb32-ac7d-f0cb-d089-ec197595bce9@suse.com>
 <c30a0a5e-dfd5-8bee-63f6-c93af9dc7eb6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c30a0a5e-dfd5-8bee-63f6-c93af9dc7eb6@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 03, 2020 at 12:50:31PM +0300, Nikolay Borisov wrote:
> On 3.08.20 г. 12:39 ч., Nikolay Borisov wrote:
> > On 3.08.20 г. 12:35 ч., Pavel Machek wrote:
> >> btrfs_get_extent() sets variable ret, but out: error path expect error
> >> to be in variable err. Fix that.
> >>
> >> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > 
> > Good catch, this also needs:
> > 
> > Fixes: 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL
> > pointer dereference")
> > 
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> Actually the reason this error got introduced in the first place and I
> missed it during the review is that the function is doing something
> rather counter-intuitive - it's using 'err' variable as a synonym for
> 'ret'. A better approach would be to simply remove 'err' from that
> function. I'm now authoring such a patch, nevertheless the issue still
> stands.

The expected pattern is to use 'ret' for function return value and add
other temporary variables instead of the err/ret switching, which can be
found in the oldish code still. So the cleanup is going to do the right
thing, thanks.
