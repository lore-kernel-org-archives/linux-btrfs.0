Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55449 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3ACRnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 12:43:52 -0500
Received: by mail-vc0-f176.google.com with SMTP id fo13so15510921vcb.21
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2013 09:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130103170151.GB19051@carfax.org.uk>
References: <20130103160853.GA19051@carfax.org.uk>
	<CO8i$PzPCXB@helmut.hullen.de>
	<20130103170151.GB19051@carfax.org.uk>
Date: Thu, 3 Jan 2013 09:43:51 -0800
Message-ID: <CAPkEcwgKXmgaEWt0iWPGJ5CkAVmfQKZFc54d7m3tgm4viZ8Lfg@mail.gmail.com>
Subject: Re: Option LABEL
From: james northrup <northrup.james@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, helmut@hullen.de,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

common labels work for me on my 3 way raid volumes.  there's been no problem.

what might be a problem is when i do mount LABEL=foo, btrfs dev scan
is not automatic on failure.

On Thu, Jan 3, 2013 at 9:01 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jan 03, 2013 at 05:29:00PM +0100, Helmut Hullen wrote:
>> Hallo, Hugo,
>>
>> Du meintest am 03.01.13:
>>
>> >> please delete the option "-L" (for labelling) in "mkfs.btrfs", in
>> >> some configurations it doesn't work as expected.
>> >>
>> >> My usual way:
>> >>
>> >>         mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd ...
>> >>
>> >> One call for some devices.
>> >> Wenn I add the option "-L mylabel" then each device gets the same
>> >> label, and therefore some other programs can't find the (one) device
>> >> with the defined label.
>>
>> >    I'm sure we've been over this territory before. Devices are not
>> > labelled; filesystems are labelled. You are labelling the whole
>> > filesystem, which exists over several devices, so the same label will
>> > be attached to every device in the filesystem.
>>
>> But for what purpose offers "mkfs.btrfs" this option?
>
>    So that you don't have to run the label command immediately after
> making the filesystem. Most mkfs implementations for different
> filesystems have something similar, usually with the -L option.
>
>> >> Especially
>> >>
>> >>      blkid
>> >>      findfs LABEL=mylabel
>> >>
>> >> don't work.
>>
>> >    How do you mean, "don't work"? What are they showing, and what do
>> > you think should they be showing?
>>
>> Without this double-labelled (?) devices "blkid" shows all devices with
>
>    "Double-labelled"? The filesystem has one label, belonging to the
> filesystem. I don't see where the "double-labelling" comes in.
>
>> (if defined) their labels. When I define the same label for more than 1
>> device (btrfs or ext2fs or ...) then "blkid" shows nothing. No output
>> for any of the devices.
>
>    This is a fault in the version of blkid you're running, then.
> There's nothing to stop me from labelling two ext2 filesystems with
> the same label. If blkid can't handle that, then it's got problems
> beyond btrfs. On my main machine, it seems to work correctly:
>
> $ sudo blkid
> /dev/sda: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="5fd56eec-5e26-4c1f-a02a-f86550e4aefe" TYPE="btrfs"
> /dev/sdc: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="4e392bea-f39a-4cba-b78c-c712479bf3f0" TYPE="btrfs"
> /dev/sde: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="5e2555bd-bf36-430b-af5a-aa81604afc96" TYPE="btrfs"
> /dev/sdp: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="404d13f5-0231-46db-a311-ad7a4f99eef3" TYPE="btrfs"
> /dev/sdr: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="90469059-f012-4b6e-9233-8c591cbeaa80" TYPE="btrfs"
> /dev/sdq: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="646d3d32-5193-4fcd-afb2-43f14122a149" TYPE="btrfs"
> /dev/sds: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35" UUID_SUB="f4d4dbb2-f2bb-4e54-bbf9-4bb5474e9ef1" TYPE="btrfs"
>
>    My blkid version:
>
> blkid from util-linux 2.20.1 (libblkid 2.20.0, 19-Oct-2011)
>
>> "findfs": with double-labelled devices "findfs" doesn't find any label.
>
>    On my system, the filesystem with label "media" exists on
> /dev/sd{a,b,c,e,p,q,r,s}:
>
> $ sudo blkid -L media
> /dev/sdb
> $ sudo findfs LABEL=media
> /dev/sdb
>
>    In each case, it's giving me the path of a block device node which
> I can use to mount the filesystem. As far as I know, this is the
> correct and expected behaviour.
>
>> > It looks like both of them print an
>> > arbitrary device node of the devices that the FS lives on. Given that
>> > both of these tools probably expect a one-to-one relationship between
>> > a block device and a filesystem, this is not unreasonable.
>>
>> May be that "this is not unreasonable". But when "mkfs.btrfs" offers the
>> "label" option I don't expect this behaviour.
>
>    You're running mkfs. Why would you expect running mkfs *not* to
> make a new filesystem? This is the behaviour on all other mkfses.
>
>    From the man page:
>
> DESCRIPTION
>        mkfs.btrfs is used to create a btrfs filesystem (usually in a disk par‐
>        tition,  or  an  array of disk partitions).  device is the special file
>        corresponding to the device (e.g /dev/sdXX  ).   If  multiple   devices
>        are specified, btrfs is created spanning across the specified  devices.
>
> i.e. it's a tool to create a filesystem.
>
>> I had mentioned this problem more than a year ago, it still exists.
>
>    It's not a problem. Everything is working as expected and as
> designed.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>             --- You're never alone with a rubber duck... ---
