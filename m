Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60006 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaJNPFJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 11:05:09 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so10426187wid.6
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 08:05:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_nK5w+7Z70+5WMou-Z7HCVPaebFcPzOSKhGO8_=YN1oEQ@mail.gmail.com>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com>
	<543B372F.10509@oracle.com>
	<CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com>
	<543C86C3.7040804@oracle.com>
	<CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
	<CAGfcS_nK5w+7Z70+5WMou-Z7HCVPaebFcPzOSKhGO8_=YN1oEQ@mail.gmail.com>
Date: Tue, 14 Oct 2014 08:05:07 -0700
Message-ID: <CAPF83mtNzPcmWBpriy-n78ZHGj_Krkqaf3mNtk0Uf-qrAJzZxA@mail.gmail.com>
Subject: Re: what is the best way to monitor raid1 drive failures?
From: Suman C <schakrava@gmail.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I cannot delete that way because it would mean going below the minimum
number of devices and it fails, as explained in the wiki.

The solution from wiki is to add a new device and then delete the old
one, but the problem here may be due to the new device appearing with
the same name(sdb)?

Suman

On Tue, Oct 14, 2014 at 7:52 AM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Tue, Oct 14, 2014 at 10:48 AM, Suman C <schakrava@gmail.com> wrote:
>>
>> The new drive shows up as sdb. btrfs fi show still prints drive missing.
>>
>> mounted the filesystem with ro,degraded
>>
>> tried adding the "new" sdb drive which results in the following error.
>> (-f because the new drive has a fs from past)
>>
>> # btrfs device add -f /dev/sdb /mnt2/raid1pool
>> /dev/sdb is mounted
>>
>> Unless I am missing something, this looks like a bug.
>>
>
> You need to first run btrfs device delete missing /mnt2/raid1pool I
> believe (missing is a keyword for a missing device in the array - if
> the device were still present you could specify it by /dev/sdX).
>
> --
> Rich
