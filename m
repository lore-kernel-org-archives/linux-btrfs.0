Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658F4C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D5221B1C
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:47:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOtemjQN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfBPUqi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 15:46:38 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:51904 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbfBPUqh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 15:46:37 -0500
Received: by mail-it1-f194.google.com with SMTP id y184so32418532itc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 12:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q+Efuinff9TIIymqNmmu6oASdkAinjiKu+Y2Fn//alY=;
        b=IOtemjQNe7+YYOLZNVJ4B1sy2yp9qs3gBMNVIFqlhmaz9R3WnTLFYKl0jzdPdTP20Q
         SxQctzqW6Cl3cELemR3e6GfojRZ7yY0ZOu4Sj8fwWc6bvOT12SOiZo8FBAGH/tuUtHUu
         koFR2eeq4dsFlEXAl8+q4ydgCDYvSR4VH+VB3tS5eHU+fY6sFpTdVsvsUNuZuFgay9j9
         m3Krn4EGevJal1A5TTcok0XyXgUWa+a28vKhdko/TXtwp3avXsthITmX/gNay6zeLyX+
         hu+TcfymhedI5aqO17EaBjq81j3R7cSq44inmM1yutsVvhwbXiqsSoSBEdZW0tZhakPG
         XTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q+Efuinff9TIIymqNmmu6oASdkAinjiKu+Y2Fn//alY=;
        b=WE9kQi7oJcqH+5pLl1+2teexzxGmpwtu6nIRTsHwv9xhS0jqgk59LbASZpwIYDGBZ3
         GAcZKdyZCO1l8kgw5xgPrSMy6kzGw/Ye+nCAE1kZich+/qE5J1WcXBPG3AXoHIE0iK0h
         zFwoYdTBSmni1YSqz2hYwcNN3uNEy3kYGu+znr0iQlQ11wcEUgOE/PDUMgfJ9dVek3aX
         qjUV9/HXU6VpYmj/pbd5rUq1nxmwFpLlxxQoEAn9RhE+So16A7aR7y/+9YTr1VRjTYvh
         JkLB2qV5cZla3Kf8ABQuPNwbE1Li8HbfICNBu6elOMwmz1ZacPxh+ConBKzet7nUQTlF
         OVnQ==
X-Gm-Message-State: AHQUAuaXc1MzshzNqyL+JHj7v45jbnUCHsduM1bptpE+U98veAgxukwu
        s+dLQByQa31sTgBWHy43O5ctf4uUgm0IDVrErT8=
X-Google-Smtp-Source: AHgI3IafImfgXazipuOUiM18l63H+sjvKj6QyXfjL/UJsdn6XAk+KP6huAlgItosxtutLrgMCGXQvmbzaudgyAsFGP4=
X-Received: by 2002:a24:4e0d:: with SMTP id r13mr7726550ita.140.1550349996512;
 Sat, 16 Feb 2019 12:46:36 -0800 (PST)
MIME-Version: 1.0
References: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
 <6a9c683a-bb47-109a-753d-010613ae595a@gmx.com>
In-Reply-To: <6a9c683a-bb47-109a-753d-010613ae595a@gmx.com>
From:   =?UTF-8?Q?Martin_P=C3=B6hlmann?= <mpdeimos@gmail.com>
Date:   Sat, 16 Feb 2019 21:46:25 +0100
Message-ID: <CAG245DWL8+kEeMZ6WF2g0gWN+pjY=94704jvAwXVPeXuGuy-0g@mail.gmail.com>
Subject: Re: Btrfs corruption: Cannot mount partition
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks a lot for your help.

@Qu Wenruo: WIll zero log after completing the backup
@Chris Murphy: First of all, mount -ro,nologreplay works.

dump-tree displays two items:

# btrfs insp dump-tree -b 88560877568 --follow /dev/mapper/cryptroot
btrfs-progs v4.19.1
leaf 88560877568 items 2 free space 15355 generation 554510 owner TREE_LOG
leaf 88560877568 flags 0x1(WRITTEN) backref revision 1
fs uuid bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
chunk uuid 25cacaa1-59ec-4c71-92e0-4b31f7937521
item 0 key (TREE_LOG ROOT_ITEM 258) itemoff 15844 itemsize 439
generation 554510 root_dirid 0 bytenr 88560812032 level 1 refs 0
lastsnap 0 byte_limit 0 bytes_used 376832 flags 0x0(none)
uuid 00000000-0000-0000-0000-000000000000
drop key (0 UNKNOWN.0 0) level 0
item 1 key (TREE_LOG ROOT_ITEM 259) itemoff 15405 itemsize 439
generation 554510 root_dirid 0 bytenr 917389312 level 0 refs 0
lastsnap 0 byte_limit 0 bytes_used 0 flags 0x0(none)
uuid 00000000-0000-0000-0000-000000000000
drop key (0 UNKNOWN.0 0) level 0


Regards 2nd mail:

1. as mentioned, mount with nologreplay works. Will update backups with tha=
t.
2. Used btrfs restore already for initial backup. Did a good job.
3. Have to figure out how to get a usb-bootable recovery system w/ 5.0rc6 f=
irst.

On Sat, Feb 16, 2019 at 1:54 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/2/16 =E4=B8=8A=E5=8D=885:31, Martin P=C3=B6hlmann wrote:
> > Hello,
> >
> > After a reboot I am lost with an unmountable BTRFS partition. Before
> > reboot I had first compile problems with freezing IntelliJ. These
> > persisted after a first reboot, after a second reboot I am faced with
> > the following error after entering the dm-crypt password (also after
> > manual mount with -o ro,recovery, see attached dmesg):
>
> [Move check result here]
> > # btrfs check --readonly /dev/mapper/cryptroot
> > [1/7] checking root items
> > [2/7] checking extents
> > [3/7] checking free space cache
> > [4/7] checking fs roots
> > root 258 inode 776 errors 200, dir isize wrong
> > root 258 inode 1131031 errors 1, no inode item
> >         unresolved ref dir 776 index 87215 namelen 17 name
> > TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> > root 258 inode 2911226 errors 1, no inode item
> >         unresolved ref dir 776 index 160611 namelen 17 name
> > TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> > ERROR: errors found in fs roots
> > Opening filesystem to check...
> > Checking filesystem on /dev/mapper/cryptroot
> > UUID: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
> > found 409699909636 bytes used, error(s) found
> > total csum bytes: 390595732
> > total tree bytes: 5061541888
> > total fs tree bytes: 4224024576
> > total extent tree bytes: 339312640
> > btree space waste bytes: 892618468
> > file data blocks allocated: 529336496128
> >  referenced 490479570944
> >
> So there is just some minor problem in fs trees, not a big problem, and
> your extent tree passes the check, so it's not on-disk data corruption.
>
> >
> > [ 6098.921985] BTRFS error (device dm-0): unable to find ref byte nr
> > 390335463424 parent 0 root 2
> > [ 6098.922473] BTRFS: error (device dm-0) in __btrfs_free_extent:6828:
> > errno=3D-2 No such entry
> > [ 6098.922526] BTRFS: error (device dm-0) in
> > btrfs_run_delayed_refs:2978: errno=3D-2 No such entry
> > [ 6098.922601] BTRFS: error (device dm-0) in btrfs_replay_log:2267:
> > errno=3D-2 No such entry (Failed to recover log tree)
> > [ 6098.972326] BTRFS error (device dm-0): open_ctree failed
>
> It's log recovery causing problem.
>
> You could just use "btrfs rescue zero-log" to recovery it.
>
> Thanks,
> Qu
>
> >
> > I've searched for a solution on the web, but most articles tell to do
> > nothing, but write to this mailing list. So my hopes are that you can
> > shed some light into what I can do.
> >
> > I've found a quite recent thread here
> > (https://lore.kernel.org/linux-btrfs/5b0d2e94-6e4e-aecd-3eda-459c4a96bb=
13@mokrynskyi.com/)
> > but this just mentions a fix for 'Fix missing reference aborts when
> > resuming snapshot delete' and is not further specific.
> >
> > Setup of my SSD looks like:
> >
> > * efi
> > * dm-crypt plain. Contains BTRFS (w/o lvm or similar). Several
> > subvolumes (/, /home, ...)
> > * swap
> >
> > I've already run btrfs restore on volid 258 (home) and gathered lots
> > of data from the disk (>200GB). I also have a dd backup of the
> > cryptroot after the failure happened (in case something goes wrong).
> > Besides I did not do any fix attempts yet. If there is anything I can
> > do to get the system working again, I'm happy to hear.
> >
> > Thanks!
> >
> > My Linux system is Arch Linux (up to date), logs below come from the
> > Arch install medium .
> >
> > # uname -a
> > Linux archiso 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01
> > UTC 2019 x86_64 GNU/Linux
> >
> > # btrfs --version
> > btrfs-progs v4.19.1
> >
> > # btrfs fi show
> > Label: 'root'  uuid: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
> >         Total devices 1 FS bytes used 381.56GiB
> >         devid    1 size 460.39GiB used 393.01GiB path /dev/mapper/crypt=
root
> >
>
