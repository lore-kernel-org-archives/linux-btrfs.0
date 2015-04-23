Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33817 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbbDWL52 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 07:57:28 -0400
Received: by qkgx75 with SMTP id x75so8530517qkg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 04:57:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150423115056.GA28566@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
	<20150423115056.GA28566@gardel-login>
Date: Thu, 23 Apr 2015 14:57:27 +0300
Message-ID: <CAA91j0U9Vt9EPtje-o0oFrc=jYpXVeS_rOLORX1Th9xu9XVqKg@mail.gmail.com>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: arnaud gaboury <arnaud.gaboury@gmail.com>,
        systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 2:50 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Thu, 23.04.15 13:45, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:
>
>> Not sure what I did wrong, but I can't install/boot my nspawn container.
>> Here is my setup:
>>
>> Archlinux box- updated
>>
>> 1- created 3 btrfs subvol on /dev/sdb1 (SSD). The goal is to manage
>> snapshots easily.
>> no nested subvol.
>> ------------------------------------------
>> # btrfs subvolume list .
>> ID 266 gen 39 top level 5 path rootvol
>> ID 268 gen 41 top level 5 path var
>> ID 269 gen 42 top level 5 path etc
>> # btrfs filesystem show
>> Label: 'poppy-root'  uuid: ef1b44cd-e7b0-4166-b933-e7d4d20a1171
>>     Total devices 1 FS bytes used 64.00KiB
>>     devid    1 size 80.00GiB used 12.00MiB path /dev/sdb1
>> --------------------------------------------------
>>
>> 2 - mount btrfs subvol
>> -------------------------------------------------------------------
>> # mount -t btrfs -o subvol=rootvol /dev/sdb1 /var/lib/machines/enl
>> # mkdir /var/lib/machines/enl/var
>> # mkdir /var/lib/machines/enl/etc
>> # mount -t btrfs -o subvol=etc /dev/sdb1 /var/lib/machines/enl/etc
>> # mount -t btrfs -o subvol=var /dev/sdb1 /var/lib/machines/enl/var
>> --------------------------------------------------------------------
>
> THis isn't really how one would normally use subvolumes. No need to
> mount each subvolume explicitly, they are just special directories...
>

As long as you never clone parent volume (but why use btrfs then?) As
soon as you create clone or snapshot of parent volume, all childs will
be out of place in it unless you explicitly mount them in correct
place in hierarchy.
