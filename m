Return-Path: <SRS0=WB35=N5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D690AC43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 07:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 943E62080F
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 07:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 943E62080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbeKRSPl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 18 Nov 2018 13:15:41 -0500
Received: from mout.gmx.net ([212.227.17.21]:60763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbeKRSPl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Nov 2018 13:15:41 -0500
Received: from chaos-desktop.localnet ([188.105.5.248]) by mail.gmx.com
 (mrgmx101 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0Mh5h7-1g247L3R45-00MJgF for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2018
 08:56:06 +0100
From:   Stephan Olbrich <stephanolbrich@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: bad tree block start, want 705757184 have 82362368
Date:   Sun, 18 Nov 2018 08:56:06 +0100
Message-ID: <32822632.LIG5tvG1AF@chaos-desktop>
In-Reply-To: <e65c8b2a-e337-6c9c-6fbc-839d810353df@gmx.com>
References: <1758973.r4I5FPff6i@chaos-desktop> <3061596.RPKkM7PgOY@chaos-desktop> <e65c8b2a-e337-6c9c-6fbc-839d810353df@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:4zEkhEijpJAK7vQi43WFccaD0fZwv7lNlZSSV3G3S36WnNGdxzs
 hU+aF3TAK50DbWuT4cB80gqrRQ/vqVMTS4Dyq5J/28f/PhjQ3BZ453H89PAQCURBRktfMp2
 AHMmUhMCz2uceuE+PO1AcMYlo6F2teJPR/tlo1P28e9dhWVdJ/GItb3MGHPf3XNTG75E/TQ
 R5p0evQ2igX8QPccF07+w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:UGvBqjNrU9c=:47USUlWpbJKuvf6ycOrgFn
 lfZlzfGdGLCUnwgBozXsaG5aWXkcvC4H8O4QkNdtFzmPrY2q74uwK2LEIX/xmBhLpuvkFXy0C
 ZMQKPOFIDcbjUXEzOEYo3+NMTafxwS5YvqcBHM6MnEMX6DZvw60VhAggghSfZRYwfFurtglgi
 KlODcPwIkM9Ongn2QzONgQ/Fk94dMaanF+Qn+j7MSnFEyxckJ49cpi4Rqeqz9UE3MIaLf67Xb
 tO1PRuWqDJmvauZU18TQ/4aiaECQpz0osFr2tBXRMuh6PaPGpnibIiR5NLCfJ6aKij6w8+N8y
 tylTc6DtzFyz4IaDeJ1eruEde7XTYIiyUDqm83czIzUgKvboTFWwV79uFQjXkumfyEMqGYCVn
 CWc47IxPQ3w+i1FtZm0svAWo28EfPvt8MY9laKZdXs04RAR+yUXz+d6vsP5w2DXbMaqYdkf+v
 Fob49p8UR8lblI8pn5rRKy2C56wMk3hwjZd1wKUyFCPczu/CW6nnrOVUKOrQFFHFAHAkB4CyP
 Dmh7TVlwBOfM5MtMx95BoI9JsQLxhHu1oFOjs2JpQloeipjiN8G24buNE1nKchUkES5aN9PIK
 E5q9Sr5EVTW63Z+m3FKOCTq/NtV2YrOi/BNHUlmhgV44pjGEY2YfUzfWGOksAOTR/3+ruK8F9
 AQrVEamc1oCgNO7G9E1NQ7vnGSZZFLHBBUCWlghZGPXuVmmmDJbOqiI9GGeIpnzDZ9vDdPKSV
 gQ5p3T+r0MaPfsSBtbktenvfL+5ej32ef02tv9cmNjvp1WJ1g/micKDdbp0G1JCkqMuYezWsB
 T9EnvDsmJzQsDDBE+VZo9ZSDpRozSHBosMYmuNveTffV5Jn4ZohLy76K/bkcNx/v4KFqDNxpg
 fYMEAf3Zq9JecQjvtmZn+fUU53Tb0BpJbTwMUtWVl3Sh2UFam7bdllfjkzYRCx+/M1yfxMK7x
 SYv747BLr5Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am Sonntag, 18. November 2018, 01:30:14 CET schrieb Qu Wenruo:
> >>> Late on I got the same errors for my /home partition (on the same drive)
> >>> as well. I have snapshots of all partitions on another drive made by
> >>> btrbk. To get a working system, I made new (rw) snapshots of the most
> >>> recent backup and setup grub and fstab, so my system would boot from the
> >>> other drive. Unfortunately now I got the "bad tree block start" error
> >>> again at least once in dmesg but I didn't save it and it's not in syslog
> >>> :-( What I remember is, that it was followed by other btrfs error
> >>> messages saying something about correcting something. And the filesystem
> >>> was still read/write this time.
> >>> At the moment I can't reproduce it.

Today it happend again (sdb is my backup drive, which is my main drive at the moment):
[  286.325857] BTRFS error (device sdb1): bad tree block start, want 787719208960 have 11268016545161247416
[  286.363245] BTRFS info (device sdb1): read error corrected: ino 0 off 787719208960 (dev /dev/sdb1 sector 1243815072)
[  286.364087] BTRFS info (device sdb1): read error corrected: ino 0 off 787719213056 (dev /dev/sdb1 sector 1243815080)
[  286.425946] BTRFS info (device sdb1): read error corrected: ino 0 off 787719217152 (dev /dev/sdb1 sector 1243815088)
[  286.427530] BTRFS info (device sdb1): read error corrected: ino 0 off 787719221248 (dev /dev/sdb1 sector 1243815096)


> >>> Is there any way to find out, which files are affected by the errors
> >>> above?
> >> 
> >> No files are affected, but an essential tree, extent tree, is corrupted.
> >> 
> >> Normally this may prevent RW mount, and even it mounts it can still
> >> cause problem when doing any write.
> >> It could even prevent RO mount if the corrupted leaf contains block
> >> group item.
> >> 
> >> But your data should be OK if there is no other corruption, and in that
> >> case btrfs-restore should work well.
> >> 
> >>> I don't really trust the data on the drive I'm using at the
> >>> moment, as it has shown errors as well, but I have a less current backup
> >>> on yet another drive but at it is a few weeks old, I don't want to use
> >>> it
> >>> to setup the system on the SSD again, but just copy the relevant files
> >>> if
> >>> possible. Or is it possible to repair the original file system?
> >> 
> >> At least we need "btrfs check" output.
> > 
> > I updated btrfs-progs and run btrfs check for / and /home
> > No errors are found on / (sda2), but there are errors on /home ??
> > 
> > $ btrfs --version
> > btrfs-progs v4.19
> > 
> > $ btrfs check /dev/sda2
> > Opening filesystem to check...
> > Checking filesystem on /dev/sda2
> > UUID: 80368989-ffa8-463c-98fb-fe2e28ca7bf3
> > [1/7] checking root items
> > [2/7] checking extents
> > [3/7] checking free space cache
> > [4/7] checking fs roots
> > [5/7] checking only csums items (without verifying data)
> > [6/7] checking root refs
> > [7/7] checking quota groups skipped (not enabled on this FS)
> > found 64816218112 bytes used, no error found
> > total csum bytes: 59518732
> > total tree bytes: 2180268032
> > total fs tree bytes: 1965965312
> > total extent tree bytes: 123289600
> > btree space waste bytes: 478665777
> > file data blocks allocated: 151083261952
> > 
> >  referenced 76879990784
> 
> This fs is completely fine, including your data.
> 
> > $ btrfs check /dev/sda4
> > Opening filesystem to check...
> > Checking filesystem on /dev/sda4
> > UUID: 81c38df8-b7f9-412c-8c88-cfde8db68eb1
> > [1/7] checking root items
> > [2/7] checking extents
> > [3/7] checking free space cache
> > [4/7] checking fs roots
> > root 257 inode 7970563 errors 100, file extent discount
> > 
> > Found file extent holes:
> >         start: 0, len: 20480
> > 
> > root 257 inode 7970564 errors 100, file extent discount
> > 
> > Found file extent holes:
> >         start: 0, len: 77824
> > 
> > ERROR: errors found in fs roots
> 
> These are just minor errors, won't even causing any data mismatch.
> 
> So all your fses should be mostly OK.
> 
> Would you please try to use v4.19-rc* to see if it changes anything?
v4.19-rc1 is the only rc I found, but that is older than v4.19, right?
Anyway, here is the output:

$ btrfs --version
btrfs-progs v4.19-rc1

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


> Thanks,
> Qu
> 
> > found 303386652672 bytes used, error(s) found
> > total csum bytes: 289501272
> > total tree bytes: 2336227328
> > total fs tree bytes: 1766473728
> > total extent tree bytes: 202014720
> > btree space waste bytes: 519245278
> > file data blocks allocated: 6851730792448
> > 
> >  referenced 533348069376
> > 
> > Thanks,
> > Stephan
> > 
> >>> Some information about my system:
> >>> Kubuntu 18.04
> >>> Kernel 4.19.1 when the problem occured, now 4.19.2
> >>> btrfs-tools 4.15.1
> >> 
> >> And "btrfs check" should be executed using latest version.
> >> 
> >> Thanks,
> >> Qu
> >> 
> >>> Regards,
> >>> Stephan




