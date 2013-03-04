Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57355 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3CDPId (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 10:08:33 -0500
Received: by mail-lb0-f178.google.com with SMTP id n1so4021854lba.37
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2013 07:08:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130304143956.GA3822@shiny.masoncoding.com>
References: <CAPsrAuCGwDCuWJ-NUt8vZGOgav779=KaF+32kf4A1bW7pZSF5g@mail.gmail.com>
	<CAPsrAuCk52oLpxyOfs8VyjKAoFZ3f8JqADRm=TVFuP4AWPkEHw@mail.gmail.com>
	<CAPsrAuCMLi2m-3_vSE+FZLwMEDRhHDLoM0qnJAw0tYgcqsr=Og@mail.gmail.com>
	<20130304143956.GA3822@shiny.masoncoding.com>
Date: Mon, 4 Mar 2013 16:08:29 +0100
Message-ID: <CAPsrAuCiQkN_GyhQH1qswjftvbZ7CG-cW+fefPO6HMY5N4K5mQ@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_map.c:78 free_extent_map+0x6e/0x90
 [btrfs]() [linux 3.8.0]
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: Chris Mason <chris.mason@fusionio.com>,
        Joeri Vanthienen <mail@joerivanthienen.be>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Same problem without enhanceIO.
Wiped all the disks, created new raid10 fs with 4 sas disks.
Sparse file mapped over iscsi with SCST and iometer at the other side
running some workload.
After some seconds, minutes several CPU stuck messages and the same
messages as posted before in /var/log/messages

Message from syslogd@linux-testsan at Mar  4 15:08:33 ...
 kernel:[ 1664.104007] BUG: soft lockup - CPU#0 stuck for 22s! [disk010_5:2769]

Message from syslogd@linux-testsan at Mar  4 15:09:01 ...
 kernel:[ 1692.104010] BUG: soft lockup - CPU#0 stuck for 22s! [disk010_5:2769]

This time after the reboot I could access the filesystem again.
Just the following message: "btrfs: truncated 1 orphans"

linux-testsan:~ # btrfs scrub status /btrfs/
scrub status for 3dce380a-d9dc-453b-97bb-e653c53c610f
        scrub started at Mon Mar  4 15:52:31 2013 and finished after 8 seconds
        total bytes scrubbed: 3.42GB with 0 errors

One of the disks in the raid10 set, seems to have very high w_await
times in iostat. So maybe there is an issue with this disk...
If you need some more information, let me know. Thanks in advance.


On Mon, Mar 4, 2013 at 3:39 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Mon, Mar 04, 2013 at 07:06:05AM -0700, Joeri Vanthienen wrote:
>> Some more maybe usefull information. After reboot, the btrfs raid10
>> filesystem is unmountable.
>> I'm now running the test without enhanceIO from IO.
>>
>> linux-testsan:~ #btrfs device scan --all-devices
>> [  881.520686] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
>> 2 transid 10 /dev/sdd
>> [  881.522907] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
>> 1 transid 14 /dev/sdc
>> [  901.949559] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
>> 4 transid 14 /dev/sdf
>> [  901.949962] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
>> 3 transid 14 /dev/sde
>> [  901.950367] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
>> 2 transid 10 /dev/sdd
>> [  901.952572] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
>> 1 transid 14 /dev/sdc
>> linux-testsan:~ # btrfsck /dev/sde
>> Check tree block failed, want=858902528, have=858836992
>
> This is telling us the device returned the wrong block.  It could be
> because the device really read from the wrong place, or perhaps it is
> because the correct block was never written.
>
> Please let us know if you're still seeing this without enhanceIO
> involved.  I haven't tried enhanceIO yet, so I'm not sure how well it
> supports btrfs.
>
> -chris
