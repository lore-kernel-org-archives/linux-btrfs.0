Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43526 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2LPX2E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 18:28:04 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5335414oag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Dec 2012 15:28:01 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 18:28:01 -0500
Message-ID: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
Subject: btrfs subvolume snapshot performance problem
From: Sylvain Alain <d2racing911@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone, I'm still have the problem with the snapshot command.

Here what I tested today :

read  writ|files  inodes
   0   408k| 2784   7264
   0   460k| 2784   7264
   0   496k| 2784   7264
   0   424k| 2784   7264
   0   440k| 2784   7264
   0  1280k| 2784   7264
   0   500k| 2784   7264
   0   592k| 2784   7264
   0   600k| 2784   7264
   0   568k| 2784   7264
   0   792k| 2784   7264
   0   756k| 2784   7264
   0   480k| 2784   7264
   0   592k| 2784   7264
   0   432k| 2784   7264
   0   544k| 2784   7264
   0   512k| 2784   7264
   0  2912k| 2784   7264
   0  3332k| 2784   7264
   0    40M| 2784   7264
   0    52M| 2784   7264
   0  1280k| 2784   7264
   0    69M| 2784   7264
-dsk/total- --filesystem-
 read  writ|files  inodes
   0  5584k| 2784   7264
   0   784k| 2784   7264
   0   624k| 2784   7264
   0   616k| 2784   7264
   0   744k| 2784   7264
   0   736k| 2784   7264
   0   652k| 2784   7264
   0   540k| 2784   7264
   0   752k| 2784   7264
   0   780k| 2784   7264
   0   888k| 2784   7264
   0   480k| 2784   7264
   0   504k| 2784   7264
   0   548k| 2784   7264
   0   892k| 2784   7264
   0   580k| 2784   7264
   0   576k| 2784   7264
   0   636k| 2784   7264
   0   544k| 2784   7264
   0   760k| 2784   7264
   0   752k| 2784   7264
   0   648k| 2784   7264
   0   744k| 2784   7264
-dsk/total- --filesystem-
 read  writ|files  inodes
   0   516k| 2784   7264
   0   608k| 2784   7264
   0   672k| 2784   7264
   0   524k| 2784   7264
   0   524k| 2784   7264
   0   520k| 2784   7264
   0   476k| 2784   7264
   0   520k| 2784   7264
   0   568k| 2784   7264
   0   520k| 2784   7264
   0   548k| 2784   7264
   0   616k| 2784   7264
   0   832k| 2784   7264
   0   824k| 2784   7264
   0   700k| 2784   7264
   0   864k| 2784   7264
   0  1208k| 2784   7264
   0  1064k| 2784   7264
   0   588k| 2784   7264
   0   688k| 2784   7264
   0    41M| 2784   7264
 308k   17M| 2784   7269
7488k  456k| 2784   7268
-dsk/total- --filesystem-
 read  writ|files  inodes
8192B  496k| 2784   7268 ^C

When the snapshot run, you see that the write change from K to M.

And now I have a good example for my problem :

gentootux ~ # mount /dev/sda4 -o
noatime,ssd,discard,compress=lzo,noacl,space_cache,subvolid=0
/mnt/disklayout/
gentootux ~ # cd /mnt/disklayout/
gentootux disklayout # ls
@backup  @racine
gentootux disklayout # time btrfs subvolume delete @backup
Delete subvolume '/mnt/disklayout/@backup'

real   0m0.005s
user   0m0.001s
sys   0m0.002s
gentootux disklayout # ls
@racine
gentootux disklayout # time btrfs subvolume snapshot @racine @backup
Create a snapshot of '@racine' in './@backup'

real   0m2.850s
user   0m0.000s
sys   0m0.010s
gentootux disklayout # ls
@backup  @racine
gentootux disklayout # time btrfs subvolume delete @backup
Delete subvolume '/mnt/disklayout/@backup'

real   0m0.001s
user   0m0.000s
sys   0m0.000s
gentootux disklayout # time btrfs subvolume snapshot @racine @backup
Create a snapshot of '@racine' in './@backup'

real   3m53.616s
user   0m0.000s
sys   0m0.299s

Instead of 3 secondes to run the snapshot, it took almost 4 minutes.

Is there any btrfs log that I could look at to detect the bottleneck ?

For the record, when this happens inside my Xfce desktop, if I try to
launch a terminal, nothing happen, it's like my PC freeze until the
snapshot is done.

Thanks !

--
Salut
alp
Sylvain
