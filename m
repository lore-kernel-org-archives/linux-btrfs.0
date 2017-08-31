Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:37923 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdHaLS1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:18:27 -0400
Received: by mail-io0-f196.google.com with SMTP id m40so3906359ioi.5
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 04:18:26 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id z72sm3645366ioz.13.2017.08.31.04.18.24
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Aug 2017 04:18:24 -0700 (PDT)
Subject: Re: number of subvolumes
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822204811.GO14804@rus.uni-stuttgart.de>
 <20170823071821.GA28319@rus.uni-stuttgart.de>
 <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
 <22943.4266.793339.528061@tree.ty.sabi.co.uk>
 <20170831064916.GA5783@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0b8ff573-ae13-121a-dd14-29d0de72ef58@gmail.com>
Date: Thu, 31 Aug 2017 07:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <20170831064916.GA5783@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 02:49, Ulli Horlacher wrote:
> On Thu 2017-08-24 (18:45), Peter Grandi wrote:
> 
>> As usual with Btrfs, there are corner cases to avoid: 'defrag'
>> should be done before 'balance'
> 
> Good hint. So far I did it the other way: balance before defrag.
> I will switch.
For reference, the reason to do things this way is that defragmenting a 
filesystem may result in undoing some of the work balance did.
> 
> 
>> and with compression switched off
> 
> I have filesystems with compress mount option:
> 
> framstag@fex:~: grep /local /etc/fstab
> LABEL=local /local btrfs  defaults,compress,user_subvol_rm_allowed 0 2
> 
> and a weekly cronjob, which does a defrag and balance.
> I cannot disable compression.
> Any hint here?
Having compression enabled causes no issues with defray and balance. 
There appears to be a prevalent belief however that defrag is pointless 
if you're using compression, probably because some versions of 
`filefrag` don't report compressed extents properly (they list each 128k 
compressed unit as one extent, which is wrong).
> 
> 
>> I prefer dump-and-reload.
> 
> What do you mean by this?
I believe he means to copy everything off the filesystem, recreate it, 
and copy everything back in.  That will actually get you much closer to 
an optimal layout than a defrag=balance cycle, but it also takes a long 
time, requires extra space, and the layout will usually become 
sub-optimal almost immediately when you start writing to the filesystem.
