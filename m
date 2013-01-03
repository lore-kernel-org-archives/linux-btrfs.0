Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:33845 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3ACTLu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 14:11:50 -0500
Date: 03 Jan 2013 20:08:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8j2OqeCXB@helmut.hullen.de>
In-Reply-To: <20130103183341.GC19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

>>>> But for what purpose offers "mkfs.btrfs" this option?

>>>    So that you don't have to run the label command immediately
>>>    after making the filesystem.


>> But other filesystems don't put the label onto more than 1 device.
>> There's the problem for/with btrfs.

>    Aargh. How many times do I have to say this?

>    Devices are not given labels.
>    *Filesystems* are given labels.

And "mkfs.btrfs" combines working with devices and working with a  
filesystem.

        blkid /dev/sdb

shows (if set) the label of a device (among other data).

>> The label has to be unique for the whole machine.

>    Wrong. You can have several filesystems on a machine with the same
> label.

On my machines that doesn't work when I use programs like "blkid" or  
"findfs". They don't work when there is more than 1 device with the same  
label. That's no special btrfs problem, that happens with (p.e.) ext4fs  
too.

> It doesn't mean that they're easily managable, but there's
> nothing that will stop it from happening.

>    If you want a unique label for a *device*, take a look at the
> symlinks in /dev/disk/by-id, and the udev rules that generate them.

Sorry - I don't use "udev" (I've told it long time ago). And I still  
believe that "btrfs" doesn't depend on "udev".

> Trying to use filesystem labels to give unique and stable device IDs
> is the wrong tool for the job.

I beg to differ. On my machines it's the simpliest way, and it's a sure  
way.

[...]


>    As I said above, you're expecting something which just isn't true.
> Filesystems have labels, not devices. If you want to have unique
> labels on devices, then you're going to have to write some udev rules
> to generate them for you, and then refer to /dev/helmuts-devices/foo
> (or whatever you want to call them).

And how is the way for a system which doesn't use "udev"?
Labelling via "btrfs filesystem label <device> <label>" works well.

Viele Gruesse!
Helmut
