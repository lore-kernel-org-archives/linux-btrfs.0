Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43516 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2FDPBV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 11:01:21 -0400
Received: by vcbf11 with SMTP id f11so2495012vcb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 08:01:21 -0700 (PDT)
Message-ID: <4FCCCDBF.9080309@gmail.com>
Date: Mon, 04 Jun 2012 11:01:19 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Help with recover data
References: <4FC54A5D.8000600@gmail.com> <4FCCA8E3.7080209@giantdisaster.de> <4FCCA983.50400@gmail.com> <4FCCB20A.7010300@giantdisaster.de> <4FCCC176.1020007@gmail.com>
In-Reply-To: <4FCCC176.1020007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After looking on Kernel.log, looks like I had raid card failure and data 
was not stored properly on one of disks (/dev/sde).
Btrfs didn't recognized disk failure and keep trying to write data until 
reboot.

Some other tests after reboot shows that /dev/sde has generation 9095 
and other 4 disks have 9096.

This case shows that btrfs does not recognize and does not handle such 
errors. It probably need to be included as RAID cards can fail....

But more important, that btrfs cannot recover automatically when one 
disk lost some data.

The next question how to roll back to generation 9095?

On 06/04/2012 10:08 AM, Maxim Mikheev wrote:
> Disks were connected to RocketRaid 2760 directly as JBOD.
>
> There is no LVM, MD or encryption. I used plain disks directly.
>
> The file system was 55% full (1.7TB from 3TB for each disk).
>
> Logs are attached.
> The error happens at May 29, 13:55.
>
> Log contain errors on May 27 for ZFS, It is why I decided to switch to 
> btrfs. On the moment of failure, no ZFS was installed in the system.
>
>
> On 06/04/2012 09:03 AM, Stefan Behrens wrote:
>> On Mon, 04 Jun 2012 08:26:43 -0400, Maxim Mikheev wrote:
>>> It was a kernel panic from btrfs.
>>> I had around 40 parallel processes of reading/writing.
>> Do you have a stack trace for this kernel panic, something with the term
>> "BUG", "WARNING" and/or "Call Trace" in /var/log/kern.log or
>> /var/log/syslog (or in the old /var/log/syslog.?.gz 
>> /var/log/kern.log.?.gz)?
>>
>> And are the disks connected via USB or how?
>>
>> Is there an MD, LVM or encryption layer below btrfs in your setup?
>>
>> Was the filesystem almost full?
