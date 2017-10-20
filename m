Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:45387 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJTR00 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 13:26:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 360F31459F3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 19:26:24 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id H9ihEwzLwD4D for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 19:26:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 8682214543E
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 19:26:21 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EYwS2V_FPXQb for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 19:26:21 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id 615DF145426
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 19:26:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 59A1D100132
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 19:26:21 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 4t638-HOShrB for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 19:26:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id E3EE3100664
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 19:26:20 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7zy8rrox3CtO for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 19:26:20 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id C2054100132
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 19:26:20 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
In-Reply-To: <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Fri, 20 Oct 2017 19:26:20 +0200 (CEST)
Message-ID: <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: Andrei Borzenkov [mailto:arvidjaar@gmail.com]
> Sent: Friday, October 20, 2017 6:09 AM
> To: Chris Murphy <lists@colorremedies.com>; Lentes, Bernd
> <bernd.lentes@helmholtz-muenchen.de>
> Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
> Subject: Re: SLES 11 SP4: can't mount btrfs
>
> 19.10.2017 23:04, Chris Murphy пишет:
> > Btrfs
> > is not just supported by SUSE, it's the default file system.
> >
>
> It is default choice for root starting with SLES12, not in SLES11. But 
> yes, it
> should still be supported.
>
> I do not hold my breath though. For all I can tell transid errors are 
> usually
> fatal and if this is root, it may be easier and faster to just reinstall.

Hi Andrei,

thanks for that info. So I will not waste my time and restore from a backup. 
Or fresh installation with SLES 12 SP3 on my two cluster nodes, because SLES 
11 SP4 is pretty old and support ends in beginning of 2019.
I also found the culprit for the disaster: the battery from the write-cache 
of the RAID-Controller was empty, I ordered a new one.

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

