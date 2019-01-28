Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4E8C282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 22:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370962175B
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 22:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfUZgDrh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfA1WHu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 17:07:50 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44563 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfA1WHu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 17:07:50 -0500
Received: by mail-pl1-f194.google.com with SMTP id e11so8353629plt.11
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2019 14:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=tIV35eEoJbKztnGy1QELF47nhcJq/ISDswi9X2drePg=;
        b=OfUZgDrhY1opiRkcuPXZrxE49R6BMXIupw5OCVfniMRs92+YSSGEKFaxJvG3tjpQUs
         qE8fXoVLKQ8yxZLwVBrL3nEIeIrtnaA2AOEV5IZT0+q3+qFJSUWprADZXkBH84SV1/sO
         UosdxJqH+c7guBN/yBw9LfZ9oZh56fhXhSnBsxpSlu3p/VHoujMPDexHoovmKBWjtzQx
         e/SRg2hSeTZLI7AvYNXhytRZY3qy0V0IBhf5D0Cl/1Ru0yHA9y1OocRQcHMFt3X7hVT6
         F3ztmlUNCq2U5d9kF5+gcN5e8OierpjAYqzQSFQ4sCxyz1ZShxXdTuuAZasXn9t1rP3c
         k2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tIV35eEoJbKztnGy1QELF47nhcJq/ISDswi9X2drePg=;
        b=ozbKKa2j/5kb5UCx7XHdNbu0EVJec21gSSjZ4GvhbaAF7i3Kawculq5DxZ9A+Z9Mou
         /zEdU4KwOts9+61p9JL8OnKD+SZBPdYwbbpBwSh2EfTGlKc/5JxBBX2TZpI4o9ntw1bg
         loWfZLzSKgEk7QT20sM0QCrGCvh+KylqE/lUaf7YuCreKtw9tR2PXN4OZAmQS2eShnaJ
         ZUl4+LYKaEDoUbse+ZIpV6uodkG5v7RFOvskiaWNe9UsbHJPDYBr4Fkh43B1f/mnUSgW
         1uPDc3pv69hljcLdCkxPi975ZNpBBEtusrY2gpK9/17BvaPOI+znHfP8oPyedT+5+ZID
         3Bpg==
X-Gm-Message-State: AJcUukcrX8sIavTlFFaNlp9xpmOoAEEOGT+faftR6VX3sJcwcU50FSmB
        SwGUmHUpcv9wqvRwjqKB6U3h7TN2
X-Google-Smtp-Source: ALg8bN76TsBf3lKhUd5/9hnsodywrpJHqnihF24l9bU+eLrTo7lDu4l8m6U8u3PqWDMmaCINlcAXUg==
X-Received: by 2002:a17:902:b18b:: with SMTP id s11mr23334565plr.56.1548713268976;
        Mon, 28 Jan 2019 14:07:48 -0800 (PST)
Received: from [192.168.178.53] (14-201-16-168.static.tpgi.com.au. [14.201.16.168])
        by smtp.gmail.com with ESMTPSA id i193sm96461651pgc.22.2019.01.28.14.07.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 14:07:48 -0800 (PST)
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
From:   DanglingPointer <danglingpointerexception@gmail.com>
Message-ID: <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
Date:   Tue, 29 Jan 2019 09:07:44 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-AU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks Qu!
I thought as much from following the mailing list and your great work 
over the years!

Would it be possible to get the wiki updated to reflect the current 
"real" status?

 From Qu's statement and perspective, there's no difference to other 
non-BTRFS software RAID56's out there that are marked as stable (except 
ZFS).
Also there are no "multiple serious data-loss bugs".
Please do consider my proposal as it will decrease the amount of 
incorrect paranoia that exists in the community.
As long as the Wiki properly mentions the current state with the options 
for mitigation; like backup power and perhaps RAID1 for metadata or 
anything else you believe as appropriate.


Thanks,

DP


On 28/1/19 11:52 am, Qu Wenruo wrote:
>
> On 2019/1/26 下午7:45, DanglingPointer wrote:
>>
>> Hi All,
>>
>> For clarity for the masses, what are the "multiple serious data-loss
>> bugs" as mentioned in the btrfs wiki?
>> The bullet points on this page:
>> https://btrfs.wiki.kernel.org/index.php/RAID56
>> don't enumerate the bugs.  Not even in a high level.  If anything what
>> can be closest to a bug or issue or "resilience use-case missing" would
>> be the first point on that page.
>>
>> "Parity may be inconsistent after a crash (the "write hole"). The
>> problem born when after "an unclean shutdown" a disk failure happens.
>> But these are *two* distinct failures. These together break the BTRFS
>> raid5 redundancy. If you run a scrub process after "an unclean shutdown"
>> (with no disk failure in between) those data which match their checksum
>> can still be read out while the mismatched data are lost forever."
>>
>> So in a nutshell; "What are the multiple serious data-loss bugs?".
> There used to be two, like scrub racing (minor), and screwing up good
> copy when doing recovery (major).
>
> Although these two should already be fixed.
>
> So for current upstream kernel, there should be no major problem despite
> write hole.
>
> Thanks,
> Qu
>
>> If
>> there aren't any, perhaps updating the wiki should be considered for
>> something less the "dramatic" .
>>
>>
>>
