Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:35178 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbH1IuO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 04:50:14 -0400
Received: by labqb2 with SMTP id qb2so3814800lab.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 01:50:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55DDAB1C.90406@gmail.com>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu>
	<55DDAB1C.90406@gmail.com>
Date: Fri, 28 Aug 2015 10:50:12 +0200
Message-ID: <CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
Subject: Re: Understanding BTRFS storage
From: George Duffield <forumscollective@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running a traditional raid5 array of that size is statistically
guaranteed to fail in the event of a rebuild. I also need to expand
the size of available storage to accomodate future storage
requirements. My understanding is that a Btrfs array is easily
expanded without the overhead associated with expanding a traditional
array.  Add to that the ability to throw varying drive sizes at the
problem and a Btrfs RAID array looks pretty appealing.

For clarity, my intention is to create a Btrfs array using new drives,
not to convert the existing ext4 raid5 array.

On Wed, Aug 26, 2015 at 2:03 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-08-26 07:50, Roman Mamedov wrote:
>>
>> On Wed, 26 Aug 2015 10:56:03 +0200
>> George Duffield <forumscollective@gmail.com> wrote:
>>
>>> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
>>> solution that will involve duplicating a data store on a second
>>> machine for backup purposes (the machine is only powered up for
>>> backups).
>>
>>
>> What do you want to achieve by switching? As Btrfs RAID5/6 is not safe
>> yet, do
>> you also plan to migrate to RAID10, losing in storage efficiency?
>>
>> Why not use Btrfs in single-device mode on top of your mdadm RAID5/6? Can
>> even
>> migrate without moving any data if you currently use Ext4, as it can be
>> converted to Btrfs in-place.
>>
> As of right now, btrfs-convert does not work reliably or safely.  I would
> strongly advise against using it unless you are trying to help get it
> working again.
>
