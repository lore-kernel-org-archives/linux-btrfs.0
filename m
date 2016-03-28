Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34370 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbcC1Cmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 22:42:42 -0400
Received: by mail-ig0-f171.google.com with SMTP id av4so44371585igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 19:42:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F7B77F.9050306@gmail.com>
References: <56F7B77F.9050306@gmail.com>
Date: Sun, 27 Mar 2016 20:42:41 -0600
Message-ID: <CAJCQCtScDuRdN_rtt2q=s-CcqBCER9XhsJ37O=nMAj51oBbHQQ@mail.gmail.com>
Subject: Re: Raid 0 setup doubt.
From: Chris Murphy <lists@colorremedies.com>
To: Jose Otero <jose.manuel.otero@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 27, 2016 at 4:35 AM, Jose Otero <jose.manuel.otero@gmail.com> wrote:
> Hello,
>
> --------------------------------------
> I apologize beforehand if I'm asking a too basic question for the
> mailing list, or if it has been already answered at nauseam.
> --------------------------------------
>
> I have two hdd (Western Digital 750 GB approx. 700 GiB each), and I
> planning to set up a RAID 0 through btrfs. UEFI firmware/boot, no dual
> boot, only linux.
>
> My question is, given the UEFI partition plus linux swap partition, I
> won't have two equal sized partitions for setting up the RAID 0 array.

If you have odd sized partitions for Btrfs raid0, it won't get mad at
you. It just won't use the extra space on the drive without a swap
partition.


http://www.tldp.org/HOWTO/Partition/setting_up_swap.html
If that's current, you can have a swap on each drive, same size, with
the same priority number, and the kernel will use both kinda like
raid0. And in this case, you can have pretty much identically sized
swap partitions on the two drives.



-- 
Chris Murphy
