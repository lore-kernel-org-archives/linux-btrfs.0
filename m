Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:42469 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932793AbdJXN2O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 09:28:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id C3CD8146280
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 15:28:12 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NmifvG2qcPu3 for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 15:28:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 7E73D146233
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 15:28:10 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ntlIKY4ZiCxa for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 15:28:10 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id 4D7CC14525D
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 15:28:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 469AE1006F1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 15:28:10 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WGAE3kBuXBKJ for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 15:28:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 816011006D2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 15:28:08 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aU1gFHMJWP1c for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 15:28:08 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 60D36100658
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 15:28:08 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de> <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de> <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net> <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de> <20171021180752.iqkspyi2whnm4vui@angband.pl> <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com>
In-Reply-To: <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Tue, 24 Oct 2017 15:28:07 +0200 (CEST)
Message-ID: <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: Austin S. Hemmelgarn [mailto:ahferroin7@gmail.com]
> Sent: Tuesday, October 24, 2017 1:53 PM
> To: Adam Borowski <kilobyte@angband.pl>; Lentes, Bernd
> <bernd.lentes@helmholtz-muenchen.de>
> Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
> Subject: Re: SLES 11 SP4: can't mount btrfs
>
> I think partimage _might_ have BTRFS support by now, and if so, that's
> likely to be the best you can get for quite some time.

Unfortunately not: http://www.partimage.org/Supported-Filesystems/

> > It depends on what you use subvolumes for.
> And this is the important part.  If you're just using them to segregate
> workloads (like I do), or exclude things from snapshots (like I used to do
> when I was using snapshots for backups), then any old backup program is
> fine as long as you know enough to replicate the subvolume layout when
> extracting (if you need the same layout that is).  I'm actually working on 
> a
> script to automate this for file-level backups (stuff like Amanda, Bareos,
> and borgbackup), but I don't have anything ready to share yet.>

There seems to be no backup solution which supports BTRFS in a way that I 
can just restore the complete partition with all subvolumes, snapshots ? 
That's bad. A fs can also get corrupt in certain circumstances.
I'd like to have a solution which offers me the possibility to restore a 
root partition in a reasonable time (some hours maximum), completely. Not 
doing many stuff before/afterwards. It seems that's not possible withBTRFS.

And Btrfs check is still limited in what it can do.


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

