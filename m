Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26B1C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 12:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C45820857
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 12:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8YwOoM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfBHMyy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 07:54:54 -0500
Received: from mail-it1-f179.google.com ([209.85.166.179]:40815 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfBHMyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 07:54:54 -0500
Received: by mail-it1-f179.google.com with SMTP id h193so8527282ita.5
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 04:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HMd0//BvRBDgIM0xtIhEIOvFhCYhmlskFKVko0llwFU=;
        b=U8YwOoM7k1JHMZWDqKyC6pSZKLptpqv6Q/RxS90xt/2EgZZf+wpb3WizhX+GDnNwOH
         rS8VJ8E9AnOynW5nHcb2jW8FUQG0mqDLCVeM+HJOfPoSQoZU0Yihup8+8rgsrvSxDMs4
         NK358YC3/q4+78nYUp/bC/OANxkNKQnd5R/ghIC5LxdwY3wNYTUiGwsoU/RsM9olUZ2p
         3J9Bngt/szjKDMWmMCXGGKWOkJTN7aUFyuFuNeHe/5lQ8/a9a4GMDdo1x4sQZWRsIRLK
         HaEftMc3qUythnV5bipvbaCwLmBcZl4t5KKnPkds8N7ERVsCMBH1K23ITfbNXlJ1yQQa
         evwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HMd0//BvRBDgIM0xtIhEIOvFhCYhmlskFKVko0llwFU=;
        b=RKLgzcRgjh0RiOQd3st8d9lpEM05CaEAk50H5Op+j/7UNpO4zD2D4PHEbUnq+f4/eF
         RHfNyrjF0cfzHiIhpYALhOcMnCz+GZv8AG4mN5/DuVuYo/j4jXvqzSovkReIGWSkpQWY
         ETag+jrymcNcfNDL15xuNNELeBTL9SDk6o/69wy3vyAT5ju3rz6qU5eE8PFPuhsfDcYL
         oqGEeAqOrelFw9/SO8VQTzocbZBUNxlzNxvK5TbMDFWMwRoInpPz9QOGPJ2oS7mczp8l
         g1mSCh287LjNHPAF4lls+cVs+kiGAcVXFseKqZB0GhhGJkXxuV43XeZOLDKbWMazabS9
         rm2g==
X-Gm-Message-State: AHQUAuaBMe/UfMmuaSqyDZKXxBYsypHpCbg1tg6xICG9K0+kromGlUGP
        f5THNq6a2esjN1sE8UQBMyU=
X-Google-Smtp-Source: AHgI3Ib+mS1bAnGjlIWkH+aXodhpWafoczvp75p7d55CSUHA60PrMEJjUp1/K1PWahuq/vCX/oxdiA==
X-Received: by 2002:a24:4293:: with SMTP id i141mr7237877itb.5.1549630493136;
        Fri, 08 Feb 2019 04:54:53 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id t1sm1013540iob.88.2019.02.08.04.54.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 04:54:52 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     Andrei Borzenkov <arvidjaar@gmail.com>, linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <df1bde98-8849-581a-8f96-3a2045fe6274@gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     waxhead@dirtcellar.net, Stefan K <shadow_7@gmx.net>
Message-ID: <1569cf0a-05d3-a45e-ea60-274c7e64df7a@gmail.com>
Date:   Fri, 8 Feb 2019 07:54:49 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <df1bde98-8849-581a-8f96-3a2045fe6274@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-07 23:51, Andrei Borzenkov wrote:
> 07.02.2019 22:39, Austin S. Hemmelgarn пишет:
>> The issue with systemd is that if you pass 'degraded' on most systemd
>> systems,  and devices are missing when the system tries to mount the
>> volume, systemd won't mount it because it doesn't see all the devices.
>> It doesn't even _try_ to mount it because it doesn't see all the
>> devices.  Changing to degraded by default won't fix this, because it's a
>> systemd problem.
>>
> 
> Oh no, not again. It was discussed millions of times already - systemd
> is using information that btrfs provides.
And we've already told the systemd developers to quit using the ioctl 
they're using because it causes this issue and also introduces a TOCTOU 
race condition that can be avoided by just trying to mount the volume 
with the provided options.
> 
>> The same issue also makes it a serious pain in the arse to recover
>> degraded BTRFS volumes on systemd systems, because if the volume is
>> supposed to mount normally on that system, systemd will unmount it if it
>> doesn't see all the devices, regardless of how it got mounted in the
>> first place.
>>
> 
> *That* would be systemd issue indeed. If someone can reliably reproduce
> it, systemd bug report would certainly be in order.
> 
It's been a few months since I dealt with it last (I don't use systemd 
on my everyday systems, because of this and a bunch of other issues I 
have with it (mostly design complaints, not bugs FWIW)), but the general 
process is as follows:

1. Configure a multi-device BTRFS volume such that removal of one device 
will cause the DEVICE_READY ioctl to return false.
2. Set it up in `/etc/fstab` or as a mount unit such that it will 
normally get mounted at boot, but won't prevent the system from booting 
if it fails.
3. Reboot with one of the devices missing.
4. Attempt to manually mount the volume using the regular `mount` 
command with the `degraded` option.
5. Check the mount table, there should be no entry for the volume you 
just mounted in it.

After dealing with this the first time (multiple years ago now), I took 
the time to trace system calls, and found that systemd was unmounting 
the volume immediately after I mounted it.
