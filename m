Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:47263 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3ACSDp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 13:03:45 -0500
Date: 03 Jan 2013 18:57:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8ipTEeCXB@helmut.hullen.de>
In-Reply-To: <20130103170151.GB19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

>> But for what purpose offers "mkfs.btrfs" this option?

>    So that you don't have to run the label command immediately after
> making the filesystem. Most mkfs implementations for different
> filesystems have something similar, usually with the -L option.

But other filesystems don't put the label onto more than 1 device.  
There's the problem for/with btrfs.

The label has to be unique for the whole machine.

>> Without this double-labelled (?) devices "blkid" shows all devices
>> with

>    "Double-labelled"? The filesystem has one label, belonging to the
> filesystem. I don't see where the "double-labelling" comes in.

As I described:

    mkfs.btrfs -d raid0 -m raid1 -l mylabel /dev/sdb /dev/sdc /dev/sdd

labels all three devices with the same name, and then programs like  
"blkid" or "findfs" don't find any label (for all labelled devices, not  
only for btrfs devices).

And as I have written before:

        file -s /dev/sdb
        file -s /dev/sdc
        file -s /dev/sdd

shows for each of these devices the same label.

--------------

When I run

      mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd

and then

      btrfs filesystem label /dev/sdb mylabel

then only "/dev/sdb" shows this label (as long as none of the 3 devices  
is mounted).

When I then run

      mount LABEL=mylabel /mnt/btr

then all works fine. And then (after mounting)

      blkid /dev/sdb
      blkid /dev/sdc
      blkid /dev/sdd

show the same label.

      blkid

without any device seems to hang - may be I haven't waited long enough.



>> (if defined) their labels. When I define the same label for more
>> than 1 device (btrfs or ext2fs or ...) then "blkid" shows nothing.
>> No output for any of the devices.

>    This is a fault in the version of blkid you're running, then.

here: "blkid from until-linux 2.21.2 (libblkid 2.21.0, 25-May-2012)".  
And older versions.

> There's nothing to stop me from labelling two ext2 filesystems with
> the same label.

That part is right: I can label more than 1 device with the same name,  
not only under btrfs.

But then  (I had written this problem) programs like "blkid" don't find  
any labelled device.


> If blkid can't handle that, then it's got problems
> beyond btrfs. On my main machine, it seems to work correctly:

> $ sudo blkid
> /dev/sda: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="5fd56eec-5e26-4c1f-a02a-f86550e4aefe" TYPE="btrfs"
> /dev/sdc: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="4e392bea-f39a-4cba-b78c-c712479bf3f0" TYPE="btrfs"
> /dev/sde: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="5e2555bd-bf36-430b-af5a-aa81604afc96" TYPE="btrfs"
> /dev/sdp: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="404d13f5-0231-46db-a311-ad7a4f99eef3" TYPE="btrfs"
> /dev/sdr: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="90469059-f012-4b6e-9233-8c591cbeaa80" TYPE="btrfs"
> /dev/sdq: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="646d3d32-5193-4fcd-afb2-43f14122a149" TYPE="btrfs"
> /dev/sds: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> UUID_SUB="f4d4dbb2-f2bb-4e54-bbf9-4bb5474e9ef1" TYPE="btrfs"

Is "media" mounted?

>    My blkid version:

> blkid from util-linux 2.20.1 (libblkid 2.20.0, 19-Oct-2011)

It's older than my actual version, but I had found this problem more  
than a year ago.

Viele Gruesse!
Helmut
