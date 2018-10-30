Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3426C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 17:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 623A22080A
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 17:13:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxDn/n2n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 623A22080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbeJaCHZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 22:07:25 -0400
Received: from mail-it1-f180.google.com ([209.85.166.180]:38043 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbeJaCHZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 22:07:25 -0400
Received: by mail-it1-f180.google.com with SMTP id j9so2726176itl.3
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 10:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gsGBqRqTanfhqnFSNUooWNOjgIcRHjwNKWNWuJHJvjg=;
        b=lxDn/n2ntRIrmSkcydBrx+bVCdKXVdzuzkMgVb1jqKo2y1338mr+ug+aIH9JtqryJX
         nWqIHlounKcjb9cIOLWcNV3oEMjoy4rkgGdF9YSjNrTjrKdxijMLgk106rhzyAgGlbN4
         IoBz8EXZuDtjx4kLqmsQHlopD/ShQ8i4uXfyCtVdNP4wldn8iDBbvJL2b8DdcGSQAiYn
         hL2R7hS9LuPsyCeX+TqljVNunc7+tH9rvJ1bFYQuRu0QbHXL8FSzYbC5e5+oqUVLQUbN
         ruWsGQs1QRWojTGBsZBlY9a8DkWQWn7FI/h4g07hOJ0MVs9YoqFkJXmivmCYFoMtNKIJ
         gE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gsGBqRqTanfhqnFSNUooWNOjgIcRHjwNKWNWuJHJvjg=;
        b=ZMy1RCdlaMxFl69T+ZjIxR0t2/45vrV2Vt+9tL7g3um7lK+nRh9KdKz6RsY7xRFoO0
         F/3umKmirpfWUE8rs1qXCYLfvW9IHucXvWy7GdDfvv87NPkIoABKQtsOQOGYNCpjHdgn
         Aaaspyr/IE1qV+/eS9hNNodkiTwljtA64KvudhAP+yxi6EQavAf2y7Ya2zERSj47tPD9
         idACmAOikhQ1m7QzN2/YhwnqRNdKet86ZSMxRuVAUHVPNka6ZzttBPMDoTXiDlOt+9Ey
         2cPMgMe+W4ittMnquYgmGkCCbyFA7iuEkP4UBm3RwVX3EcA5nBKrsqglDoGyGNPfOPCy
         /DvA==
X-Gm-Message-State: AGRZ1gJouMiQIE13L+e2eEdVQbXxgvOnvXcn0ppz7ev7jnbwMMy3xrzO
        u8V/hRXdtFUzknHXmyxvBoHh8PkW0hU=
X-Google-Smtp-Source: AJdET5faPA+jahyIDH5QiNWX3HIOlsdjfhPqEQIkBZtLVnhJUm+VynNX61wiphLnn885bgOY62Sn1Q==
X-Received: by 2002:a24:cf03:: with SMTP id y3-v6mr1983899itf.63.1540919585195;
        Tue, 30 Oct 2018 10:13:05 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-147-0-47-180.central.biz.rr.com. [147.0.47.180])
        by smtp.gmail.com with ESMTPSA id k6-v6sm8726673ioc.25.2018.10.30.10.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 10:13:02 -0700 (PDT)
Subject: Re: Understanding "btrfs filesystem usage"
To:     linux-btrfs@vger.kernel.org, framstag@rus.uni-stuttgart.de
References: <20181029181141.GA31256@rus.uni-stuttgart.de>
 <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
 <20181030161003.GA25765@rus.uni-stuttgart.de>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ae5a0323-5e71-b3d5-7ffa-08e8617d34c2@gmail.com>
Date:   Tue, 30 Oct 2018 13:12:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181030161003.GA25765@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/30/2018 12:10 PM, Ulli Horlacher wrote:
> 
> On Mon 2018-10-29 (17:57), Remi Gauvin wrote:
>> On 2018-10-29 02:11 PM, Ulli Horlacher wrote:
>>
>>> I want to know how many free space is left and have problems in
>>> interpreting the output of:
>>>
>>> btrfs filesystem usage
>>> btrfs filesystem df
>>> btrfs filesystem show
>>
>> In my not so humble opinion, the filesystem usage command has the
>> easiest to understand output.  It' lays out all the pertinent information.
>>
>> You can clearly see 825GiB is allocated, with 494GiB used, therefore,
>> filesystem show is actually using the "Allocated" value as "Used".
>> Allocated can be thought of "Reserved For".
> 
> And what is "Device unallocated"? Not reserved?
> 
> 
>> As the output of the Usage command and df command clearly show, you have
>> almost 400GiB space available.
> 
> This is the good part :-)
> 
> 
>> The disparity between 498GiB used and 823Gib is pretty high.  This is
>> probably the result of using an SSD with an older kernel.  If your
>> kernel is not very recent, (sorry, I forget where this was fixed,
>> somewhere around 4.14 or 4.15), then consider mounting with the nossd
>> option.
> 
> I am running kernel 4.4 (it is a Ubuntu 16.04 system)
> But /local is on a SSD. Should I really use nossd mount option?!
Probably, and you may even want to use it on newer (patched) kernels.

This requires some explanation though.

SSD's are write limited media (write to them too much, and they stop 
working).  This is generally a pretty well known fact, and while it is 
true, it's not anywhere near as much of an issue on modern SSD"s as 
people make it out to be (pretty much, if you've got an SSD made in the 
last 5 years, you almost certainly don't have to worry about this).  The 
`ssd` code in BTRFS behaves as if this is still an issue (and does so in 
a way that doesn't even solve it well).

Put simply, when BTRFS goes to look for space, it treats requests for 
space that ask for less than a certain size as if they are that minimum 
size, and only tries to look for smaller spots if it can't find one at 
least that minimum size.  This has a couple of advantages in terms of 
write performance, especially in the common case of a mostly empty 
filesystem.

For the default (`nossd`) case, that minimum size is 64kB.  So, in most 
cases, the potentially wasted space actually doesn't matter much (most 
writes are bigger than 64k) unless you're doing certain things.

For the old (`ssd`) case, that minimum size is 2MB.  Even with the 
common cases that would normally not have an issue with the 64k default, 
this ends up wasting a _huge_ amount of space.

For the new `ssd` behavior, the minimum is different for data and 
metadata (IIRC, metadata uses the 64k default, while data still uses the 
2M size).  This solves the biggest issues (which were seen with 
metadata), but doesn't completely remove the problem.

Expanding on this further, some unusual workloads actually benefit from 
the old `ssd` behavior, so on newer kernels `ssd_spread` gives that 
behavior.  However, many workloads actually do better with the `nossd` 
behavior (especially the pathological worst case stuff like databases 
and VM disk images), so if you have a recent SSD, you probably want to 
just use that.
> 
> 
>> You can improve this by running a balance.
>>
>> Something like:
>> btrfs balance start -dusage=55
> 
> I run balance via cron weekly (adapted
> https://software.opensuse.org/package/btrfsmaintenance)
> 
> 

