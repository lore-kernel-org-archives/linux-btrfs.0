Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35346 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcDRTgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 15:36:47 -0400
Received: by mail-lf0-f53.google.com with SMTP id c126so229452932lfb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 12:36:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGqMYTE+Ev5CjJBLMq0beg1tOP2J1RsTZz5mB9rE-WZ8rLXeA@mail.gmail.com>
References: <CAEtw4r0EDazr3755UBr0XvNsExQ5bn0aKg2B0YPPLTixwa1sPQ@mail.gmail.com>
	<CAGGqMYTE+Ev5CjJBLMq0beg1tOP2J1RsTZz5mB9rE-WZ8rLXeA@mail.gmail.com>
Date: Mon, 18 Apr 2016 21:36:45 +0200
Message-ID: <CAEtw4r0WWrS=_z1371MnnCXu2Ct7sjZfbKa76c0gRvPE0cqBjw@mail.gmail.com>
Subject: Re: btrfs filesystem du - Failed to lookup root id - Inappropriate
 ioctl for device
From: Peter Becker <floyd.net@gmail.com>
To: Alexander Fougner <fougner89@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the same environment, update to btrfs-progs 4.5.1, new errors in "fi du"

$ sudo btrfs fi du /media/RAID/owncloud/
 140.00KiB       0.00B           -
/media/RAID/owncloud//.snapshot/weekly_2016-03-26_07:56:42/docker/postgres
 264.00KiB       0.00B           -
/media/RAID/owncloud//.snapshot/weekly_2016-03-26_07:56:42/docker
     0.00B       0.00B           -
/media/RAID/owncloud//.snapshot/weekly_2016-03-26_07:56:42/owncloud.service
     0.00B       0.00B           -
/media/RAID/owncloud//.snapshot/weekly_2016-03-26_07:56:42/owncloud.setup.txt
...
ERROR: Failed to lookup root id - Inappropriate ioctl for device
ERROR: cannot check space of '/media/RAID/owncloud/': Unknown error -1


$ sudo btrfs fi du /media/RAID/apps
    Total   Exclusive  Set shared  Filename
500.00KiB       0.00B           -  /media/RAID//apps/Drive Snapshot
167.96MiB       0.00B           -  /media/RAID//apps/vmware
.. [46 rows] ..
ERROR: Failed to lookup root id - Inappropriate ioctl for device
ERROR: cannot check space of '/media/RAID/owncloud/': Unknown error -1
