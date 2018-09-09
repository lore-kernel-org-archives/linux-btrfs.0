Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46806 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeIJHXW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 03:23:22 -0400
Received: by mail-lf1-f68.google.com with SMTP id e23-v6so16128444lfc.13
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Sep 2018 19:31:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTTHinSJy6c7jV1pApeQgnGwMHjd9DEutqxc-T5XjKVbeh1SA@mail.gmail.com>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com> <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
 <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com> <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
 <326f12a3-ee55-0812-5ea6-f54c0362a29b@gmail.com> <CAJCQCtS+ZXzGU0AE=C1iA7yNFrXuRAvZkhssxN40=jPd=x6neA@mail.gmail.com>
 <CAHTTHimqg_wgqs0AXt73YzOv3ga7cAEUvbwMOVVT2JUVaNbsFQ@mail.gmail.com>
 <CAJCQCtSa1-5Zae4_jqqhZk49YQ+6fKG+jgwcG2_uK5+sYfwCbQ@mail.gmail.com>
 <CAHTTHinoyvVCq2ejsDDgtzvFZCiyv7RiJnEkjnx+JdVZYB2+4w@mail.gmail.com>
 <CAJCQCtTd7+u3yMtKDshmsw7R1P2bK_JhVqJVKvObNb20uw-6jA@mail.gmail.com>
 <CAHTTHimT7m+S4bm1OgZOfmFkk69fc1SPGEvidxwFCHniKL-w6A@mail.gmail.com>
 <CAHTTHinoH=TG+6zMw0X8rDAdaou3joc+mo_oZAL918BP1sLwqA@mail.gmail.com>
 <CAJCQCtTeOvJDnz8YZpCm86zuqeeTN-7p5kxEycWME+txzqz3tQ@mail.gmail.com> <CAHTTHinSJy6c7jV1pApeQgnGwMHjd9DEutqxc-T5XjKVbeh1SA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 9 Sep 2018 17:29:45 -0600
Message-ID: <CAJCQCtSgCyoC8yLtWOR2Wa+RGwDHr-KX+XGdL1=3S2F9mDgnZA@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: Stefan Loewen <stefan.loewen@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 9, 2018 at 2:16 PM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
> I'm not sure about the exact definition of "blocked" here, but I was
> also surprised that there were no blocked tasks listed since I'm
> definitely unable to kill (SIGKILL) that process.
> On the other hand it wakes up hourly to transfer a few bytes.
> The problem is definitely not, that I issued the sysrq too early. I
> think it was after about 45min of no IO.

Another one the devs have asked for in cases where things get slow or
hang, but without explicit blocked task messages, is sysrq + t. But
I'm throwing spaghetti at a wall at this point, none of it will fix
the problem, and I haven't learned how to read these outputs.



> So there is some problem with this "original" subvol. Maybe I should
> describe how that came into existence.
> Initially I had my data on a NTFS formatted drive. I then created a
> btrfs partition on my second drive and rsynced all my stuff over into
> the root subvol.
> Then I noticed that having all my data in the root subvol was a bad
> idea and created a "data" subvol and reflinked everything into it.
> I deleted the data from the root subvol, made a snapshot of the "data"
> subvol, tried sending that and ran into the problem we're discussing
> here.

That is interesting and useful information. I see nothing invalid
about it at all. However, just for future reference it is possible to
snapshot the top level (default) subvolume.

By default, the top level subvolume (sometimes referred to as
subvolid=5 or subvolid=0) is what is mounted if you haven't used
'btrfs sub set-default' to change it. You can snapshot that subvolume
by snapshotting the mount point. e.g.

mount /dev/sda1 /mnt
btrfs sub snap /mnt/subvolume1

So now you have a readwrite subvolume called "subvolume1" which
contains everything that was in the top level, which you can now
delete if you're trying to keep things tidy and just have subvolumes
and snapshots in the top level.

Anyway, what you did is possibly relevant to the problem. But if it
turns out it's the cause of the problem, it's definitely a bug.


>
> btrfs check in lowmem mode did not find any errors either:
>
> $ sudo btrfs check --mode=lowmem --progress /dev/sdb1
> Opening filesystem to check...
> Checking filesystem on /dev/sdb1
> UUID: cd786597-3816-40e7-bf6c-d585265ad372
> [1/7] checking root items                      (0:00:30 elapsed,
> 1047408 items checked)
> [2/7] checking extents                         (0:03:55 elapsed,
> 309170 items checked)
> cache and super generation don't match, space cache will be invalidated
> [3/7] checking free space cache                (0:00:00 elapsed)
> [4/7] checking fs roots                        (0:04:07 elapsed, 85373
> items checked)
> [5/7] checking csums (without verifying data)  (0:00:00 elapsed,
> 253106 items checked)
> [6/7] checking root refs done with fs roots in lowmem mode, skipping
> [7/7] checking quota groups skipped (not enabled on this FS)
> found 708354711552 bytes used, no error found
> total csum bytes: 689206904
> total tree bytes: 2423865344
> total fs tree bytes: 1542914048
> total extent tree bytes: 129843200
> btree space waste bytes: 299191292
> file data blocks allocated: 31709967417344
> referenced 928531877888

OK good to know.


-- 
Chris Murphy
