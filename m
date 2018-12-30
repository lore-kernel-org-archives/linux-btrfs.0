Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC10C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 00:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0175020873
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 00:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaliza-cz.20150623.gappssmtp.com header.i=@metaliza-cz.20150623.gappssmtp.com header.b="sFY8xjeJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbeL3As1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 19:48:27 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:46928 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbeL3As1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 19:48:27 -0500
Received: by mail-wr1-f44.google.com with SMTP id l9so23923726wrt.13
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2018 16:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaliza-cz.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d9dAYdg8ThWPrgLbmTZMySQks3F/TUYYay95W+3xte8=;
        b=sFY8xjeJI7GB/6t0pZ8ZxFKnFBOcN5vbAH1IOrXsMPMvkuiVMweaGnYP99kXM5sFSq
         2/uHfTMxi4wZisj8+il0VmFMiJRyl95fcavmpfyA9xbIdyEHqPdVBumzlf369SGn1gBq
         /seEbJ+ydRNLgoIVUwPnospxTLp5WSQ1OjaQx4vytXpJ439+49u4zP1Y/3B3cd5/xUKe
         hWH7GWMnK38VYn/AuWxhgyrkPWC0IqN0HF/yeWycTzsQS5iuERpcJzdqUfXn5hvfPNbY
         F+v6PFEqj/F3QfUK/f2i5WVA8AfTc0PZXJAW/7X5xO19ls+1KYbbOQfZQat5+Ndhiydz
         8FMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d9dAYdg8ThWPrgLbmTZMySQks3F/TUYYay95W+3xte8=;
        b=hOhjCOk/xKs89xs2GMrX0V9KBUWik9ru8r3IY75GN16vOjC/KxRJGq/E6oa6lZ0dcM
         nzxpRLpsjGBg7HgsGUz/QOKuSlyPPxBHf+E1/OdgUQgVdkuxH9H/7QrnzPgllIvHWkBb
         mpjXjfbyocgAjgyWxaKqV7dZ3h6sX7Fy9DqguRtLxsTxGYWQtkJGqmuv6g/EiDmzCK4Q
         /28NIq1FnCdSbGn+Af/TypcTllEk0A1wH465xQFvVgTGEjbvZPrfWDwrj+ebZvGmgT80
         gIOjnaSqmZ3Jg8h0c+jHMOiFP4VwjHXt3uNXbUNLzfw5rLsSySTClbUSuStpe1Rq+sxo
         1siw==
X-Gm-Message-State: AJcUukcn8JaP2KkWzQW4Oz3Mt/2N8X+y4S7D4fNmqab9b4uXBZ8OpRq8
        XwCawr53Mq2M4ekFL5N3bAHk+CDazaA=
X-Google-Smtp-Source: ALg8bN5fJ3uutle6UNi7rdXdpUSWVMOueNjP4WjfxohnCo97s4nmtelqCe0ArlhG4js52tQyfdXN7g==
X-Received: by 2002:adf:f211:: with SMTP id p17mr28957587wro.293.1546130904775;
        Sat, 29 Dec 2018 16:48:24 -0800 (PST)
Received: from ?IPv6:2a00:1028:96c8:10a2:39bd:9ace:4251:267? (dynamic-2a00-1028-96c8-10a2-39bd-9ace-4251-0267.ipv6.broadband.iol.cz. [2a00:1028:96c8:10a2:39bd:9ace:4251:267])
        by smtp.gmail.com with ESMTPSA id x81sm32475492wmg.17.2018.12.29.16.48.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 16:48:24 -0800 (PST)
From:   =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Subject: Broken chunk tree - Was: Mount issue, mount /dev/sdc2: can't read
 superblock
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
 <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
 <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
 <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
Message-ID: <07b88bad-e1fa-7485-d410-ee261ace321c@metaliza.cz>
Date:   Sun, 30 Dec 2018 01:48:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Ok, I've got it:-(

But just a few questions: I've tried (with btrfs-progs v4.19.1) to 
recover files through btrfs restore -s -m -S -v -i ... and following 
events occurred:

1) Just 1 "hard" error:
ERROR: cannot map block logical 117058830336 length 1073741824: -2
Error copying data for /mnt/...
(file which absence really doesn't pain me:-))

2) For 24 files a I got "too much loops" warning (U mean this: "if 
(loops >= 0 && loops++ >= 1024) { ..."). I've always answered yes but 
I'm afraid these files are corrupted (at least 2 of them seems corrupted).

How much bad is this? Does the error mentioned in #1 mean that it's the 
only file which is totally lost? I can live without those 24 + 1 files 
so if #1 and #2 would be the only errors then I could say the recovery 
was successful ... but I'm afraid things aren't such easy:-)

Thanks
M.


   Tomáš Metelka
   Business & IT Analyst

   Tel: +420 728 627 252
   Email: tomas.metelka@metaliza.cz



On 24. 12. 18 15:19, Qu Wenruo wrote:
> 
> 
> On 2018/12/24 下午9:52, Tomáš Metelka wrote:
>> On 24. 12. 18 14:02, Qu Wenruo wrote:
>>> btrfs check --readonly output please.
>>>
>>> btrfs check --readonly is always the most reliable and detailed output
>>> for any possible recovery.
>>
>> This is very weird because it prints only:
>> ERROR: cannot open file system
> 
> A new place to enhance ;)
> 
>>
>> I've tried also "btrfs check -r 75152310272" but it only says:
>> parent transid verify failed on 75152310272 wanted 2488742 found 2488741
>> parent transid verify failed on 75152310272 wanted 2488742 found 2488741
>> Ignoring transid failure
>> ERROR: cannot open file system
>>
>> I've tried that because:
>>      backup 3:
>>   backup_tree_root:    75152310272    gen: 2488741 level: 1
>>
>>> Also kernel message for the mount failure could help.
>>
>> Sorry, my fault, I should start from this point:
>>
>> Dec 23 21:59:07 tisc5 kernel: [10319.442615] BTRFS: device fsid
>> be557007-42c9-4079-be16-568997e94cd9 devid 1 transid 2488742 /dev/loop0
>> Dec 23 22:00:49 tisc5 kernel: [10421.167028] BTRFS info (device loop0):
>> disk space caching is enabled
>> Dec 23 22:00:49 tisc5 kernel: [10421.167034] BTRFS info (device loop0):
>> has skinny extents
>> Dec 23 22:00:50 tisc5 kernel: [10421.807564] BTRFS critical (device
>> loop0): corrupt node: root=1 block=75150311424 slot=245, invalid NULL
>> node pointer
> This explains the problem.
> 
> Your root tree has one node pointer which is not correct.
> For pointer it should never points to 0.
> 
> This is pretty weird, at least some corruption pattern I have never seen.
> 
> Since your tree root get corrupted, there isn't much thing we can do,
> but try to use older tree roots.
> 
> You could go try all backup roots, starting from the newest backup (with
> highest generation), and check the backup root bytenr using:
> # btrfs check -r <backup root bytenr> <device>
> 
> To see which one get least error, but normally the chance is near 0.
> 
>> Dec 23 22:00:50 tisc5 kernel: [10421.807653] BTRFS error (device loop0):
>> failed to read block groups: -5
>> Dec 23 22:00:50 tisc5 kernel: [10421.877001] BTRFS error (device loop0):
>> open_ctree failed
>>
>>
>> So i tried to do:
>> 1) btrfs inspect-internal dump-super (with the snippet posted above)
>> 2) btrfs inspect-internal dump-tree -b 75150311424
>>
>> And it showed (header + snippet for items 243-248):
>> node 75150311424 level 1 items 249 free 244 generation 2488741 owner 2
>> fs uuid be557007-42c9-4079-be16-568997e94cd9
>> chunk uuid dbe69c7e-2d50-4001-af31-148c5475b48b
>> ...
>>    key (14799519744 EXTENT_ITEM 4096) block 233423224832 (14247023) gen
>> 2484894
>>    key (14811271168 EXTENT_ITEM 135168) block 656310272 (40058) gen 2488049
> 
> 
>>    key (1505328190277054464 UNKNOWN.4 366981796979539968) block 0 (0) gen 0
>>    key (0 UNKNOWN.0 1419267647995904) block 6468220747776 (394788864) gen
>> 7786775707648
> 
> Pretty obviously, these two nodes are garbage.
> Something corrupted the memory at runtime, and we don't have runtime
> check against corruption yet.
> 
> So IMHO, I think the problem is, some kernel code, either btrfs or other
> parts, corrupted the memory.
> And then btrfs fails to detect it, write it back to disk, and finally
> kernel get its chance to read the tree block from disk and finally
> caught the problem.
> 
> I could add such check for node, but normally it needs
> CONFIG_BTRFS_FS_CHECK_INTEGRITY, so makes no sense for normal user.
> 
>>    key (12884901888 EXTENT_ITEM 24576) block 816693248 (49847) gen 2484931
>>    key (14902849536 EXTENT_ITEM 131072) block 75135844352 (4585928) gen
>> 2488739
>>
>>
>> I looked at that numbers quite a while (also in hex) trying to figure
>> out what has happened (bit flips (it was on SSD), byte shifts (I
>> suspected bad CPU also ... because it has died after 2 months from
>> that)) and tried to guess "correct" values for that items ... but no
>> idea:-(
> 
> I'm not that sure, unless you're super lucky (or unlucky in this case),
> or it will normally get caught by csum first.
> 
>>
>> So this why I have asked about that log_root and whether there is a
>> chance to "log-replay things":-)
> 
> For your case, definitely not related to log replay.
> 
> Thanks,
> Qu
> 
>>
>>
>> Thanks
>> M.
> 
