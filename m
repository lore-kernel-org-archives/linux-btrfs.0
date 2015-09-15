Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:53892 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbbIOObF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 10:31:05 -0400
Received: from [192.168.11.16] (vpn1 [213.131.255.219])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jojo@automatix.de)
	by mail.automatix.de (Postfix) with ESMTPSA id 483AD6005E
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 16:22:09 +0200 (CEST)
From: Juergen Sauer <juergen.sauer@automatix.de>
Subject: Recovery possible on asynchronous transid ?
Reply-To: service@automatix.de
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <55F82990.5050403@automatix.de>
Date: Tue, 15 Sep 2015 16:22:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Due an hibernation event my BTRFS Raid56 failed and is not mountable
anymore. :(

For Debugging I moved the Devices to an test-hardware and booted this
system from an Arch Linux ISO, which I created for this purpose.

The Problem is:
[ 1086.714109] BTRFS (device sdd1): parent transid verify failed on
209362944 wanted 293924 found 293922

Is there any posibility to recover any files from this desaster?
Is there any posibiolity to set the superblock to transid #293922 ?

See my tries to recover here as konsole log below.




---------x----------x-----------x------------------x--------------
BTRFS Tools Version: btrfs-progs v4.2

Kernel: Linux archiso 4.1.6-1-ARCH #1 SMP PREEMPT Mon Aug 17 08:52:28
CEST 2015 x86_64 GNU/Linux

btrfs show
Label: 'archiv'  uuid: 48f71e09-6898-4665-bc61-bd7ca4ba4a24
	Total devices 4 FS bytes used 3.35TiB
	devid    1 size 1.70TiB used 726.69GiB path /dev/sdc3
	devid    2 size 1.82TiB used 1.35TiB path /dev/sdb1
	devid    3 size 1.82TiB used 1.35TiB path /dev/sda1
	devid    4 size 1.82TiB used 1.35TiB path /dev/sdd1

mount LABEL=archiv /mnt -o degraded,ro
# dmesg
[ 1086.691246] BTRFS info (device sdd1): allowing degraded mounts
[ 1086.691251] BTRFS info (device sdd1): disk space caching is enabled
[ 1086.714109] BTRFS (device sdd1): parent transid verify failed on
209362944 wanted 293924 found 293922
[ 1086.752227] BTRFS (device sdd1): parent transid verify failed on
244719616 wanted 293924 found 293922
[ 1086.754377] BTRFS: bdev /dev/sdb1 errs: wr 3, rd 0, flush 1, corrupt
0, gen 0
[ 1086.754676] BTRFS (device sdd1): parent transid verify failed on
209375232 wanted 293924 found 293914
[ 1086.770626] BTRFS (device sdd1): parent transid verify failed on
245538816 wanted 293924 found 293922
[ 1086.912646] BTRFS (device sdd1): parent transid verify failed on
253378560 wanted 293924 found 293914
[ 1086.942088] BTRFS (device sdd1): parent transid verify failed on
253390848 wanted 293924 found 293914
[ 1086.944003] BTRFS (device sdd1): parent transid verify failed on
253403136 wanted 293924 found 293914
[ 1087.262500] BTRFS (device sdd1): parent transid verify failed on
253911040 wanted 293924 found 293914
[ 1087.264800] BTRFS (device sdd1): bad tree block start 0 253911040
[ 1087.266442] BTRFS: Failed to read block groups: -5
[ 1087.315127] BTRFS: open_ctree failed

# btrfs-find-root /dev/sda1
Superblock thinks the generation is 293924
Superblock thinks the level is 2
Found tree root at 244273152 gen 293924 level 2
Well block 238604288(gen: 293923 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199577600(gen: 293922 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199786496(gen: 293921 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199925760(gen: 293919 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 209240064(gen: 293914 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 182116352(gen: 293913 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 179388416(gen: 293912 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 238559232(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 237764608(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 175108096(gen: 293910 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 74981376(gen: 293909 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156815360(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156807168(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156803072(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156688384(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 153407488(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149504000(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149499904(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149078016(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149073920(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 147288064(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 107081728(gen: 293907 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61517824(gen: 293906 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 63414272(gen: 293905 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 100290560(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61906944(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 99393536(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 79740928(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 47403008(gen: 293901 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 42622976(gen: 293899 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 40329216(gen: 293898 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 38137856(gen: 293897 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 36515840(gen: 293896 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922

# btrfs-find-root /dev/sdb1
Ignoring transid failure
Superblock thinks the generation is 293924
Superblock thinks the level is 2
Found tree root at 244273152 gen 293924 level 2
Well block 238604288(gen: 293923 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199577600(gen: 293922 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199786496(gen: 293921 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199925760(gen: 293919 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 209240064(gen: 293914 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 182116352(gen: 293913 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 179388416(gen: 293912 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 238559232(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 237764608(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 175108096(gen: 293910 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 74981376(gen: 293909 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156815360(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156807168(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156803072(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156688384(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 153407488(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149504000(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149499904(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149078016(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149073920(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 147288064(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 107081728(gen: 293907 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61517824(gen: 293906 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 63414272(gen: 293905 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 100290560(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61906944(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 99393536(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 79740928(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 47403008(gen: 293901 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 42622976(gen: 293899 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 40329216(gen: 293898 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 38137856(gen: 293897 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 36515840(gen: 293896 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922

# btrfs-find-root /dev/sdc3
Ignoring transid failure
Superblock thinks the generation is 293924
Superblock thinks the level is 2
Found tree root at 244273152 gen 293924 level 2
Well block 238604288(gen: 293923 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199577600(gen: 293922 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199786496(gen: 293921 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199925760(gen: 293919 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 209240064(gen: 293914 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 182116352(gen: 293913 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 179388416(gen: 293912 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 238559232(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 237764608(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 175108096(gen: 293910 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 74981376(gen: 293909 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156815360(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156807168(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156803072(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156688384(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 153407488(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149504000(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149499904(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149078016(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149073920(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 147288064(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 107081728(gen: 293907 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61517824(gen: 293906 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 63414272(gen: 293905 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 100290560(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61906944(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 99393536(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 79740928(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 47403008(gen: 293901 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 42622976(gen: 293899 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 40329216(gen: 293898 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 38137856(gen: 293897 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 36515840(gen: 293896 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
Ignoring transid failure

# btrfs-find-root /dev/sdd1
Superblock thinks the generation is 293924
Superblock thinks the level is 2
Found tree root at 244273152 gen 293924 level 2
Well block 238604288(gen: 293923 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199577600(gen: 293922 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199786496(gen: 293921 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199925760(gen: 293919 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 209240064(gen: 293914 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 182116352(gen: 293913 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 179388416(gen: 293912 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 238559232(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 237764608(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 175108096(gen: 293910 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 74981376(gen: 293909 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156815360(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156807168(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156803072(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156688384(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 153407488(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149504000(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149499904(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149078016(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149073920(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 147288064(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 107081728(gen: 293907 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61517824(gen: 293906 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 63414272(gen: 293905 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 100290560(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61906944(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 99393536(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 79740928(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 47403008(gen: 293901 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 42622976(gen: 293899 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 40329216(gen: 293898 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 38137856(gen: 293897 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 36515840(gen: 293896 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
Ignoring transid failure
Superblock thinks the generation is 293924
Superblock thinks the level is 2
Found tree root at 244273152 gen 293924 level 2
Well block 238604288(gen: 293923 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199577600(gen: 293922 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199786496(gen: 293921 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 199925760(gen: 293919 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 209240064(gen: 293914 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 182116352(gen: 293913 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 179388416(gen: 293912 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 238559232(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 237764608(gen: 293911 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 175108096(gen: 293910 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 74981376(gen: 293909 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156815360(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156807168(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156803072(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 156688384(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 153407488(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149504000(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149499904(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149078016(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 149073920(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 147288064(gen: 293908 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 107081728(gen: 293907 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61517824(gen: 293906 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 63414272(gen: 293905 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 100290560(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 61906944(gen: 293904 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 99393536(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 79740928(gen: 293903 level: 0) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 47403008(gen: 293901 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 42622976(gen: 293899 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 40329216(gen: 293898 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 38137856(gen: 293897 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
Well block 36515840(gen: 293896 level: 2) seems good, but
generation/level doesn't match, want gen: 293924 level: 2
---------x----------x-----------x------------------x--------------

Thanks in advance


mit freundlichen Grüßen
Jürgen Sauer
-- 
Jürgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Geschäftsführer: Jürgen Sauer,
Gerichtstand: Amtsgericht Walsrode • HRB 120986
Ust-Id: DE191468481 • St.Nr.: 36/211/08000
GPG Public Key zur Signaturprüfung:
http://www.automatix.de/juergen_sauer_publickey.gpg

