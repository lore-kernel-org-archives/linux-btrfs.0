Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2AEC04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 572012083C
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:09:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRBeqIJv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 572012083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbeJOTym (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 15:54:42 -0400
Received: from mail-it1-f182.google.com ([209.85.166.182]:34995 "EHLO
        mail-it1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbeJOTym (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 15:54:42 -0400
Received: by mail-it1-f182.google.com with SMTP id p64-v6so27294011itp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 05:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9F4HnDU+Ng0G2CkGQY9udNddJFmOFVP8DPVXG2ea55U=;
        b=YRBeqIJvkLwvcW2HmeZFthvYNcZ4U/r2rVUuMZOW2q3Ez8fd5k2LTyETyJRQTvTRHa
         j6rsh9G43PNMuYh5TOtcpwEKbpEYSnXhewt1C67XfaLr1SmJujV/v5QXTeiD/IxJZDvU
         FmJaqCcbGTw3Hv64nhRSH9UhVXLiQVHpJs0/Iv/Muemtk4Cn+aCtAhvBZzLEEp/CDk68
         Po9FEI5maLmrVQbajn8NeaD94Y0K9lA6j/K/3U9r+mRh742iRZKcjVQrk62FOEy/S7sW
         MtpzLA/lQtPqMW8+VHGSyjqvjq4+I7X4lHt27ImDWp5nX1hLHmBb7v35PPgIlyU+9dyi
         jrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9F4HnDU+Ng0G2CkGQY9udNddJFmOFVP8DPVXG2ea55U=;
        b=il/0qjDMIyF8ZrYGG8Ev9kp/juXMFY+5RaRcu+LsGiR1yeNeO2BqcKAiDV3yCPjuye
         valsCcILpBmtee2Zze1GcCd+dMzE5oiL9uDxSoZG4dlCHhvwWVFo1e5wb2rY1ZR2bwoK
         OPCqoWgL+8oyso1DKXACKSytjXoT3uLXmWsJA97cMyjzhj7PxYMtrvXIWiDaV0i1NLTG
         lUNa0x6gxjD7X5G5S1gdq7JhehE+kRQE5mER9Gv6FWzoZhdWgN/gpp3ELsrP+55NfOpf
         khgCwhUtv5CVVPWgeM3SWF9qJLI6jd6N/Xwt/8jlkxp+9K8YOZLPD5qRpjNYGUQL+/iv
         k1Pw==
X-Gm-Message-State: ABuFfogf2p7jbHcD9lTruqjH86rnchdcxEGmAD73IPNfq0laxpizyk+q
        37KZpZe8HzsjfDUqC1jtgPQhCuDbCBk=
X-Google-Smtp-Source: ACcGV637C4HunG2XOBm2T+OvFqyNlGI81criyS/0Q2D/FLwb99CUM0W8w+cycvRoMfOIuE2tQkrQ4g==
X-Received: by 2002:a24:6e87:: with SMTP id w129-v6mr13363534itc.49.1539605380847;
        Mon, 15 Oct 2018 05:09:40 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id b26-v6sm2865263iod.38.2018.10.15.05.09.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 05:09:39 -0700 (PDT)
Subject: Re: BTRFS bad block management. Does it exist?
To:     waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3af0d10e-f7d8-806e-8ce5-91295e0ed6d7@gmail.com>
Date:   Mon, 15 Oct 2018 08:09:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-14 07:08, waxhead wrote:
> In case BTRFS fails to WRITE to a disk. What happens?
> Does the bad area get mapped out somehow? Does it try again until it 
> succeed or until it "times out" or reach a threshold counter?
> Does it eventually try to write to a different disk (in case of using 
> the raid1/10 profile?)

Building on Qu's answer (which is absolutely correct), BTRFS makes the 
perfectly reasonable assumption that you're not trying to use known bad 
hardware.  It's not alone in this respect either, pretty much every 
Linux filesystem makes the exact same assumption (and almost all 
non-Linux ones too), because it really is a perfectly reasonable 
assumption.  The only exception is ext[234], but they only support it 
statically (you can set the bad block list at mkfs time, but not 
afterwards, and they don't update it at runtime), and it's a holdover 
from earlier filesystems which originated at a time when storage was 
sufficiently expensive _and_ unreliable that you kept using disks until 
they were essentially completely dead.

The reality is that with modern storage hardware, if you have 
persistently bad sectors the device is either defective (and should be 
returned under warranty), or it's beyond expected EOL (and should just 
be replaced).  Most people know about SSD's doing block remapping to 
avoid bad blocks, but hard drives do it to, and they're actually rather 
good at it.  In both cases, enough spare blocks are provided that the 
device can handle average rates of media errors through the entirety of 
it's average life expectancy without running out of spare blocks.

On top of all of that though, it's fully possible to work around bad 
blocks in the block layer if you take the time to actually do it.  With 
a bit of reasonably simple math, you can easily set up an LVM volume 
that actively avoids all the bad blocks on a disk while still fully 
utilizing the rest of the volume.  Similarly, with a bit of work (and a 
partition table that supports _lots_ of partitions) you can work around 
bad blocks with an MD concatenated device.
