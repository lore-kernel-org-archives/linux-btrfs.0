Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43664 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab2JXKYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 06:24:17 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so954929lbo.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 03:24:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506EA718.9080604@petaramesh.org>
References: <506EA718.9080604@petaramesh.org>
Date: Wed, 24 Oct 2012 12:24:15 +0200
Message-ID: <CAOcd+r0pKSWh3w7QaYUDfyXr+-MmAnzzcCOOYG0Rjb2Kc9t1Hg@mail.gmail.com>
Subject: Re: Help understanding btrfsck output...
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swami,
code is your friend again:)

#define I_ERR_FILE_NBYTES_WRONG		(1 << 10) // 400
...
if (rec->found_size != rec->nbytes)
	rec->errors |= I_ERR_FILE_NBYTES_WRONG;

>From what I recently learned "nbytes" for an inode is the total sum of
extents this inode has (assuming this is a regular file and not
directory, for example). While "inode size" is the size of the inode
as the user sees in "ls". So this error means that the file has too
many/too little EXTENT_DATAs allocated. btrfs-debug-tree would show
what is going on (this is invaluable tool, btw). I am not sure whether
this discrepancy would cause any issues (depends on each particular
file), and, unfortunately, I don't know btrfs mechanics deep enough to
understand how this could happen.

Alex.


On Fri, Oct 5, 2012 at 11:23 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Hi there,
>
> I have a system on which btrfsck gives the following output... I don't
> understand the meaning of the reported errors, so any clue would be
> appreciated. Is this something I should worry about, or not ?
>
> Would I be advised to try "--repair" ? (Last time I tried this one, it
> completely b0rked a filesystem, beyond repair, and my wife would kill me
> ifever I trash this one, for that's her machine, so please help ! ;-))
>
> root@PartedMagic:~# btrfsck /dev/sda6
> checking extents
> checking fs roots
> root 258 inode 772 errors 400
> root 258 inode 1025 errors 400
> root 258 inode 1029 errors 400
> root 258 inode 1056 errors 400
> root 258 inode 1057 errors 400
> root 258 inode 1125 errors 400
> root 258 inode 1126 errors 400
> root 258 inode 1548 errors 400
> root 258 inode 3845 errors 400
> root 258 inode 48006 errors 400
> root 258 inode 48013 errors 400
> root 258 inode 48023 errors 400
> root 258 inode 49919 errors 400
> root 258 inode 49920 errors 400
> root 258 inode 50399 errors 400
> root 258 inode 50504 errors 400
> root 349 inode 772 errors 400
> root 349 inode 1025 errors 400
> root 349 inode 1029 errors 400
> root 349 inode 1056 errors 400
> root 349 inode 1057 errors 400
> root 349 inode 1126 errors 400
> root 349 inode 1548 errors 400
> root 540 inode 772 errors 400
> root 540 inode 1025 errors 400
> root 540 inode 1029 errors 400
> root 540 inode 1056 errors 400
> root 540 inode 1057 errors 400
> root 540 inode 1125 errors 400
> root 540 inode 1126 errors 400
> root 540 inode 1548 errors 400
> root 540 inode 3845 errors 400
> root 561 inode 772 errors 400
> root 561 inode 1025 errors 400
> root 561 inode 1029 errors 400
> root 561 inode 1056 errors 400
> root 561 inode 1057 errors 400
> root 561 inode 1125 errors 400
> root 561 inode 1126 errors 400
> root 561 inode 1548 errors 400
> root 561 inode 3845 errors 400
> root 564 inode 772 errors 400
> root 564 inode 1025 errors 400
> root 564 inode 1029 errors 400
> root 564 inode 1056 errors 400
> root 564 inode 1057 errors 400
> root 564 inode 1125 errors 400
> root 564 inode 1126 errors 400
> root 564 inode 1548 errors 400
> root 564 inode 3845 errors 400
> root 597 inode 772 errors 400
> root 597 inode 1025 errors 400
> root 597 inode 1029 errors 400
> root 597 inode 1056 errors 400
> root 597 inode 1057 errors 400
> root 597 inode 1125 errors 400
> root 597 inode 1126 errors 400
> root 597 inode 1548 errors 400
> root 597 inode 3845 errors 400
> root 609 inode 772 errors 400
> root 609 inode 1025 errors 400
> root 609 inode 1029 errors 400
> root 609 inode 1056 errors 400
> root 609 inode 1057 errors 400
> root 609 inode 1125 errors 400
> root 609 inode 1126 errors 400
> root 609 inode 1548 errors 400
> root 609 inode 3845 errors 400
> root 612 inode 772 errors 400
> root 612 inode 1025 errors 400
> root 612 inode 1029 errors 400
> root 612 inode 1056 errors 400
> root 612 inode 1057 errors 400
> root 612 inode 1125 errors 400
> root 612 inode 1126 errors 400
> root 612 inode 1548 errors 400
> root 612 inode 3845 errors 400
> root 618 inode 772 errors 400
> root 618 inode 1025 errors 400
> root 618 inode 1029 errors 400
> root 618 inode 1056 errors 400
> root 618 inode 1057 errors 400
> root 618 inode 1125 errors 400
> root 618 inode 1126 errors 400
> root 618 inode 1548 errors 400
> root 618 inode 3845 errors 400
> root 621 inode 772 errors 400
> root 621 inode 1025 errors 400
> root 621 inode 1029 errors 400
> root 621 inode 1056 errors 400
> root 621 inode 1057 errors 400
> root 621 inode 1125 errors 400
> root 621 inode 1126 errors 400
> root 621 inode 1548 errors 400
> root 621 inode 3845 errors 400
> root 624 inode 772 errors 400
> root 624 inode 1025 errors 400
> root 624 inode 1029 errors 400
> root 624 inode 1056 errors 400
> root 624 inode 1057 errors 400
> root 624 inode 1125 errors 400
> root 624 inode 1126 errors 400
> root 624 inode 1548 errors 400
> root 624 inode 3845 errors 400
> root 630 inode 772 errors 400
> root 630 inode 1025 errors 400
> root 630 inode 1029 errors 400
> root 630 inode 1056 errors 400
> root 630 inode 1057 errors 400
> root 630 inode 1125 errors 400
> root 630 inode 1126 errors 400
> root 630 inode 1548 errors 400
> root 630 inode 3845 errors 400
> root 633 inode 772 errors 400
> root 633 inode 1025 errors 400
> root 633 inode 1029 errors 400
> root 633 inode 1056 errors 400
> root 633 inode 1057 errors 400
> root 633 inode 1125 errors 400
> root 633 inode 1126 errors 400
> root 633 inode 1548 errors 400
> root 633 inode 3845 errors 400
> root 636 inode 772 errors 400
> root 636 inode 1025 errors 400
> root 636 inode 1029 errors 400
> root 636 inode 1056 errors 400
> root 636 inode 1057 errors 400
> root 636 inode 1125 errors 400
> root 636 inode 1126 errors 400
> root 636 inode 1548 errors 400
> root 636 inode 3845 errors 400
> root 639 inode 772 errors 400
> root 639 inode 1025 errors 400
> root 639 inode 1029 errors 400
> root 639 inode 1056 errors 400
> root 639 inode 1057 errors 400
> root 639 inode 1125 errors 400
> root 639 inode 1126 errors 400
> root 639 inode 1548 errors 400
> root 639 inode 3845 errors 400
> root 642 inode 772 errors 400
> root 642 inode 1025 errors 400
> root 642 inode 1029 errors 400
> root 642 inode 1056 errors 400
> root 642 inode 1057 errors 400
> root 642 inode 1125 errors 400
> root 642 inode 1126 errors 400
> root 642 inode 1548 errors 400
> root 642 inode 3845 errors 400
> root 642 inode 48006 errors 400
> root 642 inode 48013 errors 400
> root 642 inode 48023 errors 400
> root 642 inode 48028 errors 400
> root 642 inode 48029 errors 400
> root 645 inode 772 errors 400
> root 645 inode 1025 errors 400
> root 645 inode 1029 errors 400
> root 645 inode 1056 errors 400
> root 645 inode 1057 errors 400
> root 645 inode 1125 errors 400
> root 645 inode 1126 errors 400
> root 645 inode 1548 errors 400
> root 645 inode 3845 errors 400
> root 645 inode 48006 errors 400
> root 645 inode 48013 errors 400
> root 645 inode 48023 errors 400
> root 648 inode 772 errors 400
> root 648 inode 1025 errors 400
> root 648 inode 1029 errors 400
> root 648 inode 1056 errors 400
> root 648 inode 1057 errors 400
> root 648 inode 1125 errors 400
> root 648 inode 1126 errors 400
> root 648 inode 1548 errors 400
> root 648 inode 3845 errors 400
> root 648 inode 48006 errors 400
> root 648 inode 48013 errors 400
> root 648 inode 48023 errors 400
> root 651 inode 772 errors 400
> root 651 inode 1025 errors 400
> root 651 inode 1029 errors 400
> root 651 inode 1056 errors 400
> root 651 inode 1057 errors 400
> root 651 inode 1125 errors 400
> root 651 inode 1126 errors 400
> root 651 inode 1548 errors 400
> root 651 inode 3845 errors 400
> root 651 inode 48006 errors 400
> root 651 inode 48013 errors 400
> root 651 inode 48023 errors 400
> root 651 inode 49762 errors 400
> root 651 inode 49917 errors 400
> root 651 inode 49919 errors 400
> root 651 inode 49920 errors 400
> root 654 inode 772 errors 400
> root 654 inode 1025 errors 400
> root 654 inode 1029 errors 400
> root 654 inode 1056 errors 400
> root 654 inode 1057 errors 400
> root 654 inode 1125 errors 400
> root 654 inode 1126 errors 400
> root 654 inode 1548 errors 400
> root 654 inode 3845 errors 400
> root 654 inode 48006 errors 400
> root 654 inode 48013 errors 400
> root 654 inode 48023 errors 400
> root 654 inode 49762 errors 400
> root 654 inode 49919 errors 400
> root 654 inode 49920 errors 400
> root 657 inode 772 errors 400
> root 657 inode 1025 errors 400
> root 657 inode 1029 errors 400
> root 657 inode 1056 errors 400
> root 657 inode 1057 errors 400
> root 657 inode 1125 errors 400
> root 657 inode 1126 errors 400
> root 657 inode 1548 errors 400
> root 657 inode 3845 errors 400
> root 657 inode 48006 errors 400
> root 657 inode 48013 errors 400
> root 657 inode 48023 errors 400
> root 657 inode 49919 errors 400
> root 657 inode 49920 errors 400
> root 660 inode 772 errors 400
> root 660 inode 1025 errors 400
> root 660 inode 1029 errors 400
> root 660 inode 1056 errors 400
> root 660 inode 1057 errors 400
> root 660 inode 1125 errors 400
> root 660 inode 1126 errors 400
> root 660 inode 1548 errors 400
> root 660 inode 3845 errors 400
> root 660 inode 48006 errors 400
> root 660 inode 48013 errors 400
> root 660 inode 48023 errors 400
> root 660 inode 49919 errors 400
> root 660 inode 49920 errors 400
> root 663 inode 772 errors 400
> root 663 inode 1025 errors 400
> root 663 inode 1029 errors 400
> root 663 inode 1056 errors 400
> root 663 inode 1057 errors 400
> root 663 inode 1125 errors 400
> root 663 inode 1126 errors 400
> root 663 inode 1548 errors 400
> root 663 inode 3845 errors 400
> root 663 inode 48006 errors 400
> root 663 inode 48013 errors 400
> root 663 inode 48023 errors 400
> root 663 inode 49919 errors 400
> root 663 inode 49920 errors 400
> root 663 inode 50399 errors 400
> root 663 inode 50504 errors 400
> root 667 inode 772 errors 400
> root 667 inode 1025 errors 400
> root 667 inode 1029 errors 400
> root 667 inode 1056 errors 400
> root 667 inode 1057 errors 400
> root 667 inode 1125 errors 400
> root 667 inode 1126 errors 400
> root 667 inode 1548 errors 400
> root 667 inode 3845 errors 400
> root 667 inode 48006 errors 400
> root 667 inode 48013 errors 400
> root 667 inode 48023 errors 400
> root 667 inode 49919 errors 400
> root 667 inode 49920 errors 400
> root 667 inode 50399 errors 400
> root 667 inode 50504 errors 400
> found 54962528257 bytes used err is 1
> total csum bytes: 52166300
> total tree bytes: 1531371520
> total fs tree bytes: 1376681984
> btree space waste bytes: 382927315
> file data blocks allocated: 103024238592
>  referenced 102409895936
> Btrfs Btrfs v0.19
>
> --
> Swāmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
