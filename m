Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B667C282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 20:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CAA120675
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 20:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfDTUTR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 16:19:17 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:35468 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfDTUTR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 16:19:17 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1hHwS9-0000wz-RK; Sat, 20 Apr 2019 22:19:13 +0200
Date:   Sat, 20 Apr 2019 22:19:13 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Juergen Sauer <juergen.sauer@automatix.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Raid 5 Space missing - ideas ?
Message-ID: <20190420201913.GA3306@angband.pl>
References: <cac3618d-8153-66c1-446a-0040b7142c6a@automatix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cac3618d-8153-66c1-446a-0040b7142c6a@automatix.de>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 20, 2019 at 12:46:16PM +0200, Juergen Sauer wrote:
> I wish a happy Easer Days before :)

Same to you!

> During my tests with BTRFS as Raid5 setup, I found a courious little
> "problem".

>         Total devices 3 FS bytes used 9.98TiB
>         devid    1 size 9.09TiB used 4.99TiB path /dev/sdb1
>         devid    2 size 5.46TiB used 4.99TiB path /dev/sdc1
>         devid    3 size 5.46TiB used 4.99TiB path /dev/sde1

> All patitioins sdb1 sdc1 sde1 are the same size: 9.0 TiB. But BTRFS ist
> not using the bigger space on sdc1, sde1, there is only 5.46 TiB used,
> even there are 9.0 Tib Avaible, so 4.0 TiB are unused.

It's working as expected: while btrfs does RAID per block group rather than
per whole block device, there's no way to place a raid5 block group in a way
that doesn't require at least 3 devices.  This means with a 3-disk setup the
space utilized will be only as big as the smallest one.

This is also the case for raid1 on 2-disk, and for raid10 on 4-disk.

Btrfs can use uneven disks only when it has some freedom how to place the
data around.

There's a tool that lets you visualize space utilization:
    http://carfax.org.uk/btrfs-usage/
or a command-line implementation:
    btrfs-space-calculator (package python[3]-btrfs)


By the way, you can greatly improve performance and safety by switching
metadata profile to raid1: "btrfs bal start -mraid1".  RAID5 is very slow
for random writes, which is nearly all metadata write access; RAID1 doesn't
suffer from this problem -- and metadata tends to be only around 1-2% of
space so having it take a bit more doesn't hurt.

It would also solve your utilization problem, except that metadata uses so
little space.  Having mixed block groups means the space not taken by RAID5
can be recovered by taking twice as much from sdb1 than from each of sdc1
and sde1:

sdb1 *********************
sdc1 * * * * * * * * * * *
sde1  * * * * * * * * * *
(each RAID1 block group is either sdb1,sdc1 or sdb1:sde1)


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
⠈⠳⣄⠀⠀⠀⠀
