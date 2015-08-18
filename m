Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36451 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbHRPKB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 11:10:01 -0400
Received: by iodv127 with SMTP id v127so176844616iod.3
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 08:10:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8aatLabiTc4gBH5NEgh2ZeE=ufYNb8euieNYebs4JmBg@mail.gmail.com>
References: <CAK7bmU88ZfLJmFfMiV=q9RjS+=vAWbniu9w6MUTv_xSG+-hj_g@mail.gmail.com>
	<55D1C8D3.5090501@gmail.com>
	<CAK7bmU_oXstgxwkWY_6tSc90aU-=WKh0TLH+1Xw+ec3YZogzbQ@mail.gmail.com>
	<55D31533.4040409@gmail.com>
	<CAK7bmU8aatLabiTc4gBH5NEgh2ZeE=ufYNb8euieNYebs4JmBg@mail.gmail.com>
Date: Tue, 18 Aug 2015 11:10:01 -0400
Message-ID: <CAK7bmU8uXvAcqWZbJs_Hv5LxG0R9_+pG-ecj1k8Np2q_+yNK_w@mail.gmail.com>
Subject: Re: So, wipe it out and start over or keep debugging?
From: Timothy Normand Miller <theosib@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I ran the following command.  It spent a lot of time creating a
1672450048 byte file.  Then it stopped writing to the file and started
using 100% CPU.  It's currently doing no I/O, and it's been doing that
for a while now.  Is that supposed to happen?

On Tue, Aug 18, 2015 at 9:30 AM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> In that case, do I need to do all four block devices separately, or
> will the tool figure it out?
>
> On Tue, Aug 18, 2015 at 7:21 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-08-17 14:52, Timothy Normand Miller wrote:
>>>
>>> I'm not sure if I'm doing this wrong.  Here's what I'm seeing:
>>>
>>> # btrfs-image -c9 -t4 -w /mnt/btrfs ~/btrfs_dump.z
>>> Superblock bytenr is larger than device size
>>> Open ctree failed
>>> create failed (No such file or directory)
>>
>>
>> For the source, you need to specify the underlying block device, not the top
>> of the mounted filesystem.  It's trying to read the directory as a block
>> device and getting very confused.  We should probably add some kind of check
>> to btrfs-image to warn about that.
>>
>>
>
>
>
> --
> Timothy Normand Miller, PhD
> Assistant Professor of Computer Science, Binghamton University
> http://www.cs.binghamton.edu/~millerti/
> Open Graphics Project



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
