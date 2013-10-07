Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37923 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3JGLpa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 07:45:30 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so7012370pdj.40
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 04:45:29 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Oct 2013 13:45:29 +0200
Message-ID: <CAFirYm_jn=O50=aOvRswBJio3f37xOY-BLeXTzfzHzRKzX3wrQ@mail.gmail.com>
Subject: Some questions after devices addition to existing raid 1 btrfs filesystem
From: Laurent Humblet <laurent.humblet@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have added 2x2Tb to my existing 2x2Tb raid 1 btrfs filesystem and
then ran a balance:

# btrfs filesystem show
        Total devices 4 FS bytes used 1.74TB
        devid    3 size 1.82TB used 0.00 path /dev/sdd
        devid    4 size 1.82TB used 0.00 path /dev/sde
        devid    2 size 1.82TB used 1.75TB path /dev/sdc
        devid    1 size 1.82TB used 1.75TB path /dev/sdb
# btrfs filesystem balance btrfs_root/
# btrfs filesystem show
        Total devices 4 FS bytes used 1.74TB
        devid    3 size 1.82TB used 892.00GB path /dev/sdd
        devid    4 size 1.82TB used 892.00GB path /dev/sde
        devid    2 size 1.82TB used 891.03GB path /dev/sdc
        devid    1 size 1.82TB used 891.04GB path /dev/sdb

It took 59 hours to complete the balance.

I checked on a couple of files and all seems fine but I have some questions:
- is there some kind of 'overall filesystem health/integrity check'
that I should do on the filesystem now that the balance is done?
- also, I ran the command while some of the btrfs subvolumes were
mounted (as well as the btrfs_root/ of course), does this impact on
the balance job?
- the mounted btrfs devices were mounted using -o
space_cache,inode_cache but the btrfs_root/ was not, also, does this
impact on the balance job?
- about those options, a few months ago, I oftent had
btrfs-cache-1/btrfs-endio-met processes taking some cpu/hd time.  I
was advised to mount -o space_cache,inode_cache, which seems to have
quiet the processes down.  Are those options still necessary now?
- as the job took 60+ hours but the CPU rarely went above 10%, the
computer seemed still usable.  I left it do its job of course but
could I have accessed or write anything on the subvolumes while the
balance was running and if yes, would this have any impact on the
filesystem?

Thank you for your help,
All the best,
Laurent
