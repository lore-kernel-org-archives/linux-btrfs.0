Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:33714 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbbHKT55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 15:57:57 -0400
Received: by vkbc123 with SMTP id c123so26102433vkb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 12:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU_xV=2Mh0zj6c3Wj54HDi0vCWmon-Z9E6h14hGws2-YAg@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAK7bmU_xV=2Mh0zj6c3Wj54HDi0vCWmon-Z9E6h14hGws2-YAg@mail.gmail.com>
Date: Tue, 11 Aug 2015 13:57:55 -0600
Message-ID: <CAJCQCtQ2L=s2KP8ttLkeA+pnOqePvToK-evsc9nA43Ewv3GgEw@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 12:04 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=102691

[    7.729124] BTRFS: device fsid ecdff84d-b4a2-4286-a1c1-cd7e5396901c
devid 2 transid 226237 /dev/sdd
[    7.746115] BTRFS: device fsid ecdff84d-b4a2-4286-a1c1-cd7e5396901c
devid 4 transid 226237 /dev/sdb
[    7.826493] BTRFS: device fsid ecdff84d-b4a2-4286-a1c1-cd7e5396901c
devid 3 transid 226237 /dev/sdc

What do you get for 'btrfs fi show'

I see devid 2, 3, 4 only for this volume UUID. So you definitely
appear to have a failed device and that's why it doesn't mount
automatically at boot time. You just need to use -o degraded, and that
should work assuming no problems with the other three devices. If it
does work, 'btrfs replace start...' is the ideal way to replace the
failed drive.

Maybe someone else can say whether nodatacow as a subvolume mount
option will apply this to the entire volume.

-- 
Chris Murphy
