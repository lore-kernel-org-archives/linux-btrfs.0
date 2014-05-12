Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:56461 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaELM1e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 08:27:34 -0400
Received: by mail-ve0-f170.google.com with SMTP id db11so8626577veb.15
        for <linux-btrfs@vger.kernel.org>; Mon, 12 May 2014 05:27:33 -0700 (PDT)
MIME-Version: 1.0
From: Scott Middleton <scott@assuretek.com.au>
Date: Mon, 12 May 2014 20:27:13 +0800
Message-ID: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
Subject: send/receive and bedup
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Everyone

History:
I just recently discovered BtrFS. Well really only just started
reading a lot about it. Starting with blogs by Jim Salters and Marc
Merlin. So, thanks for those blogs guys.

This also introduced me to ZoL (ZFS). It seemed a bit more stable but
one of the features I really wanted was deduplication and needing 20GB
RAM for 1TB of deduped data and the fact it is always on - pushed me
away. Some of those guys really don't like BtrFS BTW!

What I want to be able to do is backup Virtual images (VirtualBox and
some older VMware) over ADSL. I hoped a mixture of Dedupe and the
send/receive functions of BtrFS might accomplish this.

I am in the process of building a test BtrFS system at home now but I
hope to put it into production in the next few months.


Current server is a Dual Xeon, Intel server board, 32GB RAM, 2 x 2TB
Hardware RAID SAS (consisting of 4 x 2TB SATA drives) as / and /home
in ext4 format. I also have 2 unused 4TB SATA drives that will be
eventually be BtrFS RAID1 as /Backup. Ubuntu 14.04. Its is mainly a VM
host, small file storage for word docs etc, some large archival .pst
files and shadowprotect backups of the Terminal Server. I only just
built this server over the last weekend to replace their other aging
server and I purposely over engineered it.

Onsite there is also a backup server that is pretty basic with 2 x 4TB
HDDs and 8GB RAM. I plan on converting it to BtrFS as well. Currently
is Ubuntu 12.04 but I will be upgrading it soon to 14.04.

Offsite in a data centre I have an aging 1 RU server that I will be
upgrading. It'll probably have 8GB RAM, 1 X 60GB SSD as boot/swap and
2 X 4TB HDD BtrFS in RAID 1. Currently running 32 bit Debian 7.5. It
has had many partial hardware and OS upgrades over the years as it
originally started as Slink or even Hamm. Time to start again since I
need to move to 64bit.

What I want to do is backup the / and /home directories on the main
server to /Backup BtrFS directory, run bedup then "send" it to the
onsite backup server. The onsite backup server will "send" it to the
offsite server. I am assuming (correctly I hope) that the
deduplication will also be replicated across the machines.  I'll have
NOCOW on the VM images, Archived PST files, Shadow protect images and
some other stuff.

I guess the first question is this even possible? I don't believe that
much actual non duplicated data changes all that much mostly just word
docs that I already send offsite. I'm really hoping to backup the VMs
and the shadow protects offsite as well. I can  upgrade the broadband
to fibre but before I do that (spend a lot of money) I want to be able
to see that it would be possible.


Kind Regards

-
Scott
