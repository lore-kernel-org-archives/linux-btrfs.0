Return-Path: <SRS0=yhka=26=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AA6C282DD
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jan 2020 14:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD712077B
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jan 2020 14:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgAIOel (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 09:34:41 -0500
Received: from pme1.philip-seeger.de ([194.59.205.51]:45788 "EHLO
        pme1.philip-seeger.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbgAIOel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2020 09:34:41 -0500
Received: from webmail.philip-seeger.de (pme1.philip-seeger.de [IPv6:2a03:4000:34:141::100])
        by pme1.philip-seeger.de (Postfix) with ESMTPSA id 7E12B1FCBED;
        Thu,  9 Jan 2020 15:34:39 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Jan 2020 15:34:38 +0100
From:   Philip Seeger <philip@philip-seeger.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
Subject: Re: Monitoring not working as "dev stats" returns 0 after read error
 occurred
In-Reply-To: <2a9bf923-e7b9-9d82-5f1d-bbdfc192978e@suse.com>
References: <3283de40c2750cd62d020ed71430cd35@philip-seeger.de>
 <d89fe4da-c498-bb24-8eb5-a19b01680a23@cobb.uk.net>
 <ac61f79a3c373f319232640db5db9a5e@philip-seeger.de>
 <2a9bf923-e7b9-9d82-5f1d-bbdfc192978e@suse.com>
Message-ID: <d3a234a07192fd9713b0ac33123c99db@philip-seeger.de>
X-Sender: philip@philip-seeger.de
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2020-01-09 13:04, Nikolay Borisov wrote:
> According to the log provided the error returned from the NVME device 
> is
> BLK_STS_MEDIUM/-ENODATA hence the "critical medium" string there. 
> Btrfs'
> code OTOH only logs error in case we it gets STS_IOERR or STS_TARGET
> from the block layer. It seems there are other error codes which are
> also ignored but can signify errors e.g. STS_NEXUS/STS_TRANSPORT.

Thanks for looking into this!

> So as it stands this is expected but I'm not sure it's correct 
> behavior,
> perhaps we need to extend the range of conditions we record as errors.

I don't understand how this could possibly be correct behavior.

The "device stats" command returns the error counters for a BTRFS 
filesystem, just like "zfs status" returns the error counters for a ZFS 
filesystem. So that's the one and only command that can be used by the 
monitoring job that checks the health of the system. If the error 
counters all stay at zero after device errors have occurred and that's 
deemed correct behavior, how would the monitoring system be able to 
notify the admin about a bad drive that should be replace before another 
one goes bad, causing data loss?
