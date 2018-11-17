Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB687C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 20:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD27820815
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 20:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD27820815
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeKRGp5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 18 Nov 2018 01:45:57 -0500
Received: from mout.gmx.net ([212.227.17.21]:34463 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeKRGp4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Nov 2018 01:45:56 -0500
Received: from chaos-desktop.localnet ([188.98.54.223]) by mail.gmx.com
 (mrgmx101 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0LnCkb-1foCsb2xJd-00hPhW for <linux-btrfs@vger.kernel.org>; Sat, 17 Nov 2018
 21:28:04 +0100
From:   Stephan Olbrich <stephanolbrich@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: bad tree block start, want 705757184 have 82362368
Date:   Sat, 17 Nov 2018 21:28:04 +0100
Message-ID: <3061596.RPKkM7PgOY@chaos-desktop>
In-Reply-To: <7e04e877-a1db-bbfe-eb13-ae7b7c29c10f@gmx.com>
References: <1758973.r4I5FPff6i@chaos-desktop> <7e04e877-a1db-bbfe-eb13-ae7b7c29c10f@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gTRtaHVInxGBVliRG4rH/q4d7dpVxMT739M1o4S26R6m+GfyLXF
 S8epTYUrzy1DOVFPdxBtQtAIJmJIQNcIasRMQwXF1rc7XqBaVH2QYI/1duqmkyR4zkEIj/4
 aUfNn+pPj+7+i3EW7ODSM3SwCUq+HHl7lD8Tp1JW6d22cFlSr8w6+dWJHEnyKpo3BqTxo6d
 s4SnHFlQRk+WXn/aAkTuA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:RJfUWb3lOzc=:2ULyrEBVC+nC32gtyDaWIo
 f+YakpgnJ4wjuiNG6eyW2xkbwsgnuFATDrAbNi73x1mxETzU3o8Kv8g1pHYPhZbh7aj6H6MK/
 DvACvmrL+eQW+DLJ+BTKiWSadrCHHbFRi4WLYuIejIvogcuY1Ui7rC6tpmm3c1XzRI2kaM3nZ
 vRJ8AQKOpU7HMmaH5C/xNoAkU8ZUyp6D38CZPF1KT/xxK+crRawbHKXejhWko+JvZxCruZeJk
 NF19VKPnwRr6OE8z6pLc3wmJvthH1IQxkn/jPiuRFae3BVQK+Y7X23nxeAaLPa9UkyGDdvzin
 VnewVHuSo6MNOJ7qHtEmp+n/hP1v/pAfOUQ9FKJZ4yjrmByFLE4Cx7aK9+jKZh1LBjAl1E5Yi
 nH0XgjsXgX/DJ9zzgEFzNw8WSebAmPCWIJDrhnTHWZONY4pIirtgkaBJZa4uWTe3ODQXcv2um
 P99DspH/WpliSUHeQl8smvzDfJDmnciG/WY2Kl4sH93cbd7xqqO7JSJPScKWU+vxv/juFSpDj
 FqCX29nMCC6i+TTA0KoSKehu9t5XU+eTE+v7y1U5hfpsp2Pf0MebkHSXea4X6jnWkbtEb/gV8
 L19bysFT5vGlHWhOAJjDd/6xnwbnzDhAVkpoutu3q6yP73xJkChIz0U+Qn5y8vqyhJiO3xdRp
 yeKNcwmwIHUYY411qSCkjTnXG9GwtZ5dZv9Cs8JEhyoc6AJiauwK6PfJ7sihMaL2Ruw2LMc3/
 xTF4Y8LxIQc+W2hWbsM8jlTzp7Zk6O3UFdhFCO+bed/A6i8ok1hC/xvtCpwC218HR54oaoh8k
 KlRb6VYg/l9Nzq0WZO7dHHkBRSwh2OR+ClxyEEbCN2S0awfSKgu0jSx7H5yDO9qsv3DV3lOoB
 Xy39xmFfIgvT7OLHKfv9Yn2Fml6F9GAxgVJMr7Rgdw6TPFwbg39NUFUX12jmQBfLB7gDSMmb5
 EHZcXCSuvJg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am Samstag, 17. November 2018, 09:03:04 CET schrieb Qu Wenruo:
> On 2018/11/17 上午12:17, Stephan Olbrich wrote:
> > Hi,
> > 
> > a few days ago my root file system (simple btrfs on a SSD, no RAID or
> > anything) suddenly became read only. Looking at dmsg, I found this:
> > 
> > [   19.285020] BTRFS error (device sda2): bad tree block start, want
> > 705757184 have 82362368
> Does this only occurs once?
> 
> If only once, are you using SINGLE metadata profile (default for SSD)?
> If using DUP/RAID1 it may have a chance to recover.
It shows up once after reboot for each partition.
I'm using SINGLE metadata.

> 
> > [   19.285042] BTRFS: error (device sda2) in __btrfs_free_extent:6804:
> > errno=-5 IO failure
> The problem is in extent tree.

I checked my logs again, the __btrfs_free_extent error is missing for the /home partition:

[ 3154.066544] BTRFS error (device sda4): bad tree block start, want 560119808 have 4330389667183373366
[ 3154.066558] BTRFS: error (device sda4) in btrfs_run_delayed_refs:2934: errno=-5 IO failure
[ 3154.066561] BTRFS info (device sda4): forced readonly
[ 3154.066904] BTRFS error (device sda4): pending csums is 360448

> 
> If there is no other problem, your data should be OK.
> 
> You could still try to mount the fs RO to salvage data.

I'm not so much worried about salvaging data, as I have a current backup. I'm more worried 
how reliable the backup is, as I'm not sure, when the errors first started. But if the data is
OK, then the backup (snapshots on another drive) should be OK as well I guess.

> > [   19.285048] BTRFS info (device sda2): forced readonly
> > [   19.285051] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2934:
> > errno=-5 IO failure [   19.287213] BTRFS error (device sda2): pending
> > csums is 41889792
> > 
> > Late on I got the same errors for my /home partition (on the same drive)
> > as well. I have snapshots of all partitions on another drive made by
> > btrbk. To get a working system, I made new (rw) snapshots of the most
> > recent backup and setup grub and fstab, so my system would boot from the
> > other drive. Unfortunately now I got the "bad tree block start" error
> > again at least once in dmesg but I didn't save it and it's not in syslog
> > :-( What I remember is, that it was followed by other btrfs error
> > messages saying something about correcting something. And the filesystem
> > was still read/write this time.
> > At the moment I can't reproduce it.
> > 
> > Is there any way to find out, which files are affected by the errors
> > above?
> 
> No files are affected, but an essential tree, extent tree, is corrupted.
> 
> Normally this may prevent RW mount, and even it mounts it can still
> cause problem when doing any write.
> It could even prevent RO mount if the corrupted leaf contains block
> group item.
> 
> But your data should be OK if there is no other corruption, and in that
> case btrfs-restore should work well.
> 
> > I don't really trust the data on the drive I'm using at the
> > moment, as it has shown errors as well, but I have a less current backup
> > on yet another drive but at it is a few weeks old, I don't want to use it
> > to setup the system on the SSD again, but just copy the relevant files if
> > possible. Or is it possible to repair the original file system?
> 
> At least we need "btrfs check" output.
I updated btrfs-progs and run btrfs check for / and /home
No errors are found on / (sda2), but there are errors on /home ??

$ btrfs --version
btrfs-progs v4.19

$ btrfs check /dev/sda2
Opening filesystem to check...
Checking filesystem on /dev/sda2
UUID: 80368989-ffa8-463c-98fb-fe2e28ca7bf3
[1/7] checking root items
[2/7] checking extents
[3/7] checking free space cache
[4/7] checking fs roots
[5/7] checking only csums items (without verifying data)
[6/7] checking root refs
[7/7] checking quota groups skipped (not enabled on this FS)
found 64816218112 bytes used, no error found
total csum bytes: 59518732
total tree bytes: 2180268032
total fs tree bytes: 1965965312
total extent tree bytes: 123289600
btree space waste bytes: 478665777
file data blocks allocated: 151083261952
 referenced 76879990784

$ btrfs check /dev/sda4
Opening filesystem to check...
Checking filesystem on /dev/sda4
UUID: 81c38df8-b7f9-412c-8c88-cfde8db68eb1
[1/7] checking root items
[2/7] checking extents
[3/7] checking free space cache
[4/7] checking fs roots
root 257 inode 7970563 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 20480
root 257 inode 7970564 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 77824
ERROR: errors found in fs roots
found 303386652672 bytes used, error(s) found
total csum bytes: 289501272
total tree bytes: 2336227328
total fs tree bytes: 1766473728
total extent tree bytes: 202014720
btree space waste bytes: 519245278
file data blocks allocated: 6851730792448
 referenced 533348069376

Thanks,
Stephan

> 
> > Some information about my system:
> > Kubuntu 18.04
> > Kernel 4.19.1 when the problem occured, now 4.19.2
> > btrfs-tools 4.15.1
> 
> And "btrfs check" should be executed using latest version.
> 
> Thanks,
> Qu
> 
> > Regards,
> > Stephan




