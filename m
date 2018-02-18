Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:39250 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbeBRIO1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Feb 2018 03:14:27 -0500
Received: by mail-wr0-f179.google.com with SMTP id w77so6669127wrc.6
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Feb 2018 00:14:27 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Sun, 18 Feb 2018 08:14:25 +0000
Message-ID: <CABB28Cw2+jYynXk1e+Lbx+4otsj5BLXucVV6W3+kvm3RDbH_AQ@mail.gmail.com>
Subject: 
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

For some reasons btrfs pool each volume is not displayed in mount and
df output, and I cannot find how to display volumes/snapshots usage
using btrfs command.
I'm looking for equivalent of the "zfs list -r -t [all|snapshot,filesystem]"
https://docs.oracle.com/cd/E23824_01/html/821-1448/gazsu.html#scrolltoc
Can someone help with exact command syntax?
As it is a quite basic function I think that some man page must be not
up-to-date or I'm looking at the wrong doc .. or I'm just blind :-/

Another question related to btrfs functionalities.
Is anyone working on the analog of zfs delegations?
https://docs.oracle.com/cd/E23824_01/html/821-1448/gbchv.html#scrolltoc

I'm using now btrfs quite intensively and I'm trying to use btrfs as
same way as I've been using for veeery long time zfs :-P
So now I have many volumes and snapshots in my home directory, but to
maintain all this I must use root permission. As non-root working in
my own home which is separated btrfs volume it would be nice to have
the possibility to delegate permission to create, destroy,
send/receive, mount/umount etc. snapshots, volumes like it os possible
on zfs.

BTW: someone maybe started working on something like .zfs hidden
directory functions which is in each zfs volume mountpoint?
Have few or few tenths snapshots is not so big deal but the same on
scale few hundreds, thousands or more snapshots I think that would be
really hard without something like hidden .btrfs/snapshots directory.
On zfs .zfs/snapshots directory is especially useful when the volume
is exported over for example NFS. With zfs volume exported over NFS on
NFS client is possible to do "mkdir .zfs/snapshot/my_snapshot" to
create the snapshot (even from NFS client working on Windows) or
"rmdir .zfs/snapshot/my_snapshot" to destroy snapshot from remote NFS
client system. All without login over for example ssh on NFS server.

And last question.
As Linux has now containers which provide most of the core Solaris
non-global zones functions it would be good to have as well equivalent
of the zfs zoned property.
https://docs.oracle.com/cd/E19253-01/819-5461/gbbre/index.html
Someone maybe started working on something like this for btrfs?

After few years not using btrfs (because previously was quite
unstable) It is really good to see that now I'm not able to crash it.
I must say "big thank you" to all those people involved in reaching
current state :)

kloczek

-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
