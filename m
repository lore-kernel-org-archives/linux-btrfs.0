Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from server1.design-company.com.au ([103.18.108.111]:44502 "EHLO
	server1.design-company.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbbGOGxw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 02:53:52 -0400
Received: from ful1143003.lnk.telstra.net ([110.143.62.99]:57855 helo=hostd49a20ff8a0a.local)
	by server1.design-company.com.au with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.85)
	(envelope-from <hub@spotprint.com.au>)
	id 1ZFGZg-0008CH-PW
	for linux-btrfs@vger.kernel.org; Wed, 15 Jul 2015 16:53:48 +1000
Message-ID: <55A60368.8000401@spotprint.com.au>
Date: Wed, 15 Jul 2015 16:53:28 +1000
From: Ryan Bourne <hub@spotprint.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
References: <55A5B13C.6060009@spotprint.com.au>
In-Reply-To: <55A5B13C.6060009@spotprint.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 14/07/15 11:25 PM, Austin S Hemmelgarn wrote:
> On 2015-07-14 07:49, Austin S Hemmelgarn wrote:
>> So, after experiencing this same issue multiple times (on almost a
>> dozen different kernel versions since 4.0) and ruling out the
>> possibility of it being caused by my hardware (or at least, the RAM,
>> SATA controller and disk drives themselves), I've decided to report it
>> here.
>>
>> The general symptom is that raid6 profile filesystems that I have are
>> working fine for multiple weeks, until I either reboot or otherwise
>> try to remount them, at which point the system refuses to mount them.

>>
> Further updates, I just tried mounting the filesystem from the image
> above again, this time passing device= options for each device in the
> FS, and it seems to be working fine now.  I've tried this with the other
> filesystems however, and they still won't mount.
>

I have experienced a similar problem on a raid1 with kernels from 3.17
onward following a kernel panic.

I have found that passing the other device as the main device to mount
will often work.
E.g.

# mount -o device=/dev/sdb,device=/dev/sdc /dev/sdb /mountpoint
open_ctree failed

# mount -o device=/dev/sdb,device=/dev/sdc /dev/sdc /mountpoint
mounts correctly.

If I then do an immediate umount and try again I get the same thing, but
after some time using the filesystem, I can umount and either device is
working for the mount again.




