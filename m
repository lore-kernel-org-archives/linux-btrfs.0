Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36472 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbbLRMt2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 07:49:28 -0500
Received: by mail-lb0-f182.google.com with SMTP id yq9so43587899lbb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Dec 2015 04:49:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGqmi75csQRJifFt=66ooQ9SHqxfeAJoRe+u7v21gNqaFibpgA@mail.gmail.com>
References: <CAGqmi75csQRJifFt=66ooQ9SHqxfeAJoRe+u7v21gNqaFibpgA@mail.gmail.com>
Date: Fri, 18 Dec 2015 13:49:26 +0100
Message-ID: <CAPmG0jZ_k82PuxdMX0x5s80XUCps93JwWKtbgk+4DeEaSG7JkA@mail.gmail.com>
Subject: Re: Space not return
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 18, 2015 at 10:37 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> Hi guys, i catch strange problem:
> btrfs with mysql, mysql rewrite data, but space consumption only increasing
> i.e:
>
> df -h
> /dev/sdb1       112G   73G   39G  66% /var/lib/mysql
>
> du -hs
> 43G /var/lib/mysql/
As the fs is new, the file(s) in this directory might initially have
large extents. Writing a lot to the file(s), with larger pieces at
file-offsets that belong to those large extents makes btrfs CoW
allocate new extents but does not free the original space in the large
extents (no extent splitting in btrfs).

You could run:
# filefrag -k -v /var/lib/mysql/*
to see what the situation is, but migh be too much data.
In theory, if you would read and writeback the full offset+size of the
larger extents, the original large extent space is freed. You get more
fragmentation then, but should not be big problem on SSD (if
/dev/sdb1  is that)

File(s) re-creating with nodatacow mount option on might also be your
choice. And make sure you have no hidden snapshots somewhere, but I
assume you have checked that.
Another brute-force work-around would be to run:
# btrfs fi defrag -r -v -clzo /var/lib/mysql/
so to force rewriting info smaller extents, but you probably don't
want compression on those file(s)

> btrfs fi df /var/lib/mysql
> Data, single: total=78.00GiB, used=72.39GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=1.00GiB, used=109.61MiB
> GlobalReserve, single: total=48.00MiB, used=0.00B
>
> This is fresh fs (seven hours old)
> Created by btrfs-progs 4.1.2
> Linux 4.2.0-0.bpo.1-amd64 #1 SMP Debian 4.2.6-3~bpo8+2 (2015-12-14)
> x86_64 GNU/Linux
>
> Btrfsck not found any errors on this device
>
> P.S. First i think what it because system have opened files
> descriptors, but after reboot, space not return
> If i write file by dd and after delete it, space will returned (with
> direct io and without)
>
> --
> Have a nice day,
> Timofey.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
