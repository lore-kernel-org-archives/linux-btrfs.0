Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE43CC32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 16:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5078D2082D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 16:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5078D2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dirtcellar.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbeKECAg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 21:00:36 -0500
Received: from smtp.domeneshop.no ([194.63.252.55]:38550 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbeKECAg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 21:00:36 -0500
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:55509 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gJLWG-0001Qx-A7; Sun, 04 Nov 2018 17:45:00 +0100
Reply-To: waxhead@dirtcellar.net
Subject: Re: BTRFS did it's job nicely (thanks!)
To:     Sterling Windmill <swindmill@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
 <CAMOu_z0879AZEKHPDFOFeGL8H4E2Uj+CzFYV6tSdqHoHF5NyNg@mail.gmail.com>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <5c8bbcac-65e2-1787-d836-bcf4722ed0a6@dirtcellar.net>
Date:   Sun, 4 Nov 2018 17:44:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <CAMOu_z0879AZEKHPDFOFeGL8H4E2Uj+CzFYV6tSdqHoHF5NyNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sterling Windmill wrote:
> Out of curiosity, what led to you choosing RAID1 for data but RAID10
> for metadata?
> 
> I've flip flipped between these two modes myself after finding out
> that BTRFS RAID10 doesn't work how I would've expected.
> 
> Wondering what made you choose your configuration.
> 
> Thanks!
> Sure,

The "RAID"1 profile for data was chosen to maximize disk space 
utilization since I got a lot of mixed size devices.

The "RAID"10 profile for metadata was chosen simply because it *feels* a 
bit faster for some of my (previous) workload which was reading a lot of 
small files (which I guess was embedded in the metadata). While I never 
remembered that I got any measurable performance increase the system 
simply felt smoother (which is strange since "RAID"10 should hog more 
disks at once).

I would love to try "RAID"10 for both data and metadata, but I have to 
delete some files first (or add yet another drive).

Would you like to elaborate a bit more yourself about how BTRFS "RAID"10 
does not work as you expected?

As far as I know BTRFS' version of "RAID"10 means it ensure 2 copies (1 
replica) is striped over as many disks it can (as long as there is free 
space).

So if I am not terribly mistaking a "RAID"10 with 20 devices will stripe 
over (20/2) x 2 and if you run out of space on 10 of the devices it will 
continue to stripe over (5/2) x 2. So your stripe width vary with the 
available space essentially... I may be terribly wrong about this (until 
someones corrects me that is...)

