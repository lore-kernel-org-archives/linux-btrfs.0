Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD6BC3567B
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 10:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF862080D
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 10:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgBXKIH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 05:08:07 -0500
Received: from mail.itouring.de ([188.40.134.68]:45698 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgBXKIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 05:08:07 -0500
Received: from tux.applied-asynchrony.com (p5B07E2B3.dip0.t-ipconnect.de [91.7.226.179])
        by mail.itouring.de (Postfix) with ESMTPSA id 0309441601CA;
        Mon, 24 Feb 2020 11:08:05 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id B1FECF01606;
        Mon, 24 Feb 2020 11:08:04 +0100 (CET)
Subject: Re: scrub resume after suspend not working
To:     Robert Krig <robert.krig@render-wahnsinn.de>,
        linux-btrfs@vger.kernel.org
References: <e476b0aec351754b3cd72ed7d9135a6900f57554.camel@render-wahnsinn.de>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <87a3111e-598d-9a1a-3235-07bc81372520@applied-asynchrony.com>
Date:   Mon, 24 Feb 2020 11:08:04 +0100
MIME-Version: 1.0
In-Reply-To: <e476b0aec351754b3cd72ed7d9135a6900f57554.camel@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/24/20 10:39 AM, Robert Krig wrote:
[snip]
> After waking up from a suspend, the btrfs scrub resume does indeed
> "resume" but it seems to have forgotten it's progress. It "looks" as
> though it just started over.
> 
> Is this expected behavior or is it a bug?

It *was* a bug which has been fixed in 5.4.14. Current is 5.4.22,
as of today.

-h
