Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3299C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C982075B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="HoxwB5Et"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89C982075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbeJKBHn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 21:07:43 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32942 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbeJKBHm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 21:07:42 -0400
Received: by mail-lj1-f195.google.com with SMTP id z21-v6so5713388ljz.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 10:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=CAMVs9MQpLFkCnYSUAC3mIKS49eDZSW8WmrxwJ8PNdY=;
        b=HoxwB5EtovcWPeOxbmzYhB1w24wbbiixNj4OjQqIZkxtHzJRfOEXjE8e9w7Go2kEyM
         RfGxFkTrHB6tsmyu1EKO3U6yRwbcXgAyzJwU9QuY0lOafuaO3hWuMNwPmIKlJQTGwh+S
         dT82QhmFVaGevY0qYtJ2hzzPQiUvRq5zjRzUR8Jn3MDNm1C5N2uUNQ5kSWHxAwyX/FNP
         Gd4jaLu9MONQESXnYWNnNpzrfYAmIO4x0gLVrBhxuRUptUOgc0Kh0Oie1ofqWdPsixYO
         0JY3vnyyfdfHq4sorRrH1/29npUuQbh0BVT/CbrX2L/umKLRUeso4tS+PISuE5bufolv
         moCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc:content-transfer-encoding;
        bh=CAMVs9MQpLFkCnYSUAC3mIKS49eDZSW8WmrxwJ8PNdY=;
        b=O2+KjxOdV0Lh9JHLTOMUfYKWHDww+5tpHy/oqsTfBlaFosWi2IS6ZNrUM2vQzU80Ii
         VPMRUj/nUutkysUWPls9FlnBkzpw5VupYx3nnGo3a+3Yx01Owh01IhzbbcNUeHye9xi+
         uRqtwneDrwlTwx8JtSzRoHcW7eQXzHlKC/mCQYcV+HoBS0uhq08eVUfu1kjqICZBFyER
         qUM7zT5cMkT7DHlVvjYblGD9mOp22UaX9Uss8F5+QCzO8qgHDAHs7Gp0Tkj+4qhAhal7
         GuwWvLukgxGFgfiite2YWKHkS88mG91o5zxdin1mjUPvdAB6cGPDHhqEn6LC4PVwpbwB
         RL5w==
X-Gm-Message-State: ABuFfojX0UJeJ1b9yB/ANI8GWRe47hgUp6od21a7SNywHUrEcCSCSmBH
        dUlrCNiFaK1WTrjVpGfgKrGCs94XtzfzlD8Nl8IXOA==
X-Google-Smtp-Source: ACcGV6342vqW98imOGhdT9Cr9ez8nUCoE0dycLRGNxdYe2qruRMP+PF7M4wvV5q+kRt/LwhjqeN3zSx7nq5ZXQeBmXE=
X-Received: by 2002:a2e:4408:: with SMTP id r8-v6mr23305724lja.21.1539193468712;
 Wed, 10 Oct 2018 10:44:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 10:44:27
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com> <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com> <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com> <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com> <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com> <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Oct 2018 11:44:27 -0600
X-Google-Sender-Auth: Grhq7DMcPjMiu8uQFVPud7D9A84
Message-ID: <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
Subject: Re: Scrub aborts due to corrupt leaf
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 10:04 AM, Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
> On 10/10/18 17:44, Larkin Lowrey wrote:
> (..)
>>
>> About once a week, or so, I'm running into the above situation where
>> FS seems to deadlock. All IO to the FS blocks, there is no IO
>> activity at all. I have to hard reboot the system to recover. There
>> are no error indications except for the following which occurs well
>> before the FS freezes up:
>>
>> BTRFS warning (device dm-3): block group 78691883286528 has wrong amount
>> of free space
>> BTRFS warning (device dm-3): failed to load free space cache for block
>> group 78691883286528, rebuilding it now
>>
>> Do I have any options other the nuking the FS and starting over?
>
>
> Unmount cleanly & mount again with -o space_cache=3Dv2.

I'm pretty sure you have to umount, and then clear the space_cache
with 'btrfs check --clear-space-cache=3Dv1' and then do a one time mount
with -o space_cache=3Dv2.

But anyway, to me that seems premature because we don't even know
what's causing the problem.

a. Freezing means there's a kernel bug. Hands down.
b. Is it freezing on the rebuild? Or something else?
c. I think the devs would like to see the output from btrfs-progs
v4.17.1, 'btrfs check --mode=3Dlowmem' and see if it finds anything, in
particular something not related to free space cache.

Rebuilding either version of space cache requires successfully reading
(and parsing) the extent tree.


--=20
Chris Murphy
