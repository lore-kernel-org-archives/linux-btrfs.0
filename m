Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37629 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbbHQSwR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 14:52:17 -0400
Received: by igui7 with SMTP id i7so62491344igu.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 11:52:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D1C8D3.5090501@gmail.com>
References: <CAK7bmU88ZfLJmFfMiV=q9RjS+=vAWbniu9w6MUTv_xSG+-hj_g@mail.gmail.com>
	<55D1C8D3.5090501@gmail.com>
Date: Mon, 17 Aug 2015 14:52:17 -0400
Message-ID: <CAK7bmU_oXstgxwkWY_6tSc90aU-=WKh0TLH+1Xw+ec3YZogzbQ@mail.gmail.com>
Subject: Re: So, wipe it out and start over or keep debugging?
From: Timothy Normand Miller <theosib@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure if I'm doing this wrong.  Here's what I'm seeing:

# btrfs-image -c9 -t4 -w /mnt/btrfs ~/btrfs_dump.z
Superblock bytenr is larger than device size
Open ctree failed
create failed (No such file or directory)


On Mon, Aug 17, 2015 at 7:43 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-08-15 17:46, Timothy Normand Miller wrote:
>>
>> To those of you who have been helping out with my 4-drive RAID1
>> situation, is there anything further we should do to investigate this,
>> in case we can uncover any more bugs, or should I just wipe everything
>> out and restore from backup?
>>
> If you need the system back online, then my suggestion would be to use
> btrfs-image to get metadata images of the disks (there's an option to clear
> out private data if need be), and then restore from backup.  That way, we
> still have the problematic images to work with and examine.
>



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
