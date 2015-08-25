Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51296 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbbHYOEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 10:04:11 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Date: Tue, 25 Aug 2015 16:03:55 +0200
Message-ID: <2139681.geeI7cQtEN@tethys>
In-Reply-To: <1474026.LQOmDW8fG5@tethys>
References: <2017000.AEG9PyVY17@zafu> <pan$d4557$9c42de4e$12e74017$2f692aea@cox.net> <1474026.LQOmDW8fG5@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le mardi 25 août 2015 15:25:12 Swâmi Petaramesh a écrit :
> Uh, I've started it hours ago, and it has been eating 100% CPU on one of my 
> cores since, without apparently yet finding a single error.

btrfs check finally came to an end, and fixed dirs iszes.

The 1st good news is that my FS didn't die in the process, the 2nd good news 
is that I was then actually able to delete the "empty" directory that couldn't 
be deleted before.

So, it did the job ;-)

Here's the output :

enabling repair mode
Checking filesystem on /dev/VGZ/LINUX
UUID: 13c87f57-3a85-4daf-a4bf-ba777407c169
cache and super generation don't match, space cache will be invalidated
reset isize for dir 297 root 267
reset isize for dir 3341 root 267
reset isize for dir 324547 root 267
reset isize for dir 297 root 9119
reset isize for dir 3341 root 9119
reset isize for dir 324547 root 9119
reset isize for dir 297 root 10972
reset isize for dir 3341 root 10972
reset isize for dir 324547 root 10972
reset isize for dir 297 root 12028
reset isize for dir 3341 root 12028
reset isize for dir 324547 root 12028
reset isize for dir 297 root 14103
reset isize for dir 3341 root 14103
reset isize for dir 324547 root 14103
reset isize for dir 297 root 16144
reset isize for dir 3341 root 16144
reset isize for dir 324547 root 16144
reset isize for dir 297 root 18136
reset isize for dir 3341 root 18136
reset isize for dir 324547 root 18136
reset isize for dir 297 root 20366
reset isize for dir 3341 root 20366
reset isize for dir 324547 root 20366
reset isize for dir 297 root 22870
reset isize for dir 3341 root 22870
reset isize for dir 324547 root 22870
reset isize for dir 297 root 23700
reset isize for dir 3341 root 23700
reset isize for dir 324547 root 23700
reset isize for dir 297 root 23850
reset isize for dir 3341 root 23850
reset isize for dir 324547 root 23850
reset isize for dir 297 root 23993
reset isize for dir 3341 root 23993
reset isize for dir 324547 root 23993
reset isize for dir 297 root 24083
reset isize for dir 3341 root 24083
reset isize for dir 324547 root 24083
reset isize for dir 297 root 24133
reset isize for dir 3341 root 24133
reset isize for dir 324547 root 24133
reset isize for dir 297 root 24163
reset isize for dir 3341 root 24163
reset isize for dir 324547 root 24163
reset isize for dir 297 root 24193
reset isize for dir 3341 root 24193
reset isize for dir 324547 root 24193
reset isize for dir 297 root 24205
reset isize for dir 3341 root 24205
reset isize for dir 324547 root 24205
reset isize for dir 297 root 24216
reset isize for dir 3341 root 24216
reset isize for dir 324547 root 24216
reset isize for dir 297 root 24226
reset isize for dir 3341 root 24226
reset isize for dir 324547 root 24226
reset isize for dir 297 root 24236
reset isize for dir 3341 root 24236
reset isize for dir 324547 root 24236
reset isize for dir 297 root 24246
reset isize for dir 3341 root 24246
reset isize for dir 324547 root 24246
reset isize for dir 297 root 24256
reset isize for dir 3341 root 24256
reset isize for dir 324547 root 24256
reset isize for dir 297 root 24266
reset isize for dir 3341 root 24266
reset isize for dir 324547 root 24266
reset isize for dir 297 root 24276
reset isize for dir 3341 root 24276
reset isize for dir 324547 root 24276
reset isize for dir 297 root 24286
reset isize for dir 3341 root 24286
reset isize for dir 324547 root 24286
found 109036361594 bytes used err is 0
total csum bytes: 217231860
total tree bytes: 4010762240
total fs tree bytes: 3494297600
total extent tree bytes: 225533952
btree space waste bytes: 802318016
file data blocks allocated: 631026987008
 referenced 360137048064
Btrfs v3.18.2

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

