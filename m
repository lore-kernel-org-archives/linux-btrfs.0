Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40906C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 12:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 062512175B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 12:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYFHpJFz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfBGMSU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:18:20 -0500
Received: from mail-it1-f171.google.com ([209.85.166.171]:54922 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfBGMSU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 07:18:20 -0500
Received: by mail-it1-f171.google.com with SMTP id i145so14227914ita.4
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 04:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+ImJ4s13cpfwmL1ULOdvUtymmfwX9Nid0gGFGHfFV0w=;
        b=mYFHpJFzSYZSSocnoc45fXp8tBdJzEd+YvFVKzRcm6pec95QzFgMC4JOU+3XtceexP
         lp+SWDhL1WIDFRud0FatWRce1Tm9Qmj5cuUgBB0wNGEPl/jGujM+7LJpBfz3j2kbSPEQ
         v8GJK4yukSAQP0o7ILv5g9pKPLLK4ZKHKIEn1I4iY5CyCgaw5gZR7OEZbGJBKP4+gukg
         klPS0oi/77+/b4oRLjX3b9vYuRcGwGxltsHC8JMoFR+WOhnHIFkmLq10eSBVkwS2d5St
         PRi37Nq/ZF40Vw0tRNL4rcNozkoBhH7xyiXtLc9Lixe2WCpgVENi0Rg+TX/xiC+fOhCK
         6IcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ImJ4s13cpfwmL1ULOdvUtymmfwX9Nid0gGFGHfFV0w=;
        b=YXVNLEfaSKEBxlpIBPAIZzi2ziz6D/ZPFzC54K0EWYX2aTF+XSV56R+M2SF19vJuhp
         ZJUCyaKxE9g6p7NMhyohtqZFuV9b62Wh2jtq4vTFCbidRFEZ9/iHK6y/7aEyVP5htM6O
         DZzepuJ3RuoXBed3tpS8pSneaTfkX1L5mFbsjkT0V8UGnib4Eds4VysIqAsFXzZjg7kC
         MUn0zAGzX/onu16TK5BpuGQ9rhxNpR1kT7BwBmVB0G4a1UIRhZhMOPsY0xRmowh7/9/A
         PJXADA3nzfEteW0+N+vEyv9XAvmJhBebb30C+6VfHMADIGfFShOrsOaRH//T8cQOuaO8
         24wg==
X-Gm-Message-State: AHQUAuasjG12BwPYR79lkxMBZJdprghQ6RAvzaeT7XpUX2yK0C0WnSWY
        h/uqFApCJNjv46JRrZOuB/6rc0vlavI=
X-Google-Smtp-Source: AHgI3IYmbCQlf0qJ8SSN5jBWfaDcZIZKvTiluV1AWjsqXGN9M+F7ycu7rGaiCr38VdsI7esxOvMlXQ==
X-Received: by 2002:a24:2b83:: with SMTP id h125mr248628ita.4.1549541898625;
        Thu, 07 Feb 2019 04:18:18 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f142sm5861278itc.15.2019.02.07.04.18.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 04:18:17 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     Stefan K <shadow_7@gmx.net>, linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
Date:   Thu, 7 Feb 2019 07:18:14 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <2159107.RxXdQBBoNF@t460-skr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-07 06:04, Stefan K wrote:
> Thanks, with degraded  as kernel parameter and also ind the fstab it works like expected
> 
> That should be the normal behaviour, cause a server must be up and running, and I don't care about a device loss, thats why I use a RAID1. The device-loss problem can I fix later, but its important that a server is up and running, i got informed at boot time and also in the logs files that a device is missing, also I see that if you use a monitoring program.
No, it shouldn't be the default, because:

* Normal desktop users _never_ look at the log files or boot info, and 
rarely run monitoring programs, so they as a general rule won't notice 
until it's already too late.  BTRFS isn't just a server filesystem, so 
it needs to be safe for regular users too.
* It's easily possible to end up mounting degraded by accident if one of 
the constituent devices is slow to enumerate, and this can easily result 
in a split-brain scenario where all devices have diverged and the volume 
can only be repaired by recreating it from scratch.
* We have _ZERO_ automatic recovery from this situation.  This makes 
both of the above mentioned issues far more dangerous.
* It just plain does not work with most systemd setups, because systemd 
will hang waiting on all the devices to appear due to the fact that they 
refuse to acknowledge that the only way to correctly know if a BTRFS 
volume will mount is to just try and mount it.
* Given that new kernels still don't properly generate half-raid1 chunks 
when a device is missing in a two-device raid1 setup, there's a very 
real possibility that users will have trouble recovering filesystems 
with old recovery media (IOW, any recovery environment running a kernel 
before 4.14 will not mount the volume correctly).
* You shouldn't be mounting writable and degraded for any reason other 
than fixing the volume (or converting it to a single profile until you 
can fix it), even aside from the other issues.
> 
> So please change the normal behavior
> 
> On Friday, February 1, 2019 7:13:16 PM CET Hans van Kranenburg wrote:
>> Hi Stefan,
>>
>> On 2/1/19 11:28 AM, Stefan K wrote:
>>>
>>> I've installed my Debian Stretch to have / on btrfs with raid1 on 2
>>> SSDs. Today I want test if it works, it works fine until the server
>>> is running and the SSD get broken and I can change this, but it looks
>>> like that it does not work if the SSD fails until restart. I got the
>>> error, that one of the Disks can't be read and I got a initramfs
>>> prompt, I expected that it still runs like mdraid and said something
>>> is missing.
>>>
>>> My question is, is it possible to configure btrfs/fstab/grub that it
>>> still boot? (that is what I expected from a RAID1)
>>
>> Yes. I'm not the expert in this area, but I see you haven't got a reply
>> today yet, so I'll try.
>>
>> What you see happening is correct. This is the default behavior.
>>
>> To be able to boot into your system with a missing disk, you can add...
>>      rootflags=degraded
>> ...to the linux kernel command line by editing it on the fly when you
>> are in the GRUB menu.
>>
>> This allows the filesystem to start in 'degraded' mode this one time.
>> The only thing you should be doing when the system is booted is have a
>> new disk present already in place and fix the btrfs situation. This
>> means things like cloning the partition table of the disk that's still
>> working, doing whatever else is needed in your situation and then
>> running btrfs replace to replace the missing disk with the new one, and
>> then making sure you don't have "single" block groups left (using btrfs
>> balance), which might have been created for new writes when the
>> filesystem was running in degraded mode.
>>
>> -- 
>> Hans van Kranenburg
>>
> 

