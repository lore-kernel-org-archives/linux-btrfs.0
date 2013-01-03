Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout02.t-online.de ([194.25.134.17]:46840 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3ACUgF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 15:36:05 -0500
Date: 03 Jan 2013 21:18:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8jDv4uCXB@helmut.hullen.de>
In-Reply-To: <20130103192848.GD19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

[...]

>>> Trying to use filesystem labels to give unique and stable device
>>> IDs is the wrong tool for the job.

>> I beg to differ. On my machines it's the simpliest way, and it's a
>> sure way.

>    No, because *it* *doesn't* *work*. This is not a bug. This is how
> things have always behaved -- you're relying on an assumption (one FS
> per device) which simply isn't true any longer.

No - I don't rely on such an assumption.
In the special case I'm just working with I want to use the whole disk  
only for btrfs.

In other cases I work with partitions, and there is just the same  
problem: at least "blkid" and "findfs" don't work when more than 1  
device has the same label (p.e. /dev/sda3 and /dev/sdc5).

>> And how is the way for a system which doesn't use "udev"?

>    There isn't one ready-made. Your options are:

>  * run udev

>  * write something which uses (e.g.) SMART information on block
>    devices to extract a unique ID, and convert that into a stable
>    device label (which is effectively what udev does)

Sorry - I don't need the "unique ID" for the machines. I can use (p.e.)

        e2label /dev/sda3 Var

for labelling an ext2/3/4 partition. Works like a charm, especially for  
USB disks.

>  * find some piece of the device which isn't going to be overwritten
>    by partition tables, GPTs, filesystems, or other kinds of
> metadata,    and write your label into there; again, you will need to
> develop    your own tool for reading/writing this information

Sorry - that's not necessary. When I connect the disk then I can search  
with "findfs" without having mounted any partition.

>> Labelling via "btrfs filesystem label <device> <label>" works well.

>    Clearly it doesn't, because you're having problems with it.

No - not at all!
I've only problems when I use the "-L" option of "mkfs.btrfs" together  
with more than 1 device in the "mkfs.btrfs" command.


>    The
> behaviour where only one device in the FS gets the label, immediately
> after a btrfs label command, is a bug -- *all* of the devices in the
> FS should get the label. You're trying to rely on the behaviour of a
> bug, not on the designed behaviour of the system.

What works:

Building the filesystem with "mkfs.btrfs", without the "-L" option

Then (p.e.)

        btrfs filesystem label <device> <label>

(unmounted system)

Then I can check the existence (not only for btrfs formatted disks) with

        findfs LABEL=<label> && mount LABEL=<label> <mountpoint>

As mentioned: works not only with btrfs, works fine especially for USB  
disks. I don't need any UUID etc. for this way of identyfying. I don't  
need to change the mount directive when I change a smaller disk to a  
bigger disk.

Viele Gruesse!
Helmut
