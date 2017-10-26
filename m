Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:58762 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932340AbdJZSBI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:01:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 629C5146162
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 20:01:07 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ccp5Vx7_IPH4 for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 20:01:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id EF4D9146285
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 49g1IbnyCPuB for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id C2A9D146253
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id BA07310059F
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 8HZaRs6RV4xw for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 5919E1005A8
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A7g1Y8lvp15b for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 3792310059F
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 20:01:05 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de> <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de> <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net> <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de> <20171021180752.iqkspyi2whnm4vui@angband.pl> <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com> <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de> <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com> <001001d34ce7$42c576f0$c85064d0$@helmholtz-muenchen.de> <006101d34e54$78c608a0$6a5219e0$@helmholtz-muenchen.de> <7b63351c-52f0-d95c-0ec1-6b2a73c46998@gmail.com>
In-Reply-To: <7b63351c-52f0-d95c-0ec1-6b2a73c46998@gmail.com>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Thu, 26 Oct 2017 20:01:04 +0200 (CEST)
Message-ID: <014301d34e84$63eca8a0$2bc5f9e0$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: Andrei Borzenkov [mailto:arvidjaar@gmail.com]
> Sent: Thursday, October 26, 2017 6:51 PM
> To: Lentes, Bernd <bernd.lentes@helmholtz-muenchen.de>; Btrfs ML 
> <linux-btrfs@vger.kernel.org>
> Subject: Re: SLES 11 SP4: can't mount btrfs

>
> root device information is stored in initrd, you need to rebuild it.
> Just run mkinitrd after you boot system.

I can't confirm that. Just moved an old SLES 10 SP4 from one host to the 
other. Just changed menu.lst (GRUB) and fstab, system is booting. No need to 
rebuild initrd.
But maybe just because it's an old system.


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

