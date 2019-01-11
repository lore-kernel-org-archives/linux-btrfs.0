Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33E9C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 12:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22F872133F
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 12:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="SqOf40IO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbfAKM3p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 07:29:45 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:12264 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732359AbfAKM3p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 07:29:45 -0500
Date:   Fri, 11 Jan 2019 12:29:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1547209781;
        bh=6wgLdK2flZGsURnqBnfquN5vAVRkn5MEulS0rEd4wAk=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=SqOf40IO4mpbilNR6KldZBThtrGwwfNy0VFFrGymYWAKPden89iCpeyln1Ulp2oAQ
         0gJrMPRmpY8MHIZ2Ez9VLoY3OEWzcsZ61jzIAWCRZWVRx1rf2FdTVMrm3nh5fZmWZq
         knj1EQnN87kW7NClDUFavOUlh7uCJXs3BGZep+hE=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   b11g <b11g@protonmail.com>
Reply-To: b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <j8LS7-Iz6uOg8fN_yZD_mcUT3J1jCHsk9nU18LpSGGcHDHVTHk6s8u5HFNAuB6lfcjzwtWD2o6awwLqY6-GQmOBBeJ6ZUiiybgohZUxJlwg=@protonmail.com>
In-Reply-To: <DID7NmLoqB1WBZ8Vo7rEMlL9cLWv7Bz9F04MkQYOLfZJyl04O44IUiFKdC_Tl4iSvHGLxpbwDwD9cHJ33t-Hkv8PKF0wmm7201RABA2kRAY=@protonmail.com>
References: <DID7NmLoqB1WBZ8Vo7rEMlL9cLWv7Bz9F04MkQYOLfZJyl04O44IUiFKdC_Tl4iSvHGLxpbwDwD9cHJ33t-Hkv8PKF0wmm7201RABA2kRAY=@protonmail.com>
Feedback-ID: lUBa-WV0uAwkWs2PxUY-pUV2q6-Zuux_EqKTuYphP-Kxh3RnAJZOoHLvsXpeqqAZQFobD_IfHjSMoVPhuYTmhg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Follow up: the issue was a faulty DIMM module. For some strange coincidence=
, only the space allocated to disk caches appeared to be corrupted - with t=
he rest of the system working flawlessly most of the time.

I would guess that BTRFS tried to self-heal based on the cached data, ultim=
ately corrupting the file system behind salvation?

If anyone gets here with similar problems - memtest your ram before doing a=
nything!

-b11g


=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Thursday, 3 January 2019 01:26, b11g <b11g@protonmail.com> wrote:

> Hi all,
>
> I have several BTRFS success-stories, and I've been an happy user for qui=
te a long time now. I was therefore surprised to face a BTRFS corruption on=
 a system I'd just installed.
>
> I use NixOS, unstable branch (linux kernel 4.19.12). The system runs on a=
 SSD with an ext4 boot partition, a simple btrfs root with some subvolumes,=
 and some swap space only used for hibernation. I was working on my server =
as normal when I noticed all of my BTRFS subvolumes had been remounted ro. =
After a short time, I started getting various IO errors ("bus error" by jou=
rnalctl, "I/O error" by ls etc.). I halted the system (hard reboot), at the=
 reboot the BTRFS partition would not mount. I suspected the corruption to =
be disk-related, but smartctl does not show any warning for the disk, and t=
he ext4 partition seems healthy.
>
> Those are the kernel messages logged when I attempt to mount the partitio=
n:
> Jan 02 23:39:38 nixos kernel: BTRFS warning (device sdd2): sdd2 checksum =
verify failed on <L> wanted <A> found <B> level 0
> Jan 02 23:39:38 nixos kernel: BTRFS error (device sdd2): failed to read b=
lock groups: -5
> Jan 02 23:39:38 nixos systemd[1]: Started Cleanup of Temporary Directorie=
s.
> Jan 02 23:39:38 nixos kernel: BTRFS error (device sdd2): open_ctree faile=
d
>
> Some queries for the error code I got lead me to those two recent threads=
:
> https://www.spinics.net/lists/linux-btrfs/msg84973.html
> https://www.spinics.net/lists/linux-btrfs/msg83833.html
>
> Using btrfs-progs-4.15.1, "btrfs restore /dev/sdd2 /tmp/" fails with:
> checksum verify failed on <N> found <A> wanted <B>
> checksum verify failed on <N> found <A> wanted <B>
> Csum didn't match
> Could not open root, trying backup super
> checksum verify failed on <N> found <A> wanted <B>
> checksum verify failed on <N> found <A> wanted <B>
> Csum didn't match
> Could not open root, trying backup super
> ERROR: superblock bytenr <X> is larger than device size <Y>
> Could not open root, trying backup super
>
> Using btrfs-progs-4.19.1, "btrfs restore /dev/sdd2 /tmp/" succeeds with s=
ome exceptions:
> We have looped trying to restore files in /@/nix/store too many times to =
be making progress, stopping
>
> I do not have much time for debugging the issue and I did not lose import=
ant data, so I tried a couple of commands suggested on the threads and in t=
he docs (without fully understanding them):
>
> "btrfs rescue zero-log /dev/sdd2":
> checksum verify failed on <N> found <A> wanted <B>
> checksum verify failed on <N> found <A> wanted <B>
> Csum didn't match
> ERROR: could not open ctree
>
> "btrfs check --repair /dev/sdd2" (I know, I was not supposed to run this =
one):
> Opening filesystem to check...
> checksum verify failed on <N> found <A> wanted <B>
> checksum verify failed on <N> found <A> wanted <B>
> Csum didn't match
> ERROR: could not open ctree
>
> Same for "btrfs check --init-csum-tree /dev/sdd2".
>
> I expect to wipe the disk and do a clean start in the following days, I j=
ust wanted to report this in the hope it helps in the development (sorry fo=
r the redaction). If you need more information, I'll be glad to help as I c=
an!
>
> Thank you for your work,
> Cheers,
>
> -   b11g


