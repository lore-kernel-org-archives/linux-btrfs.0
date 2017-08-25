Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:37484 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755258AbdHYL3E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 07:29:04 -0400
Received: by mail-io0-f171.google.com with SMTP id d81so6711782ioj.4
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 04:29:04 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id a15sm585692itj.43.2017.08.25.04.29.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Aug 2017 04:29:02 -0700 (PDT)
Subject: Re: user snapshots
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822215343.GP14804@rus.uni-stuttgart.de>
 <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
 <20170823101635.114d02d2@job> <20170823072048.GB28319@rus.uni-stuttgart.de>
 <22941.27164.739577.517915@tree.ty.sabi.co.uk>
 <20170823211325.GC28319@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3950fb01-e9b1-d48e-9c51-061a2f896193@gmail.com>
Date: Fri, 25 Aug 2017 07:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170823211325.GC28319@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-23 17:13, Ulli Horlacher wrote:
> On Wed 2017-08-23 (12:42), Peter Grandi wrote:
>>> So, still: What is the problem with user_subvol_rm_allowed?
>>
>> As usual, it is complicated: mostly that while subvol creation
>> is very cheap, subvol deletion can be very expensive. But then
>> so can be creating many snapshots, as in this:
> 
> But it seems one cannot prohibit a user making snapshots?
> Then root must delete them?
> 
That is correct.  This is one of the big outstanding issues with BTRFS 
being practical for enterprise usage, because it means anyone with basic 
shell access and either the ability to run arbitrary byte code or access 
to execute /sbin/btrfs can exhaust system resources with no effort 
whatsoever.  Taken together with how subvolume creation interacts with 
qgroups, it also means that qgroups are useless in the same situation 
because it's trivial to escape them.
