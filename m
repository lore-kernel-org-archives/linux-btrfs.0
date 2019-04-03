Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7B4C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 18:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A31EA2084B
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 18:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rHKjMr1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfDCSoP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 14:44:15 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:54851 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfDCSoP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 14:44:15 -0400
Received: by mail-it1-f194.google.com with SMTP id a190so11312545ite.4
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Apr 2019 11:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IhDDNsXQ0P7ORBa2kZR3NHTB6odVwmDRUfuNbYVbZGA=;
        b=rHKjMr1oNGGSSDvoS+S/LhhOMJizrXKCzxHeyqzFRLdkqlsgTyEY8g2UjsQYcrMNPm
         zeZOQlqTEFiGBZR6gz8oZ7NekEW2P0wHFy2gnMRUly7IOHypnaYodTJd0zDE+2wj3DQc
         qAKJlPbH8J8THSG+kL3HbRORN7xsRcOkoYYaDyv+TYTaewQaL00C4IgG6DILnjYqDDsS
         Y/RangaeMVJ1ZWjigvYOLpdzk3MHymj9v2iK8huwDj7MyUpGtps8sOROlS0bXc35fUon
         PzCcaJi0Onj7Ku4sbXA/BOtBKyJglS0EN4FHdejkTum/VWu1EekTdkqWlj7nmiMu9SWv
         qkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IhDDNsXQ0P7ORBa2kZR3NHTB6odVwmDRUfuNbYVbZGA=;
        b=GzX1QqYUv8R3m9rd0zLrvcO4Zv+enAZGVRhk5d8euzE8GX3eVa7nRA0R50POVd38E6
         ma8C+A6O2JZ6u51D+vTW3fdGjo39PsgDR3G+g+3YzdcvzBYJZI2+l6eEGptplPJtio4e
         jOvapqGiHP5HvnaXHtV9n3LREWnC8ZVVTzk41n/LBj7kE2Gi7Iu/taezZIgbrp4Enp0U
         Fb3mxEOyTweFBmelfNDxr6APk5jRLtRU3VzGP8nLHtREyZIS1+a2uktO7r2nkzUabltF
         WcPIquqXWD0aD+LmLstdpeE41ikkDqGT1540ifbxMaXgUvNnRdj+dpJhytUwKSQX2slt
         EKVQ==
X-Gm-Message-State: APjAAAUN0vuMlmEzO6QxrfpsMfY7Rh+VihRnEzEVr+0r74Zi/6cR7w2M
        curYBfmeCQpTm1ej6TIWVtvpifTb9rU=
X-Google-Smtp-Source: APXvYqxaAa8u/aWarR0we/wHzx1b9Ppc+KfIlVpTsNzJ0+kk3JYuVFLKy2WPBo74nX6ydTtNNIK/Og==
X-Received: by 2002:a02:6553:: with SMTP id u80mr1528891jab.51.1554317053441;
        Wed, 03 Apr 2019 11:44:13 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 64sm9209643itv.16.2019.04.03.11.44.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Apr 2019 11:44:12 -0700 (PDT)
Subject: Re: btrfs and write barriers
To:     Hendrik Friedel <hendrik@friedels.name>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
 <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
 <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9e438df4-f477-9aac-103b-fea479caacc9@gmail.com>
Date:   Wed, 3 Apr 2019 14:44:09 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-04-03 14:17, Hendrik Friedel wrote:
> Hello,
> 
> thanks for your reply.
> 
>>> 3) Even more, it would be good, if btrfs would disable the write cache
>>> in that case, so that one does not need to rely on the user
>> Personally speaking, if user really believes it's write cache causing
>> the problem or want to be extra safe, then they should disable cache.
> How many percent of the users will be able to judge that?
>> As long as FLUSH is implemented without problem, the only faulty part is
>> btrfs itself and I haven't found any proof of either yet.
> But you have searched?
> 
>  >>2) I find the location of the (only?) warning -dmesg- well hidden. I 
> think it would be better to notify the user when creating the file-system.
>  >A notification on creating the volume and ones when adding devices 
> (either via `device add` or via a replace operation)
>  >would indeed be nice, but we should still keep the kernel log warning.
> 
> Ok, so what would be the way to move forward on that? Would it help if I 
> create an issue in a https://bugzilla.kernel.org/ ?
The biggest issue is actually figuring out if the devices don't support 
write barriers (which means no FLUSH or broken FLUSH on Linux, not no 
FUA/DPO, because as long as the device properly implements FLUSH (and 
most do), Linux will provide a FUA emulation which works for write 
barriers).  Once you've got that, it should be pretty trivial to add to 
the messages.
> 
>  >>3) Even more, it would be good, if btrfs would disable the write 
> cache in that case, so that one does not need to rely on the user
>  > I would tend to disagree here. We should definitely _recommend_ this 
> to the user if we know there is no barrier support, but just
>  > doing it behind their back is not a good idea.
> 
> Well, there is some room between 'automatic' and 'behind their back. E.g.
> "Barriers are not supported by /dev/sda. Automatically disabling 
> write-cache on mount. You can suppress this with the 
> 'enable-cache-despite-no-barrier-support-I-know-what-I-am-doing' mount 
> option (maybe, we can shorten the option).
And that's still 'behind the back' because it's a layering violation. 
Even LVM and MD don't do this, and they have even worse issues than we 
do because they aren't CoW.
> 
>  > There are also plenty of valid reasons to want to use the write cache 
> anyway.
> I cannot think of one. Who would sacrifice data integrity/potential 
> total loss of the filesystem for speed?
There are quite a few cases where the risk of data loss _just doesn't 
matter_, and any data that could be invalid is also inherently stale. 
Some trivial examples:

* /run on any modern Linux system. Primarily contains sockets used by 
running services, PID files for daemons, and other similar things that 
only matter for the duration of the current boot of the system. These 
days, it's usually in-memory, but some people with really tight memory 
constraints still use persistent storage for it to save memory.
* /tmp on any sane UNIX system. Similar case to above, but usually for 
stuff that only matters on the scale of session lifetimes, or even just 
process lifetimes.
* /var/tmp on most Linux systems. Usually the same case as /tmp.
* /var/cache on any sane UNIX system. By definition, if the data here is 
lost, it doesn't matter, as it only exists for performance reasons 
anyway. Smart applications will even validate the files they put here, 
so corruption isn't an issue either.

There are bunches of other examples I could list, but all of them are 
far more situational and application specific.
> 
>  > As far as FUA/DPO, I know of exactly _zero_ devices that lie about 
> implementing it and don't.
> ...
>  > but the fact that Linux used to not issue a FLUSH command to the 
> disks when you called fsync in userspace.
> Ok, thanks for that clarification.
