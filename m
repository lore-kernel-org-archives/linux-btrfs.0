Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33389 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbHNTyh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 15:54:37 -0400
Received: by vkbg64 with SMTP id g64so20855932vkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 12:54:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CE4682.3080106@gmail.com>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
	<CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
	<55CE4682.3080106@gmail.com>
Date: Fri, 14 Aug 2015 13:54:36 -0600
Message-ID: <CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
Subject: Re: The performance is not as expected when used several disks on raid0.
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 1:50 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-08-14 14:31, Chris Murphy wrote:
>>
>> On Fri, Aug 14, 2015 at 9:16 AM, Eduardo Bach <hellbach@gmail.com> wrote:
>>
>>> With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
>>> result reaches 6gb/s, which is the expected value when compared with
>>> parallel dd made on discs.
>>
>>
>> mdadm with what chunk (strip) size? The default for mdadm is 512KiB.
>> On Btrfs it's fixed at 64KiB. While testing with 64KiB chunk with XFS
>> on md RAID might improve its performance relative to Btrfs, at least
>> it's a more apples to apples comparison.
>>
> I have a feeling that XFS will still win this.  It is one of the slower
> filesystems for Linux, but it still beats BTRFS senseless when it comes to
> performance as of right now.

Yeah I was suggesting with a 64KiB chunk the XFS case might get even faster.


-- 
Chris Murphy
