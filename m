Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.sigma-it.ru ([212.65.87.1]:36557 "EHLO mail.sigma-it.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752590AbcKCMWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 08:22:13 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.sigma-it.ru (Postfix) with ESMTP id D1B81B2F32
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Nov 2016 15:22:09 +0300 (MSK)
Received: from mail.sigma-it.ru ([127.0.0.1])
        by localhost (mail.sigma-it.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E0yoR99tkO-Y for <linux-btrfs@vger.kernel.org>;
        Thu,  3 Nov 2016 15:22:09 +0300 (MSK)
Received: from SIGMA02988 (unknown [10.196.7.39])
        by mail.sigma-it.ru (Postfix) with ESMTP id B84E2B2F31
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Nov 2016 15:22:09 +0300 (MSK)
From: =?koi8-r?B?5M3J1NLJyiDuxd7Bxdc=?= <d.nechaev@sigma-it.ru>
To: <linux-btrfs@vger.kernel.org>
Subject: Problem with btrfs snapshots
Date: Thu, 3 Nov 2016 15:22:09 +0300
Message-ID: <053201d235cc$e62439e0$b26cada0$@sigma-it.ru>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="koi8-r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello.
We are have a strange situation with btrfs snapshot. We have a special
script to create snapshot and if we create several snapshots in the same
time we get ENOSPC error. But if we create snapshots one after another with
a little pause between (about 10 minutes), then everything looks ok.
Is there any command to determine that it is safe to make another snapshot?

# uname -a
Linux OraCI2.sigma-it.local 4.8.4-1.el7.elrepo.x86_64 #1 SMP Sat Oct 22
11:47:38 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
btrfs-progs v4.8.1
# btrfs fi show
Label: 'BUILDS'  uuid: ce8952ff-30e5-48c5-8cd2-529c95667aa8
        Total devices 1 FS bytes used 356.82GiB
        devid    1 size 1000.00GiB used 383.00GiB path /dev/nvme0n1p1

Label: none  uuid: a712598d-cc4f-4dc5-bdfb-de7ae432b109
        Total devices 1 FS bytes used 4.71TiB
        devid    1 size 7.66TiB used 4.96TiB path
/dev/mapper/OraCI2-docker--data

Label: none  uuid: 89c0495f-ed26-4d66-b83b-ffb5882bd082
        Total devices 1 FS bytes used 880.43GiB
        devid    1 size 1.93TiB used 913.01GiB path /dev/nvme0n1p2
# btrfs fi df /var/lib/docker/db/STANDS
Data, single: total=4.89TiB, used=4.68TiB
System, DUP: total=8.00MiB, used=592.00KiB
Metadata, DUP: total=35.00GiB, used=26.29GiB
GlobalReserve, single: total=512.00MiB, used=4.41MiB

Best regards,
Dmitry Nechaev

С уважением,
Дмитрий Нечаев,
Ведущий инженер Группы сетевого и системного администрирования Отдела
системной интеграции  ООО "СИГМА"
Тел: +7 812 602 27 72 доб. 158
Факс: +7 812 602 2770
e-mail: d.nechaev@sigma-it.ru



