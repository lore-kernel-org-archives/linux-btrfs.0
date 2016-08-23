Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35371 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbcHWPWg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 11:22:36 -0400
Received: by mail-oi0-f54.google.com with SMTP id 4so201105842oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 08:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 Aug 2016 08:52:40 -0600
Message-ID: <CAJCQCtQf2bhxWc6+nYoxYz8HquMOsj5hAfTc=5B2w0_1d8U9rQ@mail.gmail.com>
Subject: Re: btrfs partition fails to mount after power outage
To: Malte Westerhoff <MWesterhoff@visageimaging.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 6:30 AM, Malte Westerhoff
<MWesterhoff@visageimaging.com> wrote:
> Hi,
> I hope this is the right list for this problem report.
>
> After an unclean shutdown of a server due to power outage, one of the partitions fails to mount.
> mount -o recovery ...,mount -o recovery,ro ..., mount -o ro do not help. They produce this error in the log:
>
> [ 5464.525816] BTRFS info (device dm-0): enabling auto recovery
> [ 5464.525823] BTRFS info (device dm-0): disk space caching is enabled
> [ 5464.525825] BTRFS: has skinny extents
> [ 5499.299686] BTRFS (device dm-0): parent transid verify failed on 7375769206784 wanted 52059 found 52028
> [ 5499.308576] BTRFS (device dm-0): parent transid verify failed on 7375769206784 wanted 52059 found 52028
> [ 5499.308587] BTRFS: Failed to read block groups: -5
> [ 5499.391359] BTRFS: open_ctree failed
>
>
> btrfs check --repair fails with an error message:
> ... (full output attached)
> Ignoring transid failure
> parent transid verify failed on 7375567323136 wanted 52059 found 52045
> parent transid verify failed on 7375567323136 wanted 52059 found 52045
> Error: could not find btree root extent for root 12974
>
> This is kernel 4.1.27 and btrfs-progs 4.1.2. We also tried the btrfs check --repair with btrfs-progs 4.7 with the same result.
>
> The partition with the problem is /dev/mapper/VGBIGRAID6-DATA1
> (The partition is an LVM logical volume that is on top of an md raid6.)

Sounds to me like the raid6 is not assembling correctly or is dirty.
The btrfs structures are small enough that it's possible for incorrect
or dirty raid assembly to present some pieces of the file system to
make it look like Btrfs (like the super blocks can be found) but then
not enough for mount. Especially if this is a default md chunk size of
512KiB.

What do you get for

mdadm -E /dev/mdX
btrfs-show-super -fa /dev/mapper/VGBIGRAID6-DATA1
btrfs-find-root -d /dev/mapper/VGBIGRAID6-DATA1

>
> Anything else that we can try in order to recover the volume?
>
> Thanks
> Malte
>
> quickstore2:~/btrfs-progs # uname -a
> Linux quickstore2 4.1.27-27-default #1 SMP PREEMPT Fri Jul 15 12:46:41 UTC 2016 (84ae57e) x86_64 x86_64 x86_64 GNU/Linux
> quickstore2:~/btrfs-progs # btrfs --version
> btrfs-progs v4.1.2+20151002
> quickstore2:~/btrfs-progs # btrfs fi show
> Label: none  uuid: ef3fc810-d74e-4c8e-97e3-7c7e788795ae
>         Total devices 1 FS bytes used 12.14GiB
>         devid    1 size 80.00GiB used 15.04GiB path /dev/sda1
>
> Label: none  uuid: 9b4af403-e40c-4228-825a-20666aa0ec3c
>         Total devices 1 FS bytes used 581.48GiB
>         devid    1 size 8.00TiB used 616.03GiB path /dev/mapper/VGBIGRAID6-DATA2
>
> Label: none  uuid: 98330879-6f67-44f0-92ba-974c86a836d1
>         Total devices 1 FS bytes used 1015.34GiB
>         devid    1 size 8.00TiB used 1.08TiB path /dev/mapper/VGBIGRAID6-data3
>
> Label: none  uuid: 014d9f5c-48b2-4043-add3-5150ce418570
>         Total devices 1 FS bytes used 3.15TiB
>         devid    1 size 16.00TiB used 3.21TiB path /dev/mapper/VGBIGRAID6-data4
>
> Label: none  uuid: 0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2
>         Total devices 1 FS bytes used 6.72TiB
>         devid    1 size 16.00TiB used 6.97TiB path /dev/mapper/VGBIGRAID6-DATA1


Is it the same md array that these other dataX LV's are on? And they
are mountable?




-- 
Chris Murphy
