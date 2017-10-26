Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:38904 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932301AbdJZMSL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 08:18:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 12B55145DAA
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:18:09 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id DuoMTvd169D4 for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 14:18:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 1961D145D7A
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:18:07 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id I2mCuWe89WAs for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 14:18:06 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id 5A8A11461EE
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:18:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 5240D100665
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:18:06 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pTZxl4HKiFqP for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 14:18:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 8DCC01006FA
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:18:05 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id D3y3hqYMZXEF for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 14:18:05 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 40655100674
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:18:05 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de> <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de> <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net> <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de> <20171021180752.iqkspyi2whnm4vui@angband.pl> <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com> <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de> <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com> <001001d34ce7$42c576f0$c85064d0$@helmholtz-muenchen.de>
In-Reply-To: <001001d34ce7$42c576f0$c85064d0$@helmholtz-muenchen.de>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Thu, 26 Oct 2017 14:18:03 +0200 (CEST)
Message-ID: <006101d34e54$78c608a0$6a5219e0$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org 
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Lentes, Bernd
> Sent: Tuesday, October 24, 2017 6:44 PM
> To: Btrfs ML <linux-btrfs@vger.kernel.org>
> Subject: RE: SLES 11 SP4: can't mount btrfs
>
>
> >
> > A short-term alternative, if you've got a full backup of what SLES
> > mounts as /, is to run a regular install, boot the system, and then
> > extract the backup on top of /.  It's not perfect, but it should work
> > well enough.
>
> That's what I'm currently trying. I will keep you informed.
>

I was able to restore the root fs. I formatted the / partition with Btrfs 
again and could restore the files from a backup.
Everything seems to be there, I can mount the Btrfs manually.
But booting does not work. My Btrfs resides on a logical volume. I changed 
/boot/grub/menu.lst and /etc/fstab to point to the lv. Before it was 
pointing to a UUID.
But booting my SLES complains that it does not find the root fs. screenshot: 
https://hmgubox.helmholtz-muenchen.de/f/2d6b374e8a8b40569d4f/?dl=1

I can manually mount from the booted SLES. So everything (Btrfs, lvm) seems 
to be available. I added in menu.lst and fstab the path to the device node 
(/dev/vg1/lv_root), which works on other systems the same way, the only 
difference is there I have ext3.
But SLES finds from where I don't know a UUID (see screenshot). This UUID is 
commented out in fstab and replaced by /dev/vg1/lv_root. Using 
/dev/vg1/lv_root I can manually mount my Btrfs without any problem.

Where does my SLES find that UUID ? It is not available unter 
/dev/disk/by-uuid. Can I change that value ?

Thanks for any help.


Bernd
 

Helmholtz Zentrum Muenchen
Deutsches Forschungszentrum fuer Gesundheit und Umwelt (GmbH)
Ingolstaedter Landstr. 1
85764 Neuherberg
www.helmholtz-muenchen.de
Aufsichtsratsvorsitzende: MinDir'in Baerbel Brumme-Bothe
Geschaeftsfuehrer: Prof. Dr. Guenther Wess, Heinrich Bassler, Dr. Alfons Enhsen
Registergericht: Amtsgericht Muenchen HRB 6466
USt-IdNr: DE 129521671

