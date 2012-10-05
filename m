Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:47976 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2JEJXn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 05:23:43 -0400
Message-ID: <506EA718.9080604@petaramesh.org>
Date: Fri, 05 Oct 2012 11:23:36 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Help understanding btrfsck output...
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I have a system on which btrfsck gives the following output... I don't
understand the meaning of the reported errors, so any clue would be
appreciated. Is this something I should worry about, or not ?

Would I be advised to try "--repair" ? (Last time I tried this one, it
completely b0rked a filesystem, beyond repair, and my wife would kill me
ifever I trash this one, for that's her machine, so please help ! ;-))

root@PartedMagic:~# btrfsck /dev/sda6
checking extents
checking fs roots
root 258 inode 772 errors 400
root 258 inode 1025 errors 400
root 258 inode 1029 errors 400
root 258 inode 1056 errors 400
root 258 inode 1057 errors 400
root 258 inode 1125 errors 400
root 258 inode 1126 errors 400
root 258 inode 1548 errors 400
root 258 inode 3845 errors 400
root 258 inode 48006 errors 400
root 258 inode 48013 errors 400
root 258 inode 48023 errors 400
root 258 inode 49919 errors 400
root 258 inode 49920 errors 400
root 258 inode 50399 errors 400
root 258 inode 50504 errors 400
root 349 inode 772 errors 400
root 349 inode 1025 errors 400
root 349 inode 1029 errors 400
root 349 inode 1056 errors 400
root 349 inode 1057 errors 400
root 349 inode 1126 errors 400
root 349 inode 1548 errors 400
root 540 inode 772 errors 400
root 540 inode 1025 errors 400
root 540 inode 1029 errors 400
root 540 inode 1056 errors 400
root 540 inode 1057 errors 400
root 540 inode 1125 errors 400
root 540 inode 1126 errors 400
root 540 inode 1548 errors 400
root 540 inode 3845 errors 400
root 561 inode 772 errors 400
root 561 inode 1025 errors 400
root 561 inode 1029 errors 400
root 561 inode 1056 errors 400
root 561 inode 1057 errors 400
root 561 inode 1125 errors 400
root 561 inode 1126 errors 400
root 561 inode 1548 errors 400
root 561 inode 3845 errors 400
root 564 inode 772 errors 400
root 564 inode 1025 errors 400
root 564 inode 1029 errors 400
root 564 inode 1056 errors 400
root 564 inode 1057 errors 400
root 564 inode 1125 errors 400
root 564 inode 1126 errors 400
root 564 inode 1548 errors 400
root 564 inode 3845 errors 400
root 597 inode 772 errors 400
root 597 inode 1025 errors 400
root 597 inode 1029 errors 400
root 597 inode 1056 errors 400
root 597 inode 1057 errors 400
root 597 inode 1125 errors 400
root 597 inode 1126 errors 400
root 597 inode 1548 errors 400
root 597 inode 3845 errors 400
root 609 inode 772 errors 400
root 609 inode 1025 errors 400
root 609 inode 1029 errors 400
root 609 inode 1056 errors 400
root 609 inode 1057 errors 400
root 609 inode 1125 errors 400
root 609 inode 1126 errors 400
root 609 inode 1548 errors 400
root 609 inode 3845 errors 400
root 612 inode 772 errors 400
root 612 inode 1025 errors 400
root 612 inode 1029 errors 400
root 612 inode 1056 errors 400
root 612 inode 1057 errors 400
root 612 inode 1125 errors 400
root 612 inode 1126 errors 400
root 612 inode 1548 errors 400
root 612 inode 3845 errors 400
root 618 inode 772 errors 400
root 618 inode 1025 errors 400
root 618 inode 1029 errors 400
root 618 inode 1056 errors 400
root 618 inode 1057 errors 400
root 618 inode 1125 errors 400
root 618 inode 1126 errors 400
root 618 inode 1548 errors 400
root 618 inode 3845 errors 400
root 621 inode 772 errors 400
root 621 inode 1025 errors 400
root 621 inode 1029 errors 400
root 621 inode 1056 errors 400
root 621 inode 1057 errors 400
root 621 inode 1125 errors 400
root 621 inode 1126 errors 400
root 621 inode 1548 errors 400
root 621 inode 3845 errors 400
root 624 inode 772 errors 400
root 624 inode 1025 errors 400
root 624 inode 1029 errors 400
root 624 inode 1056 errors 400
root 624 inode 1057 errors 400
root 624 inode 1125 errors 400
root 624 inode 1126 errors 400
root 624 inode 1548 errors 400
root 624 inode 3845 errors 400
root 630 inode 772 errors 400
root 630 inode 1025 errors 400
root 630 inode 1029 errors 400
root 630 inode 1056 errors 400
root 630 inode 1057 errors 400
root 630 inode 1125 errors 400
root 630 inode 1126 errors 400
root 630 inode 1548 errors 400
root 630 inode 3845 errors 400
root 633 inode 772 errors 400
root 633 inode 1025 errors 400
root 633 inode 1029 errors 400
root 633 inode 1056 errors 400
root 633 inode 1057 errors 400
root 633 inode 1125 errors 400
root 633 inode 1126 errors 400
root 633 inode 1548 errors 400
root 633 inode 3845 errors 400
root 636 inode 772 errors 400
root 636 inode 1025 errors 400
root 636 inode 1029 errors 400
root 636 inode 1056 errors 400
root 636 inode 1057 errors 400
root 636 inode 1125 errors 400
root 636 inode 1126 errors 400
root 636 inode 1548 errors 400
root 636 inode 3845 errors 400
root 639 inode 772 errors 400
root 639 inode 1025 errors 400
root 639 inode 1029 errors 400
root 639 inode 1056 errors 400
root 639 inode 1057 errors 400
root 639 inode 1125 errors 400
root 639 inode 1126 errors 400
root 639 inode 1548 errors 400
root 639 inode 3845 errors 400
root 642 inode 772 errors 400
root 642 inode 1025 errors 400
root 642 inode 1029 errors 400
root 642 inode 1056 errors 400
root 642 inode 1057 errors 400
root 642 inode 1125 errors 400
root 642 inode 1126 errors 400
root 642 inode 1548 errors 400
root 642 inode 3845 errors 400
root 642 inode 48006 errors 400
root 642 inode 48013 errors 400
root 642 inode 48023 errors 400
root 642 inode 48028 errors 400
root 642 inode 48029 errors 400
root 645 inode 772 errors 400
root 645 inode 1025 errors 400
root 645 inode 1029 errors 400
root 645 inode 1056 errors 400
root 645 inode 1057 errors 400
root 645 inode 1125 errors 400
root 645 inode 1126 errors 400
root 645 inode 1548 errors 400
root 645 inode 3845 errors 400
root 645 inode 48006 errors 400
root 645 inode 48013 errors 400
root 645 inode 48023 errors 400
root 648 inode 772 errors 400
root 648 inode 1025 errors 400
root 648 inode 1029 errors 400
root 648 inode 1056 errors 400
root 648 inode 1057 errors 400
root 648 inode 1125 errors 400
root 648 inode 1126 errors 400
root 648 inode 1548 errors 400
root 648 inode 3845 errors 400
root 648 inode 48006 errors 400
root 648 inode 48013 errors 400
root 648 inode 48023 errors 400
root 651 inode 772 errors 400
root 651 inode 1025 errors 400
root 651 inode 1029 errors 400
root 651 inode 1056 errors 400
root 651 inode 1057 errors 400
root 651 inode 1125 errors 400
root 651 inode 1126 errors 400
root 651 inode 1548 errors 400
root 651 inode 3845 errors 400
root 651 inode 48006 errors 400
root 651 inode 48013 errors 400
root 651 inode 48023 errors 400
root 651 inode 49762 errors 400
root 651 inode 49917 errors 400
root 651 inode 49919 errors 400
root 651 inode 49920 errors 400
root 654 inode 772 errors 400
root 654 inode 1025 errors 400
root 654 inode 1029 errors 400
root 654 inode 1056 errors 400
root 654 inode 1057 errors 400
root 654 inode 1125 errors 400
root 654 inode 1126 errors 400
root 654 inode 1548 errors 400
root 654 inode 3845 errors 400
root 654 inode 48006 errors 400
root 654 inode 48013 errors 400
root 654 inode 48023 errors 400
root 654 inode 49762 errors 400
root 654 inode 49919 errors 400
root 654 inode 49920 errors 400
root 657 inode 772 errors 400
root 657 inode 1025 errors 400
root 657 inode 1029 errors 400
root 657 inode 1056 errors 400
root 657 inode 1057 errors 400
root 657 inode 1125 errors 400
root 657 inode 1126 errors 400
root 657 inode 1548 errors 400
root 657 inode 3845 errors 400
root 657 inode 48006 errors 400
root 657 inode 48013 errors 400
root 657 inode 48023 errors 400
root 657 inode 49919 errors 400
root 657 inode 49920 errors 400
root 660 inode 772 errors 400
root 660 inode 1025 errors 400
root 660 inode 1029 errors 400
root 660 inode 1056 errors 400
root 660 inode 1057 errors 400
root 660 inode 1125 errors 400
root 660 inode 1126 errors 400
root 660 inode 1548 errors 400
root 660 inode 3845 errors 400
root 660 inode 48006 errors 400
root 660 inode 48013 errors 400
root 660 inode 48023 errors 400
root 660 inode 49919 errors 400
root 660 inode 49920 errors 400
root 663 inode 772 errors 400
root 663 inode 1025 errors 400
root 663 inode 1029 errors 400
root 663 inode 1056 errors 400
root 663 inode 1057 errors 400
root 663 inode 1125 errors 400
root 663 inode 1126 errors 400
root 663 inode 1548 errors 400
root 663 inode 3845 errors 400
root 663 inode 48006 errors 400
root 663 inode 48013 errors 400
root 663 inode 48023 errors 400
root 663 inode 49919 errors 400
root 663 inode 49920 errors 400
root 663 inode 50399 errors 400
root 663 inode 50504 errors 400
root 667 inode 772 errors 400
root 667 inode 1025 errors 400
root 667 inode 1029 errors 400
root 667 inode 1056 errors 400
root 667 inode 1057 errors 400
root 667 inode 1125 errors 400
root 667 inode 1126 errors 400
root 667 inode 1548 errors 400
root 667 inode 3845 errors 400
root 667 inode 48006 errors 400
root 667 inode 48013 errors 400
root 667 inode 48023 errors 400
root 667 inode 49919 errors 400
root 667 inode 49920 errors 400
root 667 inode 50399 errors 400
root 667 inode 50504 errors 400
found 54962528257 bytes used err is 1
total csum bytes: 52166300
total tree bytes: 1531371520
total fs tree bytes: 1376681984
btree space waste bytes: 382927315
file data blocks allocated: 103024238592
 referenced 102409895936
Btrfs Btrfs v0.19

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

