Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19E1C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 19:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F8AA20851
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 19:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F8AA20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbeKTGHX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 01:07:23 -0500
Received: from mout.gmx.net ([212.227.17.21]:50589 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbeKTGHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 01:07:22 -0500
Received: from chaos-desktop.localnet ([188.105.14.225]) by mail.gmx.com
 (mrgmx101 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0MNdxu-1gM4HE0woM-007Ftk for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018
 20:42:14 +0100
From:   Stephan Olbrich <stephanolbrich@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: bad tree block start, want 705757184 have 82362368
Date:   Mon, 19 Nov 2018 20:42:13 +0100
Message-ID: <12062768.DAp5qtROXe@chaos-desktop>
In-Reply-To: <8262543f-167a-6157-348a-74bb71079bf4@oracle.com>
References: <1758973.r4I5FPff6i@chaos-desktop> <32822632.LIG5tvG1AF@chaos-desktop> <8262543f-167a-6157-348a-74bb71079bf4@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:N1qlDj8sEDAUj5WKa9yWvlF1K3dLSJzxuZGMuBZ0w5ibZN1MAMx
 j+YcrQ5cxqywWALM+FbFcxvxhqHLtB9KJzuqToV3CY8heT0TJ9gHnU4Z/EyQUfrVChePx/b
 GvWFKrxgXTsfPdkpTTckZ6iBqbl4veT0ifbrOgvELpm9ivVNmmCH6kKghxumGUeKbw7DCcA
 QX2y1k/klhL6eRoWO3S0A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:aEKR+TA9STk=:ikBXXlLqB7awI+4gwtC0jk
 Nyh84ONVDxr1Sr/+mX+0EBlTTxdkIjrJX5nrDfuVjnJU3ZBP3SvV3+Rq2tOQtq+3h/88GFQtB
 OBRYPhmtviFjrQzT1wa3+RxW7ACbKONTixRPIOHTL69cR26UJFMrs/qJ/x/LvlbD4+WKYm4wS
 HEsoeNc6ElcJCb7BkDjyQOUyJr2w0iX5iQxc9PtaGwKEqDmYVjKGdixQ8bbqHU6qp3cByzTvG
 tN/7pBiy9DPczGLhWnPQQ8FxRfWF/PPHiMkQJ1BL+2qvJDZPCPJ0iaYxd47C0194fPWXiFvuz
 4Poq2iS8F+cda+jS+x20PLTqP3G2J9LLgF6bLrVcH+vs8Go/5nAdxDCaSBe+2Lv6/FyD+mgSU
 FYMXB1cSW5kYjbIXFVPaDTZOOLIccIp3ZM45auFwvIQbF5U2Z8xtCHUGKWWlnu+Rz6caNBepl
 OyZhL4wy6IAM+qCqjQcut81DKwENHnubjxkw0kHtRNuYU8ZZ/O7viXuGyVAZcTmu6AeMrx7Co
 FsVsXgQja8PQMOghZkgRq9hLpZH1X48DzLmlcS3OBxHN2O//R2TfrG3Yi+pECKUI53uwkqLZz
 VdKviNSq9pMEL9PQ7F/+febgulbq2QpodKVtu9KalZ4IZgZq1aBriMDZo16l9TST19Lc9EEha
 +KCUtayrvF9ziFJDjfKryK2ZQFUBw1uEYPY4N9y+tSMNuISg0MuhRgj2EY5rGLy58A9Hvxxpt
 /yihnzlsGlo5luemnpgZt2LghHOoiWf/JDuzQNKgEUFyXxWgYzrYOHxe8SIPlW/9yTrzaz4w1
 YDEjTcluZoEGikAFqhHpxHgnGUd/791E6ljEhOgai9cWLg7S+dEidQrM18SmcJqtebEJeAh/F
 p1oPUVNpqbAT422ULWRTiRKEaSsGO7cqq8twDbLkgEJKANwelTJkFwVjTFAWgZhbEifLcXCFB
 h++z+ALB8nA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am Sonntag, 18. November 2018, 14:31:36 CET schrieb Anand Jain:
> On 11/18/2018 03:56 PM, Stephan Olbrich wrote:
> > Am Sonntag, 18. November 2018, 01:30:14 CET schrieb Qu Wenruo:
> >>>>> Late on I got the same errors for my /home partition (on the same
> >>>>> drive)
> >>>>> as well. I have snapshots of all partitions on another drive made by
> >>>>> btrbk. To get a working system, I made new (rw) snapshots of the most
> >>>>> recent backup and setup grub and fstab, so my system would boot from
> >>>>> the
> >>>>> other drive. Unfortunately now I got the "bad tree block start" error
> >>>>> again at least once in dmesg but I didn't save it and it's not in
> >>>>> syslog
> >>>>> 
> >>>>> :-( What I remember is, that it was followed by other btrfs error
> >>>>> 
> >>>>> messages saying something about correcting something. And the
> >>>>> filesystem
> >>>>> was still read/write this time.
> >>>>> At the moment I can't reproduce it.
> > 
> > Today it happend again (sdb is my backup drive, which is my main drive at
> > the moment): [  286.325857] BTRFS error (device sdb1): bad tree block
> > start, want 787719208960 have 11268016545161247416 [  286.363245] BTRFS
> > info (device sdb1): read error corrected: ino 0 off 787719208960 (dev
> > /dev/sdb1 sector 1243815072) [  286.364087] BTRFS info (device sdb1):
> > read error corrected: ino 0 off 787719213056 (dev /dev/sdb1 sector
> > 1243815080) [  286.425946] BTRFS info (device sdb1): read error
> > corrected: ino 0 off 787719217152 (dev /dev/sdb1 sector 1243815088) [ 
> > 286.427530] BTRFS info (device sdb1): read error corrected: ino 0 off
> > 787719221248 (dev /dev/sdb1 sector 1243815096)
>   Was there any hardware issues? How about the following data from the
> system..
> 
>    btrfs fi df <mnt>
>    btrfs dev stat <mnt>

I didn't have any hardware issues (that I know of).

$ btrfs fi df /
Data, single: total=841.00GiB, used=791.92GiB                                                                                                                                                              
System, DUP: total=8.00MiB, used=112.00KiB                                                                                                                                                                 
System, single: total=4.00MiB, used=0.00B                                                                                                                                                                  
Metadata, DUP: total=10.50GiB, used=8.44GiB                                                                                                                                                                
Metadata, single: total=8.00MiB, used=0.00B                                                                                                                                                                
GlobalReserve, single: total=512.00MiB, used=0.00B

$ btrfs dev stat /                                                                                                                                                             
[/dev/sdb1].write_io_errs    0                                                                                                                                                                             
[/dev/sdb1].read_io_errs     0                                                                                                                                                                             
[/dev/sdb1].flush_io_errs    0                                                                                                                                                                             
[/dev/sdb1].corruption_errs  0                                                                                                                                                                             
[/dev/sdb1].generation_errs  0 

Also the numbers in the error messages keep changing:
[ 1577.302959] BTRFS error (device sdb1): bad tree block start, want 788086226944 have 411602213549769407
[ 1577.369083] BTRFS info (device sdb1): read error corrected: ino 0 off 788086226944 (dev /dev/sdb1 sector 1244531904)
[ 1577.428139] BTRFS info (device sdb1): read error corrected: ino 0 off 788086231040 (dev /dev/sdb1 sector 1244531912)
[ 1577.429091] BTRFS info (device sdb1): read error corrected: ino 0 off 788086235136 (dev /dev/sdb1 sector 1244531920)
[ 1577.478249] BTRFS info (device sdb1): read error corrected: ino 0 off 788086239232 (dev /dev/sdb1 sector 1244531928)

Thanks,
Stephan

> Thanks, Anand
> 
> >>>>> Is there any way to find out, which files are affected by the errors
> >>>>> above?
> >>>> 
> >>>> No files are affected, but an essential tree, extent tree, is
> >>>> corrupted.
> >>>> 
> >>>> Normally this may prevent RW mount, and even it mounts it can still
> >>>> cause problem when doing any write.
> >>>> It could even prevent RO mount if the corrupted leaf contains block
> >>>> group item.
> >>>> 
> >>>> But your data should be OK if there is no other corruption, and in that
> >>>> case btrfs-restore should work well.
> >>>> 
> >>>>> I don't really trust the data on the drive I'm using at the
> >>>>> moment, as it has shown errors as well, but I have a less current
> >>>>> backup
> >>>>> on yet another drive but at it is a few weeks old, I don't want to use
> >>>>> it
> >>>>> to setup the system on the SSD again, but just copy the relevant files
> >>>>> if
> >>>>> possible. Or is it possible to repair the original file system?
> >>>> 
> >>>> At least we need "btrfs check" output.
> >>> 
> >>> I updated btrfs-progs and run btrfs check for / and /home
> >>> No errors are found on / (sda2), but there are errors on /home ??
> >>> 
> >>> $ btrfs --version
> >>> btrfs-progs v4.19
> >>> 
> >>> $ btrfs check /dev/sda2
> >>> Opening filesystem to check...
> >>> Checking filesystem on /dev/sda2
> >>> UUID: 80368989-ffa8-463c-98fb-fe2e28ca7bf3
> >>> [1/7] checking root items
> >>> [2/7] checking extents
> >>> [3/7] checking free space cache
> >>> [4/7] checking fs roots
> >>> [5/7] checking only csums items (without verifying data)
> >>> [6/7] checking root refs
> >>> [7/7] checking quota groups skipped (not enabled on this FS)
> >>> found 64816218112 bytes used, no error found
> >>> total csum bytes: 59518732
> >>> total tree bytes: 2180268032
> >>> total fs tree bytes: 1965965312
> >>> total extent tree bytes: 123289600
> >>> btree space waste bytes: 478665777
> >>> file data blocks allocated: 151083261952
> >>> 
> >>>   referenced 76879990784
> >> 
> >> This fs is completely fine, including your data.
> >> 
> >>> $ btrfs check /dev/sda4
> >>> Opening filesystem to check...
> >>> Checking filesystem on /dev/sda4
> >>> UUID: 81c38df8-b7f9-412c-8c88-cfde8db68eb1
> >>> [1/7] checking root items
> >>> [2/7] checking extents
> >>> [3/7] checking free space cache
> >>> [4/7] checking fs roots
> >>> root 257 inode 7970563 errors 100, file extent discount
> >>> 
> >>> Found file extent holes:
> >>>          start: 0, len: 20480
> >>> 
> >>> root 257 inode 7970564 errors 100, file extent discount
> >>> 
> >>> Found file extent holes:
> >>>          start: 0, len: 77824
> >>> 
> >>> ERROR: errors found in fs roots
> >> 
> >> These are just minor errors, won't even causing any data mismatch.
> >> 
> >> So all your fses should be mostly OK.
> >> 
> >> Would you please try to use v4.19-rc* to see if it changes anything?
> > 
> > v4.19-rc1 is the only rc I found, but that is older than v4.19, right?
> > Anyway, here is the output:
> > 
> > $ btrfs --version
> > btrfs-progs v4.19-rc1
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
> >   referenced 76879990784
> > 
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
> >          start: 0, len: 20480
> > 
> > root 257 inode 7970564 errors 100, file extent discount
> > 
> > Found file extent holes:
> >          start: 0, len: 77824
> > 
> > ERROR: errors found in fs roots
> > found 303386652672 bytes used, error(s) found
> > total csum bytes: 289501272
> > total tree bytes: 2336227328
> > total fs tree bytes: 1766473728
> > total extent tree bytes: 202014720
> > btree space waste bytes: 519245278
> > file data blocks allocated: 6851730792448
> > 
> >   referenced 533348069376
> > 
> > Thanks,
> > Stephan
> > 
> >> Thanks,
> >> Qu
> >> 
> >>> found 303386652672 bytes used, error(s) found
> >>> total csum bytes: 289501272
> >>> total tree bytes: 2336227328
> >>> total fs tree bytes: 1766473728
> >>> total extent tree bytes: 202014720
> >>> btree space waste bytes: 519245278
> >>> file data blocks allocated: 6851730792448
> >>> 
> >>>   referenced 533348069376
> >>> 
> >>> Thanks,
> >>> Stephan
> >>> 
> >>>>> Some information about my system:
> >>>>> Kubuntu 18.04
> >>>>> Kernel 4.19.1 when the problem occured, now 4.19.2
> >>>>> btrfs-tools 4.15.1
> >>>> 
> >>>> And "btrfs check" should be executed using latest version.
> >>>> 
> >>>> Thanks,
> >>>> Qu
> >>>> 
> >>>>> Regards,
> >>>>> Stephan




