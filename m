Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03B2C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C1720659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="EmRWv8Ig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfANLrS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:47:18 -0500
Received: from mail.virtall.com ([46.4.129.203]:43614 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfANLrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 06:47:17 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 705304956AC
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 11:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1547466434;
        bh=0JEZpn0C2pq07hGEaFwDT6NK4GlSQj5edZr4MepksSQ=;
        h=Date:From:To:Subject;
        b=EmRWv8IglpiuB6B8gYnbDnCyIydNpwG0nYO57GHRPk/EELQp49+PHjQUb6WZLkjqk
         WXEGlMUpfXoWJ3Mh9jgVSlk/QGBxrs6j4IddoagcjnKu23XA5QaDz5YmnxU2fbgkG/
         VUmhJKOiio8GFwZYE1tc+jp8D+4SMmUJoRX3ipHF9FBbuQy8GD3MoYHe66ZY4XokoZ
         6dxGlCv79vBlFUuZCTCyPfCJVFB0Ne4CHexDvTiC5Xf1Lh5tUqCDOMEY70jfvjLgG2
         oExG2lKmFyjkymTXRUUPDSDZ3Ah/FSrbcRKH2XZpm23H+aIiij2wOIE2iedD9xm3TB
         HoCYO6hYNbtog==
X-Fuglu-Suspect: 441aaf7bc3ad48288563abe441bcf13c
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 11:47:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 14 Jan 2019 20:47:14 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
Message-ID: <7c6234aaeaf813400da5ff1e68f8c898@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> When rebasing my qgroup + balance optimization patches, I found one 
> very
> obvious performance regression for balance.
> 
> For normal 4G subvolume, 16 snapshots, balance workload, v4.20 kernel
> only takes 3s to relocate a metadata block group, while for v5.0-rc1, I
> don't really know how it will take as it hasn't finished yet.

Are you sure it's v5.0-rc1 regression, not earlier?

I'm trying to do a metadata-only balance from RAID-5 to RAID-1, with 
4.19.8.

It was going relatively "normal", until it got stuck and showing no 
progress.

I've canceled the balance, upgraded to 4.20, started the balance again. 
For straight 11 days, it rewrote terabytes of data on the disks, with no 
progress at all. Also, 4.19.8 had a balance interrupted because of "out 
of space", despite we have terabytes free.

Metadata RAID-5 usage stays at 4.12GiB for the past 11 days (and a few 
more days with 4.19.8).



# btrfs fi usage /data
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
     Device size:                  14.47TiB
     Device allocated:            112.06GiB
     Device unallocated:           14.36TiB
     Device missing:                  0.00B
     Used:                        107.93GiB
     Free (estimated):                0.00B      (min: 8.00EiB)
     Data ratio:                       0.00
     Metadata ratio:                   1.64
     Global reserve:              512.00MiB      (used: 1.86MiB)

Data,RAID5: Size:5.28TiB, Used:3.04TiB
    /dev/sda5       1.76TiB
    /dev/sdb5       1.76TiB
    /dev/sdc5       1.76TiB
    /dev/sdd5       1.76TiB

Metadata,RAID1: Size:56.00GiB, Used:53.97GiB
    /dev/sda5      29.00GiB
    /dev/sdb5      27.00GiB
    /dev/sdc5      27.00GiB
    /dev/sdd5      29.00GiB

Metadata,RAID5: Size:12.38GiB, Used:11.13GiB
    /dev/sda5       4.12GiB
    /dev/sdb5       4.12GiB
    /dev/sdc5       4.12GiB
    /dev/sdd5       4.12GiB

System,RAID1: Size:32.00MiB, Used:416.00KiB
    /dev/sdb5      32.00MiB
    /dev/sdc5      32.00MiB

Unallocated:
    /dev/sda5       1.83TiB
    /dev/sdb5       1.83TiB
    /dev/sdc5       1.83TiB
    /dev/sdd5       1.83TiB


# btrfs balance status /data
Balance on '/data' is running
13 out of about 64 chunks balanced (15 considered),  80% left
