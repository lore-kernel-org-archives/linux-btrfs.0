Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:52415 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3LMT0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 14:26:39 -0500
Received: by mail-yh0-f49.google.com with SMTP id z20so1858352yhz.36
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 11:26:38 -0800 (PST)
Received: from [192.168.18.6] (cpe-174-106-200-117.ec.res.rr.com. [174.106.200.117])
        by mx.google.com with ESMTPSA id w45sm4657525yhk.4.2013.12.13.11.26.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 13 Dec 2013 11:26:37 -0800 (PST)
Message-ID: <52AB5F2E.8020209@czarc.net>
Date: Fri, 13 Dec 2013 14:25:34 -0500
From: Gene Czarcinski <gczarcinski@gmail.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: moving a subvol
References: <52AB30D4.7050408@czarc.net> <52AB3673.1030607@czarc.net> <27814825-5AD6-4AA3-A286-D258D62CAB0C@colorremedies.com> <CAGvEgFHg-wO4BM9imQA9EpkMSLaEREchb9LBKXHkfFUPWwbfzQ@mail.gmail.com> <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com>
In-Reply-To: <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2013 01:02 PM, Chris Murphy wrote:
>
> On Dec 13, 2013, at 10:37 AM, Cobin Bluth <cbluth@gmail.com> wrote:
>> That seems a little less intuitive than one would think. I wonder if there would an argument to specify read-write for btrfs-receive.
>
> I'm going to guess it's on purpose to prevent writes from happening in the subvolume while it's still being received. The send file is a stream so my interpretation of what's going on is that subvolume's file system isn't really in a state to be modified until it's completely done being written. And for that matter, it's the same thing with sending. The wiki says send requires subvolumes to be ro, and all of the examples there are ro subvolumes.
>
> I don't know that this is an apt analogy, but think of dd'ing a partition that contains a live mounted volume. Oops - not a good idea right? Because as you dd the first part, the uncopied portion is being modified and is now inconsistent.
>
>
Seems to have worked fine.  What more could I ask for.

With Fedora 20 a go for gold, I decided to update to Fedora 20 on almost 
all of my systems.  At the same time I decided to do some consolidation 
and restructuring of my disk layouts to put almost all of it under some 
BTRFS volumes.

I really did not want to install Fedora 19 again and just want to move 
the F19 rootfs from one volume to a newer other volume.  It required 
some editing of /etc/fstab to use the  new UUIDs and also some manual 
editing (ugh) of grub.cfg so that it had the correct UUIDs for the 
volume with subvol=root4.

Next it is to delete the old BTRFS volume, use fdisk to increase the 
size of the partition and then attempt to increate the size of this new 
volume.  I hope I don't get bit in the rear end with this.

Gene

