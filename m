Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB91DC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 08:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A439A206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 08:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfDPIJP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:09:15 -0400
Received: from len.romanrm.net ([91.121.75.85]:48214 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfDPIJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 04:09:15 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Apr 2019 04:09:14 EDT
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 35AC8202C1;
        Tue, 16 Apr 2019 08:00:30 +0000 (UTC)
Date:   Tue, 16 Apr 2019 13:00:29 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Daniel Brunner <daniel@brunner.ninja>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: Corrupted files support needed
Message-ID: <20190416130029.6cd174d2@natsu>
In-Reply-To: <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
        <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
        <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
        <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 16 Apr 2019 09:46:39 +0200
Daniel Brunner <daniel@brunner.ninja> wrote:

> Hi,
> 
> thanks for the quick response.
> 
> The filesystem went read-only on its own right at the first read error.
> I unmounted all mounts and rebooted (just to be sure).
> 
> I ran the command you suggested with --progress
> All output is flushed away with thousands of lines like those at the
> end of the log paste.
> 
> Does it make sense to let it run until the end or can I assume that 2
> drives are bad?
> Also I checked SMART values but they seem to be ok.
> 
> https://0x0.st/zNg6.log

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
190 Airflow_Temperature_Cel 0x0022   047   031   040    Old_age   Always   In_the_past 53 (Min/Max 47/53 #5115)

This seems to be normalized as VALUE=100-RAW_VALUE by the SMART firmware, and
looking at the reading in WORST, indicates that some of your drives earlier
have seen temperatures of as high as 69 C.

This is insanely hot to run your drives at, I'd say to the point of "shut off
everything ASAP via the mains breaker to avoid immediate permanent damage";

Not sure if it's related to the csum errors at hand, but it very well might be.

Even the current temps of 55-60 are about 15-20 degrees higher than ideal.

-- 
With respect,
Roman
