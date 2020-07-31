Return-Path: <SRS0=krxf=BK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355BEC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 10:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A33208E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 10:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbgGaKG3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 06:06:29 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:38298 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732140AbgGaKG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Jul 2020 06:06:29 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id C1E4A1F5AE;
        Fri, 31 Jul 2020 10:06:28 +0000 (UTC)
Date:   Fri, 31 Jul 2020 10:06:28 +0000
From:   Eric Wong <e@80x24.org>
To:     Alberto Bursi <bobafetthotmail@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: raid1 with several old drives and a big new one
Message-ID: <20200731100628.GA18568@dcvr>
References: <20200731001652.GA28434@dcvr>
 <6d29319f-301e-c1d2-9674-b39619356ae7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6d29319f-301e-c1d2-9674-b39619356ae7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Alberto Bursi <bobafetthotmail@gmail.com> wrote:
> On 31/07/20 02:16, Eric Wong wrote:
> > Say I have three ancient 2TB HDDs and one new 6TB HDD, is there
> > a way I can ensure one raid1 copy of the data stays on the new
> > 6TB HDD?
> > 
> > I expect the 2TB HDDs to fail sooner than the 6TB HDD given
> > their age (>5 years).
> > 
> 
> I'm not sure what is the problem, ok maybe the drives are old and are more
> likely to fail, but why would more than one drive fail at once?

Why wouldn't they?  Otherwise there'd be no reason for RAID6 to
exist over RAID5.  Recovery puts more stress on the remaining
drives and increases the likelyhood of another drive in a pool
failing.  I've seen HW RAID5 arrays lost like like this in a
previous life (I didn't manage to convince the other sysadmins
to use RAID6 :<).
