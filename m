Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37579 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaJJNfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 09:35:09 -0400
Received: by mail-pd0-f172.google.com with SMTP id ft15so1683379pdb.31
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 06:35:09 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
Content-Type: text/plain; charset=GB2312
Subject: Problems running Balance and checking integrity concurrently.
Date: Fri, 10 Oct 2014 21:35:02 +0800
Message-Id: <5BE1151D-599F-4FD4-BD6B-AC707C72CEC4@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, clm@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
To: sbehrens@giantdisaster.de
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello£¬

I have reproduced a problem with Btrfs integrity and balance using latest
btrfs kernel,it is very easy to reproduce:

With mount option ¡°check_int¡±, and run xfstests/btrfs/ tests, below test could definitely
reproduce problem:

./check tests/btrfs/014

5.122248] Written block @25800343552 (sdc/1210187776/0) found in hash table, M, bytenr mismatch (!= stored 20968505344).
[  455.122283] Written block @25800359936 (sdc/1210204160/1) found in hash table, M, bytenr mismatch (!= stored 20968521728).
[  455.122301] Written block @25800376320 (sdc/1210220544/1) found in hash table, M, bytenr mismatch (!= stored 20968538112).
[  455.122347] Referenced block @25800343552 (sdc/1344405504/2) found in hash table, M, bytenr mismatch (!= stored 20968505344).
[  455.122427] Referenced block @25800359936 (sdc/1344421888/2) found in hash table, M, bytenr mismatch (!= stored 20968521728).
[  455.122853] Written block @25800376320 (sdc/1344438272/0) found in hash table, M, bytenr mismatch (!= stored 20968538112).
[  455.126275] BTRFS critical (device sdc): unable to find logical 3452043264 len 4096
[  455.126491] btrfsic: btrfsic_map_block(root @3452043264) failed!
[  455.126496] BTRFS critical (device sdc): unable to find logical 3452059648 len 4096
[  455.126769] btrfsic: btrfsic_map_block(root @3452059648) failed!
[  455.126773] BTRFS critical (device sdc): unable to find logical 3452076032 len 4096
[  455.127007] btrfsic: btrfsic_map_block(root @3452076032) failed!
[  455.127011] BTRFS critical (device sdc): unable to find logical 3452092416 len 4096
<snip>
[  455.129864] btrfsic: btrfsic_map_block(root @3452272640) failed!
[  455.129869] BTRFS critical (device sdc): unable to find logical 3452289024 len 4096
[  455.130113] btrfsic: btrfsic_map_block(root @3452289024) failed!
[  455.130756] BTRFS critical (device sdc): unable to find logical 3451994112 len 4096
[  455.130984] btrfsic: btrfsic_map_block(root @3451994112) failed!
[  455.130988] BTRFS critical (device sdc): unable to find logical 3452010496 len 4096
[  455.131192] btrfsic: btrfsic_map_block(root @3452010496) failed!
[  455.131195] BTRFS critical (device sdc): unable to find logical 3452026880 len 4096
[  455.131401] btrfsic: btrfsic_map_block(root @3452026880) failed!
[  455.131914] Written block @25800392704 (sdc/1210236928/0) found in hash table, M, bytenr mismatch (!= stored 20968554496).
[  455.131938] Referenced block @25800409088 (sdc/1210253312/1) found in hash table, M, bytenr mismatch (!= stored 20968570880).
[  455.131971] Referenced block @25800409088 (sdc/1344471040/2) found in hash table, M, bytenr mismatch (!= stored 20968570880).
[  455.132017] Referenced block @25800425472 (sdc/1210269696/1) found in hash table, M, bytenr mismatch (!= stored 20968587264).
[  455.132030] Referenced block @25800425472 (sdc/1344487424/2) found in hash table, M, bytenr mismatch (!= stored 20968587264).
[  455.132344] Written block @25800392704 (sdc/1344454656/0) found in hash table, M, bytenr mismatch (!= stored 20968554496

I supposed there are some race problems between integrity check and
Btrfs balance, could you guys please take a look at this issue!


Best Regards,
Wang Shilong

