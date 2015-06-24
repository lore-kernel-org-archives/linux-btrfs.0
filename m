Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from h218.18.88.75.static.ip.windstream.net ([75.88.18.218]:34308
	"EHLO suse102.ad.techspace.cc" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753240AbbFXReT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 13:34:19 -0400
Received: from esilinux2.ad.techspace.cc (esilinux2.ad.techspace.cc [192.168.10.56])
	(authenticated bits=0)
	by suse102.ad.techspace.cc (8.14.9/8.14.4/SuSE Linux 0.8) with ESMTP id t5OHXvk4025348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 12:33:57 -0500
Reply-To: moby@mobsternet.com
Subject: Re: BTRFS balance fails with -dusage=100
References: <5588D855.2080701@mobsternet.com>
To: linux-btrfs@vger.kernel.org
From: Moby <moby@mobsternet.com>
Message-ID: <558AEA05.2070901@mobsternet.com>
Date: Wed, 24 Jun 2015 12:33:57 -0500
MIME-Version: 1.0
In-Reply-To: <5588D855.2080701@mobsternet.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/22/2015 10:53 PM, Moby wrote:
> OpenSuSE 13.2 system with single BTRFS / mounted on top of /dev/md1. 
> /dev/md1 is md raid5 across 4 SATA disks.
>
> System details are:
>
> Linux suse132 4.0.5-4.g56152db-default #1 SMP Thu Jun 18 15:11:06 UTC 
> 2015 (56152db) x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs-progs v4.1+20150622
>
> Label: none  uuid: 33b98d97-606b-4968-a266-24a48a9fe50d
>     Total devices 1 FS bytes used 884.21GiB
>     devid    1 size 1.36TiB used 889.06GiB path /dev/md1
>
>
> Data, single: total=885.00GiB, used=883.12GiB
> System, DUP: total=32.00MiB, used=144.00KiB
> Metadata, DUP: total=2.00GiB, used=1.09GiB
> GlobalReserve, single: total=384.00MiB, used=0.00B
>
>
> Relevant entries from log are:
> 2015-06-22T22:46:32.238011-05:00 suse132 kernel: [90193.446128] BTRFS: 
> bdev /dev/md1 errs: wr 9977, rd 0, flush 0, corrupt 0, gen 0
> 2015-06-22T22:46:32.238050-05:00 suse132 kernel: [90193.446158] BTRFS: 
> bdev /dev/md1 errs: wr 9978, rd 0, flush 0, corrupt 0, gen 0
> 2015-06-22T22:46:32.238054-05:00 suse132 kernel: [90193.446179] BTRFS: 
> bdev /dev/md1 errs: wr 9979, rd 0, flush 0, corrupt 0, gen 0
>
> System was (still is - other than btrfs balance) running fine. Then I 
> did massive data I/O, copying and deleting and massive amounts of data 
> to bring the system into it's present state.  Once I was done with the 
> I/O, kicked off btrfs balance start /.
> Above command failed.  Then I started doing btrfs balance -dusage=XX /
> This command succeeds  with XX upto and including 99.  It fails when I 
> set XX to 100.  btrfs balance also fails if I omit the -dusage option.
> The errors in the log make no sense to me since the md raid device is 
> not reporting any errors at all.  Also running btrfs scrub reports no 
> errors at all.
>
> Any ideas on how to get btrfs balance to succeed without errors would 
> be welcome.
>
> Regards,
>
> --Moby
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>
>

On another run with -duage=95, I am now seeing the following (negative 
percentage left value!)

Every 15.0s: sh -c date;btrfs balance status -v /       Wed Jun 24 
12:29:12 2015

Wed Jun 24 12:29:12 CDT 2015
Balance on '/' is running
306 out of about 145 chunks balanced (312 considered), -111% left
Dumping filters: flags 0x1, state 0x1, force is off
   DATA (flags 0x2): balancing, usage=95

--Moby
