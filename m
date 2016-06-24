Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32923 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFXAy3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 20:54:29 -0400
Received: by mail-oi0-f52.google.com with SMTP id u201so95333077oie.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 17:54:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20160623T205347-371@post.gmane.org>
References: <loom.20160623T205347-371@post.gmane.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Jun 2016 18:54:28 -0600
Message-ID: <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Vasco Almeida <vascomalmeida@sapo.pt>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 2:30 PM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:
> I was running OpenSuse Leap 42.1 with btrfs and
> LVM (Logical Volume Management).
> Last time I've checked smartd log, I noticed there were
> 30 sector pending reallocation and 1 unrecoverable bad
> sector on hard drive.
> I think my hard drive got some sector corrupted and now btrfs fails
> some checksum and forces mount readonly.
> The device is successfully mounted readonly.
>
> OpenSuse dmesg reported:
>
> BTRFS: dm-1 checksum verify failed on 437944320 wanted 39F45669 found
> 8BF8C752 leval 0
> (more 2 times)
> BTRFS: error (device dm-1) in btrfs_drop_snapshot:???: error=-5 IO failure
> BTRFS: info (device dm-1): forced readonly
>
> Now I'm on System Rescue CD and that is not reported.
> I've written down those log line on paper, so there may be some typo.
> Seemingly there is no journalctl installed on this system to check
> OpenSuse logs again.
>
> All the following logs are on System Rescue CD.
> mount -o ro,recovery /dev/mapper/vg_pupu-lv_opensuse_root /mnt/opensuse
> https://bpaste.net/show/263e5f7ae9d4
>
> After mounting and umounting several times with and without "-o ro,recovery"
> https://bpaste.net/show/43eb64decb63
>
> btrfs check --readonly /dev/mapper/vg_pupu-lv_opensuse_root
> https://bpaste.net/show/7ecf422c73a2
>
>
> Would it be apropriate to run any of "btrfs check --repair /device" or
> "btrfs check --init-csum-tree /device" to be able to mount readwrite again?
>
> smartctl --all /dev/disk/by-id/ata-SAMSUNG_HD154UI_S1Y6JDWSC01351
> https://bpaste.net/show/a6c132618974
>
> btrfs check manpage: https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-check
> btrfsck page: https://btrfs.wiki.kernel.org/index.php/Btrfsck

Normally if this is just data blocks corrupted it will still mount rw
and just flag the affected file in kernel messages so you can delete
it and replace.

Since that's not happening, it's probably metadata, but then there
should be two copies unless this is on SSD or otherwise the file
system was created with -m single. If there are two copies of the
metadata and both are wrong that's unusual.


>From the pasted kernel messages:

> Linux version 3.18.34-std473-amd64 (root@rl-sysrcd-p11) (gcc version 4.8.5 (Gentoo 4.8.5 p1.3, pie-0.6.2) ) #2 SMP Tue May 24 20:34:19 UTC 2016


3.18.34 is ancient. Find something newer and try to remount normally.
And then also with recovery if necessary (don't use ro, see if it'll
mount rw and fix itself). And if not, then try btrfs check with a
newer version of btrfs-progs, I can't tell from the pasted output what
version you're using but since the kernel is so old, decent chance the
btrfsck is old also.


Chris Murphy





-- 
Chris Murphy
