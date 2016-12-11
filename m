Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36320 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbcLKRkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 12:40:08 -0500
Received: by mail-wm0-f51.google.com with SMTP id g23so31789850wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 09:40:07 -0800 (PST)
MIME-Version: 1.0
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Sun, 11 Dec 2016 17:40:06 +0000
Message-ID: <CAKinxcV8tPF_y5HoU_DVy88rfHaGwzFrzQjSiQCcFM71H+a+Gw@mail.gmail.com>
Subject: How to get back a deleted sub-volume.
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

So, I've found my self in a pickle after following this steps:
1. trying to migrate an array to different system, it became apparent
that importing array there was not possible to import it because I've
had a very large amount of snapshots (every 15 minutes during office
hours amounting to few K) so I've had to remove snapshots for main
data storage.
2. while playing with live array, it become apparent that some bright
spark implemented a "delete all sub-volumes while removing array from
system" ... needles to say that this behaviour is unexpected to say al
least ... and I wanted to punch somebody in face.
3. the backup off-site server that was making backups every 30 minutes
was located in CEO house and his wife decide that it's not necessary
to have it connected

(laughs can start roughly here)

So I've got array with all the data there (theoretically COW, right ?)
with additional of plethora of snapshots (important data was snapped
every 15 minutes during a office hours to capture all the changes,
other sub-volumes were snapshoted daily)

This occurred roughly on 4-12-2016.

Since then I was trying to rescue as much data as I can, luckily I
managed to get a lot of data from snapshots for "other than share"
volumes (because those were not deleted :/) but the most important
volume "share" prove difficult. This subvolume comes out with a lot of
errors on readout with "btrfs restore /dev/sda /mnt2/temp2/ -x -m -S
-s -i -t".

Also for some reason I can't use a lot of root blocks that I find with
btrfs-find-root ..

To put some detail here:
btrfs-find-root -a /dev/sda
Superblock thinks the generation is 184540
Superblock thinks the level is 1
Well block 919363862528(gen: 184540 level: 1) seems good, and it
matches superblock
Well block 919356325888(gen: 184539 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919343529984(gen: 184538 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920041308160(gen: 184537 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919941955584(gen: 184536 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919670538240(gen: 184535 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920045371392(gen: 184532 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920070209536(gen: 184531 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920117510144(gen: 184530 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1 <<<---- here
stuff is gone
Well block 920139055104(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920139022336(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920138989568(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920138973184(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920137596928(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920137531392(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920137515008(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920135991296(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920135958528(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920135925760(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920135827456(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920135811072(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920133697536(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920133664768(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920133337088(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920133206016(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920132976640(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920132878336(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920132845568(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920128045056(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920127946752(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920127897600(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920127881216(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920127864832(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920127848448(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 920127799296(gen: 184511 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919815143424(gen: 184508 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919814569984(gen: 184508 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919811866624(gen: 184508 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919803232256(gen: 184496 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919712989184(gen: 184455 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919711891456(gen: 184455 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919706271744(gen: 184455 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919703568384(gen: 184455 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919699865600(gen: 184455 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 919647092736(gen: 184455 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417026879488(gen: 184334 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1 <<--- I can
only use that with btrfs restore and it's month old
Well block 1417025896448(gen: 184333 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417029484544(gen: 184332 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417029320704(gen: 184332 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417029173248(gen: 184332 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417027616768(gen: 184332 level: 0) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417024831488(gen: 184331 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417021079552(gen: 184330 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417014001664(gen: 184329 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417011970048(gen: 184328 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
Well block 1417009758208(gen: 184327 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level:
... rest of lines omitted to not trash the list to much.

this line:
Well block 920117510144(gen: 184530 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
is where stuff is missing,

and this line:
Well block 1417026879488(gen: 184334 level: 1) seems good, but
generation/level doesn't match, want gen: 184540 level: 1
is the only line that physically work with
btrfs restore /dev/sda /mnt2/temp2/ -x -m -S -s -i -t


as you can see there is a vast "generation hole" between 184530 and
184334 ... more 200 generations ... and this results in only being
able to access data that is month old :( and some of it is strangelly
corrupted :(
