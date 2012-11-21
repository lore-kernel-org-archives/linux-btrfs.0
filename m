Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.ensi-bourges.fr ([195.221.38.25]:40514 "EHLO
	ensi-bourges.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755090Ab2KUPR7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Nov 2012 10:17:59 -0500
Received: from unknown (HELO webmail.ensi-bourges.fr) (Authenticated_user:frantz.hacquard@[195.221.38.6])
          (envelope-sender <frantz.hacquard@ensi-bourges.fr>)
          by mail.ensi-bourges.fr (qmail-ldap-1.03) with SMTP
          for <linux-btrfs@vger.kernel.org>; 21 Nov 2012 15:16:56 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 21 Nov 2012 16:17:57 +0100
From: "frantz.hacquard" <frantz.hacquard@ensi-bourges.fr>
To: <linux-btrfs@vger.kernel.org>
Subject: unable to mount a btrfs partition
Message-ID: <fa93207c7d636e263d8c2d6ebc2a3bed@ensi-bourges.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i don't know if it's the right place to post my problem.

yesterday my btrfs partition (/dev/sda4) worked very well but now i 
can't mount my btrfs partition anymore.
it says : wrong fs type, bad option, bad superblock on /dev/sda4, 
missing codepage ...

i know btrfs is still in developement, but i would try to recover a 
file on this partition.
i tried many options of mount (-t btrfs -o recovery -o degraded...) but 
it's always the same issue.

i tried many commands in order to recover my file, but nothing seems to 
work :

>btrfs device scan
  failed to read /dev/sr0

>btrfs-show
  failed to read /dev/sr0
  label : none uuid : 79995074....
  total devices 1 FS bytes useg 4GB
  devid 1 size 60GB used 8GB path /dev/sda4

>btrfsck /dev/sda4
  parent transid verify failed on ... wanted ... found ...
  ignoring transid failure
  leaf parent key incorrect ...
  ...
  btrfsck.c: check_owner_ref : assertion '!(rec->is_root)' failed
  aborted

>btrfs-select-super -s 1 /dev/sda4 (also tried -s 0 and -s 2)
  using SB copy 1, bytenr 67...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  ignoring transid failure

>btrfs-zero-log /dev/sda4
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  ignoring transid failure
  ...

>btrfs-restore /dev/sda4 /mnt/test
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  ignoring transid failure
  root objectid is 5
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  parent transid verify failed on ... wanted ... found ...
  ignoring transid failure

is there a way to recover my file ? (/root/scripts/test.sh)

thanks for help.

