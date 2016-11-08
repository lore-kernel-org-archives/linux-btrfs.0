Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:50398 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932607AbcKHLQA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 06:16:00 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Announcing btrfs-dedupe
Date: Tue, 08 Nov 2016 12:06:01 +0100
MIME-Version: 1.0
Message-ID: <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
In-Reply-To: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nice, you should probably update the btrfs wiki as well, because there is 
no mention of btrfs-dedupe.

First question, why this name? Don't you plan to support xfs as well?

Second question, I'm trying deduplication tools for the very first time and 
I still have to figure out how to handle snapper snapshots, which are read 
only. I currently tried duperemove 0.11 git and I get tons of "Error 30: 
Read-only file system while opening "/.../@snapshots/4385/...". How am I 
supposed to handle snapper snapshots?

I do not run duperemove from a live distro, instead I run it directly on 
the system I want to deduplicate:

sudo mount -o noatime,compress=lzo,autodefrag /dev/mapper/cryptroot 
/home/niko/nosnap/rootfs/
sudo duperemove -drh --dedupe-options=nofiemap 
--hashfile=/home/niko/nosnap/rootfs.hash /home/niko/nosnap/rootfs/

Is btrfs-dedupe able to handle snapper snapshots?

Thanks,
Niccolo' Belli
