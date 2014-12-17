Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48624 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaLQPJB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 10:09:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y1GDf-0001Fq-Uf
	for linux-btrfs@vger.kernel.org; Wed, 17 Dec 2014 16:08:55 +0100
Received: from p4ff585d0.dip0.t-ipconnect.de ([79.245.133.208])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 16:08:50 +0100
Received: from holger.hoffstaette by p4ff585d0.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 16:08:50 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [RFC][BTRFS-PROGS] Improve output of mkfs.btrfs command
Date: Wed, 17 Dec 2014 15:08:38 +0000 (UTC)
Message-ID: <pan.2014.12.17.15.08.38@googlemail.com>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 15 Dec 2014 21:02:53 +0100, Goffredo Baroncelli wrote:

> enclosed a patches set to improve the output of mkfs.btrfs command.

This is very nice! I do have a comment about the device list:

> ..
>     UUID                                  ID    SIZE    PATH
>     ------------------------------------  --  --------- -----------
>     62121322-5666-4ecf-bc8e-c9b3d9f60db9   1   50.00GiB /dev/vdb
>     6158cb13-3ae8-42b6-8603-660f1e5c8a7a   2   50.00GiB /dev/vdc
>     b49516db-ddf5-4f54-8831-a4babc79e901   3   50.00GiB /dev/vdd
>     00b03d81-7d29-4894-8050-9dd205f97c41   4   50.00GiB /dev/vde
>     f119a2ec-5ef0-436c-805e-c1b0612b05ca   5   50.00GiB /dev/vdf
>     adee4f58-e094-4bd4-8c56-941527524f8d   6   50.00GiB /dev/vdg
>     a8299171-2024-4057-ba56-1f83bf6d7e2e   7   50.00GiB /dev/vdh
>     b694e275-e454-4dbd-beb0-e33c388cffa2   8    2.00GiB /dev/vdi
>     7cbe04b5-36cd-4ea7-be82-206d5487914e   9    2.00GiB /dev/vdj
>     7c320654-675e-456b-ac23-cfb148b8ea57  10    2.00GiB /dev/vdk
> 
>   Total disks size:                           356.01GiB

I'm not sure how others feel about this, but the first column of UUIDs
contains almost no human-usable information (who remembers UUIDs?) but
takes up a huge chunk of the screen real estate. I'd suggest to reorder
the columns to be something like (ID, Size, Path, UUID). This puts more
relevant information in reading-order.

I hope this isn't too much to ask :)

thanks
Holger

