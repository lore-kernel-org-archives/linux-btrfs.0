Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC80C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 17:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A0A72083D
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 17:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZaulqaAS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A0A72083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbeLGRbP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 12:31:15 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41318 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbeLGRbO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 12:31:14 -0500
Received: by mail-qt1-f193.google.com with SMTP id d18so5298069qto.8
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Dec 2018 09:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ELvd7ifAv/OnvUyijjRZxcGj/ir+4TBPOpRbPsG8i6Q=;
        b=ZaulqaASYav2eTMQc/UaQGKlOzvw+PpyVEGrhd6X6ecNSgMvDqOf8nYhvuaqAjG4+9
         bYOqsKs3KJRcz3o2fQGgWCS9+KUVn/7r4Kxdn6khS89PA2lv9/r3rj45GIhCXoAE58yn
         ulaU3gxtNIVu04AOEeFW2MDNzPm10smrAF8BxJTrIKA1Y5yK8eACWIk0EWKakv1iet2L
         hd4ljltZjztqbM2Kwrp30TOlZSIrSG5f5wjSixVtL+2DTtktmpzU7p2drGUbQfPGII/5
         2TL5F2zlyXNgra+1ITENZwc9Z+hRZXai8vWsQBeHqhzVaob1Ntns1EnLLhO8RsbVHGBL
         hh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ELvd7ifAv/OnvUyijjRZxcGj/ir+4TBPOpRbPsG8i6Q=;
        b=cENasjwNvSeP+EnBwS6ck2rFepEwgC6gHFiLi5I0DqoeoAEvtj1f6bTj9A5nT0PWa4
         G2ViJ39SS9uePPmA1dOPTqJi2VyYQNPDXcvPhuhs0b7KwxbPPs1Pw0l7TXRiu08S3InR
         hBHKwgbjfnkkH1dgOT/G73ct/ADfrX5sOWdYO3gN8TTgKIuDOZ9J38EzdsLeXI1dPCin
         DEkgShDn7+VHRmMF+mADgpPplpLIH9rCtFHmV+lwwGAjMk5b2+wxN7KLmKMeaPX7fSJQ
         T9afIAXqKEEa4jo7dUy/g7cxRYzhAGxzRiYEa+VxteGDDGrj3aqb3A4ckyqbZh8qAW23
         5iuQ==
X-Gm-Message-State: AA+aEWYYiPe49AM/XlPxBfzqjdbjeJldAyusoyqQ/MhnB5WW7YL0RLaC
        /MB6d0bXIHHJHzTxfrHwU/ccYheqVns=
X-Google-Smtp-Source: AFSGD/XjOMgnUAYIdp4XMQ9oCH7KbAWcCHJB1fnhBDhz5oBlHuaQ3NSbbmbKzmylWjBJXpybiJZDSA==
X-Received: by 2002:ad4:410c:: with SMTP id i12mr2836215qvp.219.1544203872542;
        Fri, 07 Dec 2018 09:31:12 -0800 (PST)
Received: from [192.168.1.104] (c-67-172-41-146.hsd1.ma.comcast.net. [67.172.41.146])
        by smtp.gmail.com with ESMTPSA id o25sm2794132qtj.10.2018.12.07.09.31.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 09:31:11 -0800 (PST)
Subject: Re: System unable to mount partition after a power loss
From:   Doni Crosby <doni.crosby1995@gmail.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
 <1a8e4805-10a5-8203-5f62-7cd572ca578e@gmx.com>
 <CAJkMDBxD89DFYxV3Nc8EqKDupcxM2+kNGLtTo6QDWaTz-juT6g@mail.gmail.com>
Message-ID: <2087f820-798c-c85d-a429-63c24acb8a65@gmail.com>
Date:   Fri, 7 Dec 2018 12:31:11 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAJkMDBxD89DFYxV3Nc8EqKDupcxM2+kNGLtTo6QDWaTz-juT6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I ran that command and I cannot get the email to send properly to the 
mailing list as the attachment of the output is over 4.6M.

On 12/7/2018 11:49 AM, Doni Crosby wrote:
> The output of the command is attached. This is what errors showed up
> on the system:
> parent transid verify failed on 3563224842240 wanted 5184691 found 5184689
> parent transid verify failed on 3563224842240 wanted 5184691 found 5184689
> parent transid verify failed on 3563222974464 wanted 5184691 found 5184688
> parent transid verify failed on 3563222974464 wanted 5184691 found 5184688
> parent transid verify failed on 3563223121920 wanted 5184691 found 5184688
> parent transid verify failed on 3563223121920 wanted 5184691 found 5184688
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
> Ignoring transid failure
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
> Ignoring transid failure
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
> Ignoring transid failure
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
> Ignoring transid failure
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
> Ignoring transid failure
> WARNING: eb corrupted: parent bytenr 31801344 slot 132 level 1 child
> bytenr 3563231461376 level has 1 expect 0, skipping the slot
> parent transid verify failed on 3563231494144 wanted 5184691 found 5183325
> parent transid verify failed on 3563231494144 wanted 5184691 found 5183325
> parent transid verify failed on 3563231494144 wanted 5184691 found 5183325
> parent transid verify failed on 3563231494144 wanted 5184691 found 5183325
> Ignoring transid failure
> parent transid verify failed on 3563231526912 wanted 5184691 found 5183325
> parent transid verify failed on 3563231526912 wanted 5184691 found 5183325
> parent transid verify failed on 3563231526912 wanted 5184691 found 5183325
> parent transid verify failed on 3563231526912 wanted 5184691 found 5183325
> Ignoring transid failure
> parent transid verify failed on 3563229626368 wanted 5184691 found 5184689
> parent transid verify failed on 3563229626368 wanted 5184691 found 5184689
> parent transid verify failed on 3563229937664 wanted 5184691 found 5184689
> parent transid verify failed on 3563229937664 wanted 5184691 found 5184689
> parent transid verify failed on 3563226857472 wanted 5184691 found 5184689
> parent transid verify failed on 3563226857472 wanted 5184691 found 5184689
> parent transid verify failed on 3563230674944 wanted 5184691 found 5183325
> parent transid verify failed on 3563230674944 wanted 5184691 found 5183325
> parent transid verify failed on 3563230674944 wanted 5184691 found 5183325
> parent transid verify failed on 3563230674944 wanted 5184691 found 5183325
> Ignoring transid failure
> On Fri, Dec 7, 2018 at 2:22 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>
>> On 2018/12/7 下午1:24, Doni Crosby wrote:
>>> All,
>>>
>>> I'm coming to you to see if there is a way to fix or at least recover
>>> most of the data I have from a btrfs filesystem. The system went down
>>> after both a breaker and the battery backup failed. I cannot currently
>>> mount the system, with the following error from dmesg:
>>>
>>> Note: The vda1 is just the entire disk being passed from the VM host
>>> to the VM it's not an actual true virtual block device
>>>
>>> [ 499.704398] BTRFS info (device vda1): disk space caching is enabled
>>> [  499.704401] BTRFS info (device vda1): has skinny extents
>>> [  499.739522] BTRFS error (device vda1): parent transid verify failed
>>> on 3563231428608 wanted 5184691 found 5183327
>>
>> Transid mismatch normally means the fs is screwed up more or less.
>>
>> And according to your mount failure, it looks the fs get screwed up badly.
>>
>> What's the kernel version used in the VM?
>> I don't really think the VM is always using the latest kernel.
>>
>>> [  499.740257] BTRFS error (device vda1): parent transid verify failed
>>> on 3563231428608 wanted 5184691 found 5183327
>>> [  499.770847] BTRFS error (device vda1): open_ctree failed
>>>
>>> I have tried running btrfsck:
>>> parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563221630976 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563221630976 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224072192 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563224072192 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563225268224 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563225268224 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563227398144 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563227398144 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
>>
>> According to your later dump-super output, it looks pretty possible that
>> the corrupted extents are all belonging to extent tree.
>>
>> So it's still possible that your fs tree and other essential trees are OK.
>>
>> Please dump the following output (with its stderr) to further confirm
>> the damage.
>> # btrfs ins dump-tree -b 31801344 --follow /dev/vda1
>>
>> If your objective is only to recover data, then you could start to try
>> btrfs-restore.
>> It's pretty hard to fix the heavily damaged extent tree.
>>
>> Thanks,
>> Qu
>>> Ignoring transid failure
>>> Checking filesystem on /dev/vda1
>>> UUID: 7c76bb05-b3dc-4804-bf56-88d010a214c6
>>> checking extents
>>> parent transid verify failed on 3563224842240 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563224842240 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563222974464 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563222974464 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563223121920 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563223121920 wanted 5184691 found 5184688
>>> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
>>> parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
>>> Ignoring transid failure
>>> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
>>> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
>>> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
>>> parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
>>> Ignoring transid failure
>>> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
>>> Ignoring transid failure
>>> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
>>> Ignoring transid failure
>>> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
>>> parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
>>> Ignoring transid failure
>>> Segmentation fault
>>>
>>> btrfs check --recover also ends in a segmentation fault
>>>
>>> I am aware of chunk-recover and have tried to run it but got weary
>>> when I saw dev0 not vda1.
>>>
>>> Any help would be appreciated,
>>> Doni
>>>
>>> uname -a:
>>> Linux Homophone 4.18.0-0.bpo.1-amd64 #1 SMP Debian 4.18.6-1~bpo9+1
>>> (2018-09-13) x86_64 GNU/Linux
>>>
>>> btrfs --version:
>>> btrfs-progs v4.7.3
>>>
>>> btrfs fi show:
>>> Label: 'Array'  uuid: 7c76bb05-b3dc-4804-bf56-88d010a214c6
>>>          Total devices 1 FS bytes used 6.05TiB
>>>          devid    1 size 29.11TiB used 6.13TiB path /dev/vda1
>>>
>>
