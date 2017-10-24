Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:42057 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbdJXQnv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 12:43:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id CE45B1442C2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 18:43:49 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 6pWRJbh4p3d8 for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 18:43:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 239B3143B35
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 18:43:48 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id C_h5wmeajAWf for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 18:43:48 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id ECA9614375E
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 18:43:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id E3AA710048B
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 18:43:47 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id W4DkmaW8e74w for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 18:43:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 78F87100706
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 18:43:47 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fLRslQx8UOqY for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 18:43:47 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 5868B10048B
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 18:43:47 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de> <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de> <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net> <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de> <20171021180752.iqkspyi2whnm4vui@angband.pl> <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com> <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de> <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com>
In-Reply-To: <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Tue, 24 Oct 2017 18:43:46 +0200 (CEST)
Message-ID: <001001d34ce7$42c576f0$c85064d0$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org 
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Austin S. 
> Hemmelgarn
> Sent: Tuesday, October 24, 2017 4:05 PM
> To: Lentes, Bernd <bernd.lentes@helmholtz-muenchen.de>; Btrfs ML 
> <linux-btrfs@vger.kernel.org>
> Subject: Re: SLES 11 SP4: can't mount btrfs
>
> A short-term alternative, if you've got a full backup of what SLES
> mounts as /, is to run a regular install, boot the system, and then
> extract the backup on top of /.  It's not perfect, but it should work
> well enough.

That's what I'm currently trying. I will keep you informed.

> As mentioned, I'm working on a script to handle this for tools like
> Amanda and Bareos.  I plan to send a message out on the list when that's
> sufficiently working that I think it's safely usable, I can make sure
> you're on CC for that message as well if you like.  I hoped to have
> something later this week, but things are busier than expected at work
> this week, so it might be a while.

Please put me on cc. That would be great. Thanks.


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

