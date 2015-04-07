Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:32894 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbbDGPAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 11:00:39 -0400
Received: by ignm3 with SMTP id m3so11007852ign.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 08:00:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
Date: Tue, 7 Apr 2015 09:00:36 -0600
Message-ID: <CAJCQCtQMQJgL2U4X59XJV3X_W6x-mpsO8eXiutQkPXp59R-Tbw@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: Chris Murphy <lists@colorremedies.com>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 4:58 AM, arnaud gaboury <arnaud.gaboury@gmail.com> wrote:
> On Tue, Apr 7, 2015 at 11:57 AM, arnaud gaboury
> <arnaud.gaboury@gmail.com> wrote:
>>
>> I plan to install my OS on a btrfs partition, with some subvolumes.
>> Once the partition has been btrfs formated, I mounted it somewhere, cd
>> and then run <btrfs subvolume create>.
>>
>> I did these two subvolumes for now:
>> # btrfs subvolume list .
>> ID 256 gen 6 top level 5 path var
>> ID 257 gen 7 top level 5 path home
>>
>> Now I am wondering if I need to create the root filesystem partition
>> (/)? If yes, is this correct:
>> # btrfs subvolume create root
>
>
> After more reading, it seems to me creating a top root subvolume is
> the right thing to do:
> # btrfs subvolume create root
> # btrfs subvolume create root/var
> # btrfs subvolume create root/home
>
> Am I right?

It will work. It's not a matter of right or wrong though. If you
intend to snapshot or rollback, I think it's easier to put all
subvolumes at the top level, and then use fstab with the subvol= or
subvolid= mount option to assemble them in the locations you want.
That way it's easier to keep all the snapshots in the top level, and
selectively do rollbacks. If you nest the subvolumes, it gets tricky.
But if you don't plan to do much snapshotting or rollbacks, it's fine
to nest.


-- 
Chris Murphy
