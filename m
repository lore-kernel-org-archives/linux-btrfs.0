Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34352 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbcHWQLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 12:11:00 -0400
Received: by mail-oi0-f54.google.com with SMTP id l203so202785271oib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 09:10:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E80D3AE3-69A9-40E7-9946-D2F66214828B@visageimaging.com>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
 <CAJCQCtQf2bhxWc6+nYoxYz8HquMOsj5hAfTc=5B2w0_1d8U9rQ@mail.gmail.com>
 <B26BAB7E-A049-4730-B7AD-3E906026F25C@visageimaging.com> <CAJCQCtSuiSrLVLVmF9wktcMJqApET0DoOf=_2V=oEb=5sPPTgg@mail.gmail.com>
 <E80D3AE3-69A9-40E7-9946-D2F66214828B@visageimaging.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 Aug 2016 10:05:19 -0600
Message-ID: <CAJCQCtTyuxQee_GzgZCY2WRC04LEXAOvbg_BW_uBVh+iTTgrEQ@mail.gmail.com>
Subject: Re: btrfs partition fails to mount after power outage
To: Malte Westerhoff <MWesterhoff@visageimaging.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 9:51 AM, Malte Westerhoff
<MWesterhoff@visageimaging.com> wrote:
>     >>     btrfs-show-super -fa /d/dev/mapper/VGBIGRAID6-DATA1
>
>>    Where is this output?
>
> I had attached it as a separate file. Here it is again:

Sorry, missed that there was an attachment.



> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       3421559472128   gen: 52059      level: 1
>                 backup_chunk_root:      20971520        gen: 52005      level: 1
>                 backup_extent_root:     3421770170368   gen: 52059      level: 3
>                 backup_fs_root:         29556736        gen: 6  level: 0
>                 backup_dev_root:        7304828502016   gen: 52059      level: 1
>                 backup_csum_root:       7315970588672   gen: 52059      level: 3
>                 backup_total_bytes:     17592186044416
>                 backup_bytes_used:      7386753196032
>                 backup_num_devices:     1
>
>         backup 1:
>                 backup_tree_root:       7442297503744   gen: 52056      level: 1
>                 backup_chunk_root:      20971520        gen: 52005      level: 1
>                 backup_extent_root:     7442294161408   gen: 52056      level: 3
>                 backup_fs_root:         29556736        gen: 6  level: 0
>                 backup_dev_root:        7254075654144   gen: 52005      level: 1
>                 backup_csum_root:       7442298175488   gen: 52056      level: 3
>                 backup_total_bytes:     17592186044416
>                 backup_bytes_used:      7386753163264
>                 backup_num_devices:     1
>
>         backup 2:
>                 backup_tree_root:       7442289229824   gen: 52057      level: 1
>                 backup_chunk_root:      20971520        gen: 52005      level: 1
>                 backup_extent_root:     7442283692032   gen: 52057      level: 3
>                 backup_fs_root:         29556736        gen: 6  level: 0
>                 backup_dev_root:        7254075654144   gen: 52005      level: 1
>                 backup_csum_root:       7442294063104   gen: 52057      level: 3
>                 backup_total_bytes:     17592186044416
>                 backup_bytes_used:      7386753179648
>                 backup_num_devices:     1
>
>         backup 3:
>                 backup_tree_root:       7442297503744   gen: 52058      level: 1
>                 backup_chunk_root:      20971520        gen: 52005      level: 1
>                 backup_extent_root:     7442284920832   gen: 52058      level: 3
>                 backup_fs_root:         29556736        gen: 6  level: 0
>                 backup_dev_root:        7254075654144   gen: 52005      level: 1
>                 backup_csum_root:       7442299355136   gen: 52058      level: 3
>                 backup_total_bytes:     17592186044416
>                 backup_bytes_used:      7386753179648
>                 backup_num_devices:     1


Uhhhh, is anyone else having a WTF moment? Why is the backup_fs_root
generation 6 on all of these backup roots? Doesn't that seem really
unlikely? On all of my filesystems, the fs_root has a lower
generation, but isn't separated by this many generations.

What do you get for:

btrfs-debug-tree -b 29556736 /dev/mapper/VGBIGRAID6-DATA1





-- 
Chris Murphy
