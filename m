Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:59840 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438Ab3ALGUX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 01:20:23 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: obscure out of space, df and fi df are way off
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvjGwnrYJUQJ97xuCm__hAE18cfLx8r5_NutFkA6dzONcQ@mail.gmail.com>
Date: Fri, 11 Jan 2013 23:20:21 -0700
Message-Id: <E3B2C3E3-7A06-4C19-AA66-5AFC3FC7D2C3@colorremedies.com>
References: <A2AC222E-2F40-4B0A-BFA7-C9D2D3A5B193@colorremedies.com> <CAE5mzvjGwnrYJUQJ97xuCm__hAE18cfLx8r5_NutFkA6dzONcQ@mail.gmail.com>
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>,
        cwillu <cwillu@cwillu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2013, at 11:04 PM, cwillu <cwillu@cwillu.com> wrote:

> On Fri, Jan 11, 2013 at 11:50 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> Very low priority.
>> No user data at risk.
>> 8GB virtual disk being installed to, and the installer is puking. I'm trying to figure out why.
>> 
>> I first get an rsync error 12, followed by the installer crashing. What's interesting is this, deleting irrelevant source file systems, just showing the mounts for the installed system:
>> 
>> [root@localhost tmp]# df
>> Filesystem                 1K-blocks    Used Available Use% Mounted on
>> /dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage
>> /dev/sda1                     495844   31509    438735   7% /mnt/sysimage/boot
>> /dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage/home
>> 
>> So there's 1.5M of free space left according to conventional df. However:
>> 
>> [root@localhost tmp]# btrfs fi show
>> Label: 'fedora_f18v'  uuid: 0c9b2b62-5ec1-4610-ab2f-9f00c909428a
>>        Total devices 1 FS bytes used 2.87GB
>>        devid    1 size 3.57GB used 3.57GB path /dev/sda3
>> 
>> [root@localhost tmp]# btrfs fi df /mnt/sysimage
>> Data: total=2.69GB, used=2.69GB
>> System, DUP: total=8.00MB, used=4.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=438.94MB, used=183.36MB
>> Metadata: total=8.00MB, used=0.00
>> 
>> And absolutely nothing in dmesg.
>> 
>> This is confusing. fi show says 3.57GB available and used. Whereas fi df says 2.69 available and used. So is it 3.57GB? Or is it 2.69? I suppose the simple answer is, it doesn't matter, in either case it's full. But it seems like the installer is underestimating Btrfs requirements and should be more conservative, somehow so I'd like to better understand the allocation.
> 
> There reporting is correct, but a bit obscure.  We have a FAQ item on
> how to read the output on the wiki, but it's a known sore spot.
> 
> btrfs fi show reports 3.57GB allocated to block groups (so everything
> is assigned to metadata or data); btrfs fi df reports how that 3.57GB
> is being used: of 2.69GB allocated to data block groups, 2.69GB (i.e.,
> all of it) is in use by file data; of 438.94MB of metadata (or 0.87GB
> after DUP), 183.36MB is in use by metadata (which may include small
> files that have been inlined).

So if I assume 2.7GiB for data, and add up the left side of fi df I get 3224MB rounded up, which is neither 3.57GB or 3.57GiB. I'm missing 346MB at least. That is what I should have said from the outset.

So is the Metadta DUP Total 438.94MB allocated value actually twice that, but only 438.94MB is displayed because that's what's available (since the metadata is duplicated)?

> 
> In other words, the tools are saying that filesystem is basically full. :)

Right yes, very clear!


> 
> Note that the -M option to mkfs.btrfs is intended for this use-case:
> filesystems where the size of a block allocation is large compared to
> the size of the filesystem.  It should let you squeeze out most of the
> rest of that 400MB (200MB, DUP).

Is there a simple rule of thumb an installer could use to know when to use -M? I know mkfs.btrfs will do this for smaller filesystems than this. I'm thinking this is a testing edge case that a desktop installer shouldn't be concerned about, but rather should just gracefully fail from, or better yet, insist on a larger install destination than this in particular when Btrfs.


Chris Murphy

