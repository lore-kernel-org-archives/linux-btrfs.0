Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA83AC32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 14:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2082081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 14:21:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B2082081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbeKBX2x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 19:28:53 -0400
Received: from mout.gmx.net ([212.227.15.15]:40747 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbeKBX2x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 19:28:53 -0400
Received: from [192.168.178.27] ([109.193.14.2]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MUoma-1g21ND1gaa-00YDAq; Fri, 02
 Nov 2018 15:21:35 +0100
Received: from [192.168.178.27] ([109.193.14.2]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MUoma-1g21ND1gaa-00YDAq; Fri, 02
 Nov 2018 15:21:35 +0100
Subject: Re: Salvage files from broken btrfs
To:     Chris Murphy <lists@colorremedies.com>
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <CAJCQCtRT=C2TjTncf=QJFOiSHQ8HCfM3sLqPbByGCn2MZY-0Tg@mail.gmail.com>
Cc:     linux-btrfs@vger.kernel.org
From:   "M. Klingmann" <m.klingmann@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=m.klingmann@gmx.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <38ece8f3-a468-805b-210d-2f1147d3d32a@gmx.de>
Date:   Fri, 2 Nov 2018 15:21:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRT=C2TjTncf=QJFOiSHQ8HCfM3sLqPbByGCn2MZY-0Tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
X-Provags-ID: V03:K1:gXrcvKGQt19kVThcLYYdnZNF5WmqdzUP42dfv1dRzYeTqolLpkz
 2XWyvynXCFVX7QZ/YnkzBLZRtgI53PwMG+xeJzCxcAYgbRZkcBzvZNQ8ZNzNBZJxk3LNV6Y
 UFTVKOEPvOsR3PGMQBU/fTWMzds4A5bTZiR/GPi1x1aiGpxtx6pyCzFWdWILwy/eJr27eI1
 gByKUJW/GGJzpY3VQ4Cag==
X-UI-Out-Filterresults: notjunk:1;V01:K0:oL/YHW94TGI=:MXMER0hC3py8fPtHUEJEYn
 xXT8LzHHxfKZa/ETXPfe32w3eyAECb44klwDcLSY4RhsPNXVgOxv2Jv9/cKR0PniYWLjAzKvY
 2K196iiSPvch7YvYs7ELDSRdlgavwhCtDbzzN6us9uXYK+70HHPBvGOIZnk90AU3qmdxnxS/T
 4tJoJy0cTStdAFA/N7nHHp03d9Nz5TkEUywJAj+kvBsoBfW1q7+oKUAuWCNzvbNZuL0G3mAkp
 i9f3DvXqSSR6Uz0Y33gvuBwxT/C401IH3eO3eBuMx4TXdtIy53coIgUV2rkqp8Ph5zogjroKl
 wQdgc4AV8bEvX75xqIQO5jWqZO2OeXolhYnslADNL8K/jfo2T6rrkKYdBbHMQBR1/KRlIAJJm
 Gz6BRQFYolflEfRUkaj0LXSUroMYuAd4wYJ+aFWBDZgU8d85zgkVFO6V/xHNEVie1jxHsO7pF
 thAmiPkk0ZknMrfyVX3BmQF3pG6+EKcnY4/+5yipXHC7GqX6PW7X1EIbtmvLRsuh89S2WfSz7
 pygX8Hr1QLJ18/EV/sBhZi4GyG+8Y+WzFyhq3VutXCsquyvOOpzX7oYcW92KjetgBjsQKTeXq
 bttBNlwdk6HCXuGB4vpeCZZGeIGQDDhSy9gt4jaCBQoWpnGFM/jjwA2QlUOOM+oOFt+++405v
 X8AAjXFcKVBm9W3WvV31ejhOB/lOGiKABaUFgEu0XqVZwOTwSZg21vEq2bKz0oixnm6W7nWZ4
 GiJuCBPh0BXeuBVaRUInpj2QyKyHdJf6H8s3rr7jQVCrQQQQJA6Ss1N86xz0gFUVKEWiXWLkc
 9TCmzufoJyOPIRMATUFo2FPMuM09QNNXhILz9JlhuLT2+9l8IQ=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 31.10.2018 at 05:56 Chris Murphy wrote:
> On Tue, Oct 30, 2018 at 4:11 PM, Mirko Klingmann <m.klingmann@gmx.de> wrote:
>> Hi all,
>>
>> my btrfs root file system on a SD card broke down and did not mount anymore.
> It might mount with -o ro,nologreplay
>
> Typically an SD card will break in a way that it can't write, and
> mount will just hang (with mmcblk errors). Mounting with both ro and
> nologreplay will ensure no writes are needed, allowing the mount to
> succeed. of course any changes that are in the log tree will be
> missing so recent transactions may be unrecoverable but so far I've
> had good luck recovering from broken SD cards this way.
>
No luck with these options. The error still persists with same output in
"dmesg".

Thanks for your effort...

-- 

Mirko

