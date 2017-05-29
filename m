Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36075 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdE2DmL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 23:42:11 -0400
Received: by mail-qk0-f178.google.com with SMTP id u75so39951535qka.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 20:42:11 -0700 (PDT)
MIME-Version: 1.0
From: "Wael M. Nasreddine" <wael.nasreddine@gmail.com>
Date: Sun, 28 May 2017 20:41:50 -0700
Message-ID: <CA+kKtKA_MHaejLnNsR15Hy+WG6=9civcBOoWf0Me4QDcfy7WVQ@mail.gmail.com>
Subject: btrfs-progs 4.11 broke snap-sync
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I use Arch, the system is entirely on btrfs (on a LUKS partition). I
use snap-sync[0] to sync snapshots to an external drive. When 4.11
came out, snap-sync errors out with the message: ERROR: unable to
resolve -c.

Reverting back to 4.10 fixed the issue. I'm using kernel 4.9.29-lts
and the problem has also been confirmed with kernel 4.11 zen.

Please find the bug filed against snap-sync at [1]

Should I file a bug for this? Is this even a bug or a breaking change?

Thanks,

Wael

[0]: https://github.com/wesbarnett/snap-sync
[1]: https://github.com/wesbarnett/snap-sync/issues/32

Exerpt from [1]:

[arch@arch ~]$ sudo snap-sync -n
[sudo] password for arch:
Select a mounted BTRFS device to backup to.
   1) c91384af-f210-48f5-ba19-d6415a1bb447 (/)
   2) c91384af-f210-48f5-ba19-d6415a1bb447 (/hackallthethings)
   3) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/tmp)
   4) c91384af-f210-48f5-ba19-d6415a1bb447 (/data)
   5) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/abs)
   6) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/log)
   7) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/cache/pacman/pkg)
   8) c91384af-f210-48f5-ba19-d6415a1bb447 (/home)
   9) c91384af-f210-48f5-ba19-d6415a1bb447 (/.snapshots)
  10) c91384af-f210-48f5-ba19-d6415a1bb447 (/srv)
  11) c91384af-f210-48f5-ba19-d6415a1bb447 (/home/arch/hackallthethings)
  12) c91384af-f210-48f5-ba19-d6415a1bb447 (/home/arch/.local/share/Steam)
  13) e5b8a2d6-85a1-4640-a659-acb8d6922bd6
(/run/media/arch/e5b8a2d6-85a1-4640-a659-acb8d6922bd6)
   0) Exit
Enter a number: 13

You selected the disk with UUID e5b8a2d6-85a1-4640-a659-acb8d6922bd6.
The disk is mounted at /run/media/arch/e5b8a2d6-85a1-4640-a659-acb8d6922bd6.

Creating new snapshot for root...
Will backup //.snapshots/4641/snapshot to
/run/media/arch/e5b8a2d6-85a1-4640-a659-acb8d6922bd6/backup/E744/root/4641//snapshot
Sending incremental snapshot for root...
ERROR: unable to resolve -c


-- 
Wael Nasreddine | VP Engineering at Publica | (650) 933-3448
