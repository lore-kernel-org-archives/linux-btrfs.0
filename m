Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:52226 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932137AbdJZQh0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 12:37:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 3BB5A14625D
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:37:24 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id uK1RNdyFf7vo for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 18:37:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id A2ABA14628A
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:37:22 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LBfI3M9CiEPW for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 18:37:22 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id AE64314625D
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:37:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id A81D31002F4
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:37:21 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pQ63daoBOKsv for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 18:37:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 4A7871005C0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:37:21 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YXG-RvysGa81 for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 18:37:21 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 271221002F4
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 18:37:21 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>        <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>        <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>        <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>        <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de>        <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>        <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de>        <20171021180752.iqkspyi2whnm4vui@angband.pl>        <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com>        <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de>        <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com>        <001001d34ce7$42c576f0$c85064d0$@helmholtz-muenchen.de>        <006101d34e54$78c608a0$6a5219e0$@helmholtz-muenchen.de> <23025.56120.834544.576310@tree.ty.sabi.co.uk>
In-Reply-To: <23025.56120.834544.576310@tree.ty.sabi.co.uk>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Thu, 26 Oct 2017 18:37:20 +0200 (CEST)
Message-ID: <011601d34e78$b184d170$148e7450$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
[mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Peter Grandi
> Sent: Thursday, October 26, 2017 2:55 PM
> To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
> Subject: RE: SLES 11 SP4: can't mount btrfs
> 
> > I formatted the / partition with Btrfs again and could restore
> > the files from a backup.  Everything seems to be there, I can
> > mount the Btrfs manually. [ ... ] But SLES finds from where I
> > don't know a UUID (see screenshot). This UUID is commented out
> > in fstab and replaced by /dev/vg1/lv_root. Using
> > /dev/vg1/lv_root I can manually mount my Btrfs without any
> > problem. Where does my SLES find that UUID ?
> 
> This sounds like a SLES issue, rather than a Btrfs one.
> 
> But it could simply be that you have forgotten to refresh the
> 'initramfs' with 'mkinitrd' after modifying the '/etc/fstab'.

I finally managed it. I'm pretty sure having changed /boot/grub/menu.lst,
but somehow changes got lost/weren't saved ?
After entering the new UUID from my Btrfs partition system boots.

Sorry for PM Peter.


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

