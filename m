Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:34002 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbbHYXRq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 19:17:46 -0400
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com [209.85.213.54])
	(authenticated bits=0)
	by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id t7PNHh7t009447
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 16:17:44 -0700
Received: by vkfi73 with SMTP id i73so81858002vkf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 16:17:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55DC8F96.2010506@gmail.com>
References: <1440516154.040713246@apps.rackspace.com>
	<55DC8F96.2010506@gmail.com>
Date: Tue, 25 Aug 2015 16:17:43 -0700
Message-ID: <CAPF83msAozQGQaC7juBwU1deJnauuh9DRUuVg5FgWOny1vDaRA@mail.gmail.com>
Subject: Re: Response to Bcachefs Claims
From: Suman Chakravartula <suman@rockstor.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 8:53 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-08-25 11:22, Vincent Olivier wrote:
>>
>> Hi,
>>
>> I have been using Btrfs for almost a year now with a 16x4TB RAID10 and its
>> 8x4TB RAID0 backup (using incremental snapshots diffs). I have always tried
>> to stay at the latest stable kernel (currently 4.1.6). But I might be moving
>> to Fedora 22 because Centos 7 has significant incompatibilities with the
>> 4.1.x kernel series.
>>
>> I have seen the news about Bcachefs aiming to be Btrfs-complete while
>> being extX-stable.
>>
>> What are the chances Bcachefs beats Btrfs at being the Linux kernel's next
>> "official" file system ? I chose Btrfs over ZFS because it seemed like the
>> only "next-gen" heir to ext4/xfs.
>>
>> I have been having a few problems with Btrfs myself. I have only one that
>> remains unresolved : I haven't found the best way to mount Btrfs at boot
>> time. "LABEL=" won't work for known reasons (I don't understand however why
>> a mount can't do its own "device scan" transparently). "UUID=" won't work
>> for unknown reasons (haven't got a reply on this, maybe it's the same as
>> "LABEL="). And I will use /dev/* in fstab for stability reasons. Right now
>> I'm mounting the fs manually after a "device scan" and picking up the first
>> device that shows up in the "fi show" run. I can "live" with that but I
>> suppose that things like this contribute to the feeling that Btrfs is
>> actually still experimental contrarily to claims that it is
>> production-ready.
>>
>> For my own sake and other's I would like to maintain (if nobody is already
>> working on that nor needs any help) a centralized human-readable digest of
>> known issues that would be featured prominently on top of the Btrfs wiki. I
>> would merge the Gotchas page and the various known issues pages (including
>> the various multi-device mount gotchas here and there).
>>
>> Answers ? Comments ? Help ?
>
> First off, I think this is a wonderful idea.  The list of known issues isn't
> always particularly up to date, and isn't as trivial to find as it should
> be.
>

I think it's a great idea too and would like to contribute. Can
someone please lead the way?


-- 
Suman Chakravartula
Founder @ Rockstor

http://rockstor.com
http://rockstor.com/blog
http://forum.rockstor.com
