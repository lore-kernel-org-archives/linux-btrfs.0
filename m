Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99666C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 12:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54CF12080D
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 12:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+ua9raR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfBLMbQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:31:16 -0500
Received: from mail-it1-f181.google.com ([209.85.166.181]:54480 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbfBLMbQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 07:31:16 -0500
Received: by mail-it1-f181.google.com with SMTP id i145so6724776ita.4
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 04:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=azIAfzG8z/eYVEZyo//mrDcfFEzErgGU+agGGBCDI28=;
        b=b+ua9raRkwLaZElsXZNPyuZk7Ni6mSTX4DURZ4Ef7v7Lkm3kuGR7wkLIopuf1uXUCY
         iVlWdJFl1hXjYRnHrJQSseID58QNkTyQnxd+ymDUpEjzoVV8Z4fe/0ehlcl7fuMhkG7+
         MEy4pXoiC6SPB9rmsBKmyLf8UQ9VujDXF4Nycbr/s7mHVdVW2ZatrEv4DhIfZXPuDeyN
         LrbE/tnaAQJIeR7h+zNX6Lol6UNoKN/KNYruDYHvyp749MKtivD/4iK3MNInWa6DL42P
         HoiRb/TJ/3KO/AKPIxfIgxD3dD/9iYeVuQ787zkFNygSz2nVY5DigHWdwftCT2eEXlCk
         RHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=azIAfzG8z/eYVEZyo//mrDcfFEzErgGU+agGGBCDI28=;
        b=ZRAMm35htBeC5PX0w9+6QKEIlTE7LRLq662wU0M5g2fqvgApFt/A/3h3JzZWkJ/Rco
         tqo4mhj06YURELelbrDSAor7U1pIpF/WVQbYfGVLGMEe7FNxABDnlnscKDSqxQpCxngv
         pytZjBo4N4aYUfArXftoEvtpAT2s/q3lST/BSRtpRO+BgjPCTUAhpZ3djz/8akY0oAbo
         boXe2gsRTzdMCmyFNye8ITadHdmkUDRXWgTFbNxOPe+3x24e7nszv48gEIldMHRRkq1G
         kNJi3bDqODqGBss4i7uH+B0evYdq9yESwZjLTCv8v4JFl6RCbkS0l+UAXorRs2m0kkHr
         W6sg==
X-Gm-Message-State: AHQUAuaSe9UjOO4YeNY1BL8LDI2HC79O8lT90GSnNtV36CWRvzQNVWWC
        Rhz2DK3nkFEw5fBFQL8bGs8FEtwE8zEjJBpQLD4MFC0L
X-Google-Smtp-Source: AHgI3IY8HVZmtAZKSmYIvO1DFWT/xQD1iU0ky9Jd71V53EB4nbUoYRDQyhclpxJu/M0nS5yPZzn2OGV4vusCRcVLAQE=
X-Received: by 2002:a5e:de45:: with SMTP id e5mr1748019ioq.294.1549974674876;
 Tue, 12 Feb 2019 04:31:14 -0800 (PST)
MIME-Version: 1.0
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
In-Reply-To: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
From:   Artem Mygaiev <joculator@gmail.com>
Date:   Tue, 12 Feb 2019 14:31:03 +0200
Message-ID: <CAJwc6KuhZuHve3FLbTcfbKUL8=WXmHN=OWnvDPJc4=pZQJsHWg@mail.gmail.com>
Subject: Re: Corrupted filesystem, looking for guidance
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Have same issue (RAID5 over 4 disks):
https://marc.info/?l=3Dlinux-btrfs&m=3D154815802313248&w=3D2

Having perfectly healthy HDDs it seem to be caused by some bit flips
in SDRAM which is non-ECC in my case, unfortunately. Tried --repair,
didn't helped, same for --init-csum-tree. Now using fs in ro mode
(data is fully available), preparing for total rebuild.

 -- Artem

On Tue, Feb 12, 2019 at 5:17 AM S=C3=A9bastien Luttringer <seblu@seblu.net>=
 wrote:
>
> Hello,
>
> The context is a BTRFS filesystem on top of an md device (raid5 on 6 disk=
s).
> System is an Arch Linux and the kernel was a vanilla 4.20.2.
>
> # btrfs fi us /home
> Overall:
>     Device size:                  27.29TiB
>     Device allocated:              5.01TiB
>     Device unallocated:           22.28TiB
>     Device missing:                  0.00B
>     Used:                          5.00TiB
>     Free (estimated):             22.28TiB      (min: 22.28TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:4.95TiB, Used:4.95TiB
>    /dev/md127      4.95TiB
>
> Metadata,single: Size:61.01GiB, Used:57.72GiB
>    /dev/md127     61.01GiB
>
> System,single: Size:36.00MiB, Used:560.00KiB
>    /dev/md127     36.00MiB
>
> Unallocated:
>    /dev/md127     22.28TiB
>
> I'm not able to find the root cause of the btrfs corruption. All disks lo=
oks
> healthy (selftest ok, no error logged), no kernel trace of link failure o=
r
> something.
> I run a check on the md layer, and 2 mismatch was discovered:
> Feb 11 04:02:35 kernel: md127: mismatch sector in range 490387096-4903871=
04
> Feb 11 04:31:14 kernel: md127: mismatch sector in range 1024770720-102477=
0728
> I run a repair (resync) but mismatch are still around after.
>
> The first BTRFS warning was:
> Feb 07 11:27:57 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
>
>
> After that, the userland process crashed. Few days ago, I run it again. I=
t
> crashes again but filesystem become read-only
>
> Feb 10 01:07:02 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS error (device md127): error loading props f=
or ino
> 9930722 (root 5): -5
> Feb 10 01:07:03 kernel: BTRFS error (device md127): error loading props f=
or ino
> 9930722 (root 5): -5
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:16:24 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:16:28 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:27:34 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:27:40 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 05:59:34 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 05:59:34 kernel: BTRFS error (device md127): error loading props f=
or ino
> 9930722 (root 5): -5
> Feb 10 05:59:34 kernel: BTRFS warning (device md127): md127 checksum veri=
fy
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 05:59:34 kernel: BTRFS info (device md127): failed to delete refer=
ence
> to fImage%252057(1).jpg, inode 9930722 parent 58718826
> Feb 10 05:59:34 kernel: BTRFS: error (device md127) in
> __btrfs_unlink_inode:3971: errno=3D-5 IO failure
> Feb 10 05:59:34 kernel: BTRFS info (device md127): forced readonly
>
> The btrfs check report:
>
> # btrfs check -p /dev/md127
> Opening filesystem to check...
> Checking filesystem on /dev/md127
> UUID: 64403592-5a24-4851-bda2-ce4b3844c168
> [1/7] checking root items                      (0:10:21 elapsed, 10056723=
 items
> checked)
> [2/7] checking extents                         (0:04:59 elapsed, 155136 i=
tems
> checked)
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B043109 =
items
> checked)
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> ref mismatch on [2622304964608 28672] extent item 1, found 0sed, 3783066 =
items
> checked)
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622304964608 root 5 owner 9930722 offse=
t 0
> found 0 wanted 1 back 0x55d61387cd40
> backref disk bytenr does not match extent record, bytenr=3D2622304964608,=
 ref
> bytenr=3D0
> backpointer mismatch on [2622304964608 28672]
> owner ref check failed [2622304964608 28672]
> ref mismatch on [2622304993280 262144] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622304993280 root 5 owner 9930724 offse=
t 0
> found 0 wanted 1 back 0x55d61387ce70
> backref disk bytenr does not match extent record, bytenr=3D2622304993280,=
 ref
> bytenr=3D0
> backpointer mismatch on [2622304993280 262144]
> owner ref check failed [2622304993280 262144]
> ref mismatch on [2622305255424 4096] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305255424 root 5 owner 9930727 offse=
t 0
> found 0 wanted 1 back 0x55d61387cfa0
> backref disk bytenr does not match extent record, bytenr=3D2622305255424,=
 ref
> bytenr=3D0
> backpointer mismatch on [2622305255424 4096]
> owner ref check failed [2622305255424 4096]
> ref mismatch on [2622305259520 8192] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305259520 root 5 owner 9930731 offse=
t 0
> found 0 wanted 1 back 0x55d61387d0d0
> backref disk bytenr does not match extent record, bytenr=3D2622305259520,=
 ref
> bytenr=3D0
> backpointer mismatch on [2622305259520 8192]
> owner ref check failed [2622305259520 8192]
> ref mismatch on [2622305267712 188416] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305267712 root 5 owner 9930733 offse=
t 0
> found 0 wanted 1 back 0x55d61387d200
> backref disk bytenr does not match extent record, bytenr=3D2622305267712,=
 ref
> bytenr=3D0
> backpointer mismatch on [2622305267712 188416]
> owner ref check failed [2622305267712 188416]
> ref mismatch on [2622305456128 4096] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305456128 root 5 owner 9930734 offse=
t 0
> found 0 wanted 1 back 0x55d61387d330
> backref disk bytenr does not match extent record, bytenr=3D2622305456128,=
 ref
> bytenr=3D0
> backpointer mismatch on [2622305456128 4096]
> owner ref check failed [2622305456128 4096]
> owner ref check failed [4140883394560 16384]
> [2/7] checking extents                         (0:31:38 elapsed, 3783074 =
items
> checked)
> ERROR: errors found in extent allocation tree or chunk allocation
> [3/7] checking free space cache                (0:03:58 elapsed, 5135 ite=
ms
> checked)
> [4/7] checking fs roots                        (1:02:53 elapsed, 139654 i=
tems
> checked)
>
> I tried to mount the filesystem with nodatasum but I was not able to dele=
te the
> suspected wrong directory. FS was remounted RO.
> btrfs inspect-internal logical-resolve and btrfs inspect-internal inode-r=
esolve
> are not able to resolve logical and inode path from the above errors.
>
> How could I save my filesystem? Should I try --repair or --init-csum-tree=
?
>
> Regards,
>
> S=C3=A9bastien "Seblu" Luttringer
>
