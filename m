Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36548 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbcGIBUP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 21:20:15 -0400
Received: by mail-oi0-f51.google.com with SMTP id f189so81442938oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 18:20:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com> <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 8 Jul 2016 19:20:13 -0600
Message-ID: <CAJCQCtQnC3aQ0_AFKMwbGUjRByJiyhEk4ny2cRQGGW7ysVo0OQ@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
Cc: Henk Slager <eye1tm@gmail.com>, Kai Herlemann <nesadaw@freenet.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 11:40 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Jul 7, 2016 at 10:01 AM, Henk Slager <eye1tm@gmail.com> wrote:
>
>> What the latest debian likes as naming convention I dont know, but in
>> openSuSE @ is a directory in the toplevel volume (ID=5 or ID=0 as
>> alias) and that directory contains subvolumes.
>
> No, opensuse doesn't use @ at all. They use a subvolume called
> .snapshots to contain snapper snapshots.

OK this has changed in openSUSE Tumbleweed. It does create an @
subvolume into which all other subvolumes are created including
.snapshots.

0:install:/mnt # btrfs sub list -t /mnt/
ID    gen    top level    path
--    ---    ---------    ----
257    31    5           @
258    12    257        @/.snapshots
259    37    258        @/.snapshots/1/snapshot
260    14    257        @/boot/grub2/i386-pc
261    15    257        @/boot/grub2/x86_64-efi
262    16    257        @/opt
263    17    257        @/srv
264    18    257        @/tmp
265    19    257        @/usr/local
266    35    257        @/var/cache
267    21    257        @/var/crash
268    23    257        @/var/lib/libvirt/images
269    23    257        @/var/lib/mailman
270    25    257        @/var/lib/mariadb
271    26    257        @/var/lib/mysql
272    26    257        @/var/lib/named
273    28    257        @/var/lib/pgsql
274    35    257        @/var/log
275    29    257        @/var/opt
276    30    257        @/var/spool
277    35    257        @/var/tmp

The installation time rootfs is
0:install:/mnt # mount | grep btrfs
/dev/vda2 on /mnt type btrfs
(rw,relatime,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot)

I don't really understand the point of this additional layer of nesting under @.

I didn't test if it's still changing the default subvolume, rather
than using rootflags=subvol or subvolid.



-- 
Chris Murphy
