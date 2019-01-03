Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32229C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 13:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 679B421479
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 13:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="T5BzsRae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbfACN4D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 08:56:03 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:53360 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730595AbfACN4D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 08:56:03 -0500
Date:   Thu, 03 Jan 2019 13:55:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1546523759;
        bh=AT5VyUbUuvMGjddr4RcpZFDqG2hm2Zq9rF3XcgkvwNM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=T5BzsRaem5YH6SgtHyYp8f+khk730+H/z8XeNx+qE+e5Sh8CHRHhv4cmAZCamn+zi
         OtlpRcETE+7nruNF4yDqvxNUU7GPL12OgMWqaqyMJ8ciNJsfYVsAqOWcN1g/ZNOqZF
         ANyhFi2asSDCeX8cmF6ROiLB+6MEjtFtI5Saf2z8=
To:     Chris Murphy <lists@colorremedies.com>
From:   b11g <b11g@protonmail.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-To: b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <OAUyvYQ65eFoxQY0GmEgh96YvtyWfbnvB6ebVJkADANt8NfUcRVct_IdyQduy58Dnuv2ExOhmP4MpOX1Q7Ln-GK7kUQDz6Gt2T7jYSMv3yM=@protonmail.com>
In-Reply-To: <CAJCQCtR8qEyw51Ox2jU1E4nWBVfV4j8_nEcMgz2gTJa=yhv=Tw@mail.gmail.com>
References: <DID7NmLoqB1WBZ8Vo7rEMlL9cLWv7Bz9F04MkQYOLfZJyl04O44IUiFKdC_Tl4iSvHGLxpbwDwD9cHJ33t-Hkv8PKF0wmm7201RABA2kRAY=@protonmail.com>
 <CAJCQCtR8qEyw51Ox2jU1E4nWBVfV4j8_nEcMgz2gTJa=yhv=Tw@mail.gmail.com>
Feedback-ID: lUBa-WV0uAwkWs2PxUY-pUV2q6-Zuux_EqKTuYphP-Kxh3RnAJZOoHLvsXpeqqAZQFobD_IfHjSMoVPhuYTmhg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Responded in-line.

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Thursday, 3 January 2019 05:52, Chris Murphy <lists@colorremedies.com> w=
rote:

> On Wed, Jan 2, 2019 at 5:26 PM b11g b11g@protonmail.com wrote:
>
> > Hi all,
> > I have several BTRFS success-stories, and I've been an happy user for q=
uite a long time now. I was therefore surprised to face a BTRFS corruption =
on a system I'd just installed.
> > I use NixOS, unstable branch (linux kernel 4.19.12). The system runs on=
 a SSD with an ext4 boot partition, a simple btrfs root with some subvolume=
s, and some swap space only used for hibernation. I was working on my serve=
r as normal when I noticed all of my BTRFS subvolumes had been remounted ro=
. After a short time, I started getting various IO errors ("bus error" by j=
ournalctl, "I/O error" by ls etc.). I halted the system (hard reboot), at t=
he reboot the BTRFS partition would not mount. I suspected the corruption t=
o be disk-related, but smartctl does not show any warning for the disk, and=
 the ext4 partition seems healthy.
> > Those are the kernel messages logged when I attempt to mount the partit=
ion:
> > Jan 02 23:39:38 nixos kernel: BTRFS warning (device sdd2): sdd2 checksu=
m verify failed on <L> wanted <A> found <B> level 0
> > Jan 02 23:39:38 nixos kernel: BTRFS error (device sdd2): failed to read=
 block groups: -5
> > Jan 02 23:39:38 nixos systemd[1]: Started Cleanup of Temporary Director=
ies.
> > Jan 02 23:39:38 nixos kernel: BTRFS error (device sdd2): open_ctree fai=
led
>
> Do you have the entire kernel message from the previous boot when the
> problem started, including I/O errors? We kinda need to see what was
> going on leading up to the read only mount, and the bus and I/O
> errors. journalctl -b-1 -k should do it, or using journalctl
> --list-boots to find it. You can redirect to a file with > and then
> attach to the reply if it's small enough, or put it up somewhere like
> Dropbox or Google Drive if it's too big.

Sadly I cannot find the journal file relevant to the boot in which the syst=
em failed in /var/log - only older entries, with no I/O errors. If you have=
 any idea on where to look for logs I can check.


>
> btrfs rescue super -v /dev/sdd2
All Devices:
        Device: id =3D 1, name =3D /dev/sdd2

Before Recovering:
        [All good supers]:
                device name =3D /dev/sdd2
                superblock bytenr =3D 65536

                device name =3D /dev/sdd2
                superblock bytenr =3D <big N>

        [All bad supers]:

All supers are valid, no need to recover


> btrfs insp dump-s -f /dev/sdd2
superblock: bytenr=3D65536, device=3D/dev/sdd2
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0x<C> [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    <ID>
label                   main
generation              6337
root                    <~10^10>
sys_array_size          97
chunk_root_generation   5976
root_level              1
chunk_root              <~10^7>
chunk_root_level        0
log_root                <~10^9>
log_root_transid        0
log_root_level          0
total_bytes             <X:~10^12>
bytes_used              <~10^12>
sectorsize              4096
nodesize                16384
leafsize (deprecated)           16384
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x169
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          SKINNY_METADATA )
cache_generation        6337
uuid_tree_generation    6337
dev_item.uuid           <ID2>
dev_item.fsid           <ID> [match]
dev_item.type           0
dev_item.total_bytes    <X:~10^12>
dev_item.bytes_used     <~10^12>
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM <Y>)
                length <L> owner 2 stripe_len 65536 type SYSTEM
                io_align 4096 io_width 4096 sector_size 4096
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 1 offset <Y>
                        dev_uuid <ID2>
backup_roots[4]:
        backup 0:
<...>

>
> Those are reader only. And also try to mount with -o usebackuproot and
> if that fails -o ro,usebackuproot is often more tolerant. But that's
> for getting data off the volume, it's more useful to know why the file
> system broke. And also why btrfs check is failing, given that it's a
> current version.

I got the data back using btrfs restore, mount -o ro,usebackuproot fails wi=
th the same errors (open_ctree failed).


>
> If you get a chance you can take an image, maybe a Btrfs developer
> will find it useful to understand why the Btrfs check is failing.
>
>  <dev> /path/to/fileoutput.image
>
> That is usually around 1/2 the size of file system metadata. It
> contains no data and filenames will be hashed.
>
>
> -------------------------------------------------------------------------=
-----------------------------------------
>
> Chris Murphy

I tried to take an image but even that fails:
"btrfs-image -c9 -t4 -ss /dev/sdd2 /mnt/metadata.image"
checksum verify failed on <N> found <A> wanted <B>
checksum verify failed on <N> found <A> wanted <B>
Csum didn't match
ERROR: open ctree failed
ERROR: create failed: Success


-b11g
