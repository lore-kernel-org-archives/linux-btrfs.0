Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DFFC433ED
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 May 2021 17:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37889611BD
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 May 2021 17:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351004AbhERRCo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 May 2021 13:02:44 -0400
Received: from mail.itouring.de ([85.10.202.141]:58398 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhERRCn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 May 2021 13:02:43 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2021 13:02:43 EDT
Received: from tux.applied-asynchrony.com (p5b07e8e5.dip0.t-ipconnect.de [91.7.232.229])
        by mail.itouring.de (Postfix) with ESMTPSA id E9FF3E0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 May 2021 18:52:50 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 98326F01600
        for <linux-btrfs@vger.kernel.org>; Tue, 18 May 2021 18:52:50 +0200 (CEST)
Subject: Re: [PATCH] btrfs: scrub: per-device bandwidth control
To:     linux-btrfs@vger.kernel.org
References: <20210518144935.15835-1-dsterba@suse.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <1e90eb63-60a1-63b4-8e26-121e8bda1ba2@applied-asynchrony.com>
Date:   Tue, 18 May 2021 18:52:50 +0200
MIME-Version: 1.0
In-Reply-To: <20210518144935.15835-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2021-05-18 16:49, David Sterba wrote:
> Add sysfs interface to limit io during scrub. We relied on the ionice

This is very useful, thank you! Running scrubs on three devices with
10M/20M/30M bandwidth limit showed up in iotop/nmon exactly as expected,
and dynamically changing the values to speed up/slow down also worked
right away - very nice.

My only suggestion would be:

> - raw value is in bytes

..for this to be in megabytes only (maybe also renaming scrub_speed_max to
scrub_speed_max_mb?), because otherwise everyone will forget the unit and wonder
why scrub is running with 50 bytes/sec. IMHO bytes/kbytes are not really practical
scrub speeds. Other than that have a:

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

cheers,
Holger
