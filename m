Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:52569 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaLAFmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 00:42:44 -0500
Date: Mon, 1 Dec 2014 10:42:36 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Gour <gour@atmarama.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: pro/cons of raid1 with mdadm/lvm2
Message-ID: <20141201104236.1506b0a9@natsu>
In-Reply-To: <20141130121147.45884217@atmarama>
References: <20141130121147.45884217@atmarama>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 30 Nov 2014 12:11:47 +0100
Gour <gour@atmarama.net> wrote:

> However, I wonder if there are some 'cons' in having raid-1 partition
> under mdadm and not using native mirroring capabilities of btrfs fs?

Pros:

  * mdadm RAID has much better read balancing;
    Btrfs reads are satisfied from what's in effect a random drive (PID-based
    balancing of threads to drives), mdadm reads from the less-loaded drive.
    Also mdadm has a way to specify some RAID1 array members as to be never
    used for reads if at all possible ("write-mostly"), which helps in RAID1 of
    HDD and SSD.

  * mdadm RAID has much better write submission;
    In my experience [1] Btrfs RAID1 on heavy write operations first writes to
    one drive, then to another. The whole process takes up to 2x longer than
    with a single drive. On the other hand mdadm writes to both drives
    simultaneously.

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg34103.html

Con:

  * You only get the ability to recover from a checksum failure with Btrfs
    RAID1, not with mdadm RAID1 (see Russell's reply).

-- 
With respect,
Roman
