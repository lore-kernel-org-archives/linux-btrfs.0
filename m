Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:41357 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285AbaKSB3Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 20:29:16 -0500
Message-ID: <546BF268.5050706@pobox.com>
Date: Tue, 18 Nov 2014 17:29:12 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com>
In-Reply-To: <546B68F8.6080008@ubuntu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2014 07:42 AM, Phillip Susi wrote:

> On 11/18/2014 1:16 AM, Chris Murphy wrote:
>> (stuff about UUIDs and LVM snapshots).
 > (suggestion to use LVM paths instead).

This is also an XFS+LVM+LVM_Snapshot problem going back to at least 
2009. It's inherent to the block-device-level snapshot phenomonia.

q.v. http://www.miljan.org/main/2009/11/16/lvm-snapshots-and-xfs/ et al

In XFS you attack the snapshot with a command to regenerate the UUID as 
soon as you take the snapshot. I don't think there is a "regenerate all 
my UUIDs" command for BTRFS.

There are other places this can bone you, like old-format mdadm mirrors, 
where the metadata was only at the end of the partition so you could 
accidentally see two copied of your RAID1 file system if you hand't 
built/started the array.

There is no really good way to prevent this other than "being really 
careful" or "not doing that at all".

Sorry. Cost of doing business. Cheers...
Rob.
