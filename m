Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:50662 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbdJTSkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 14:40:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 0BB3014553B
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 20:40:19 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id W_-7vni9S934 for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 20:40:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 17A32145B3C
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 20:40:17 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RNQbAH2MpFa1 for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id DDAFB14553B
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id D3FF010006A
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5U6rYK7vPss2 for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 6279A10051B
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GLi3zebvGuio for <linux-btrfs@vger.kernel.org>;
        Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 41BAF10006A
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 20:40:16 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Btrfs ML" <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
In-Reply-To: <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
Subject: RE: SLES 11 SP4: can't mount btrfs
Date: Fri, 20 Oct 2017 20:40:15 +0200 (CEST)
Message-ID: <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Lentes, Bernd
> Sent: Friday, October 20, 2017 7:26 PM
> To: Btrfs ML <linux-btrfs@vger.kernel.org>
> Subject: RE: SLES 11 SP4: can't mount btrfs
>
>
> > -----Original Message-----
> > From: Andrei Borzenkov [mailto:arvidjaar@gmail.com]
> > Sent: Friday, October 20, 2017 6:09 AM
> > To: Chris Murphy <lists@colorremedies.com>; Lentes, Bernd
> > <bernd.lentes@helmholtz-muenchen.de>
> > Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
> > Subject: Re: SLES 11 SP4: can't mount btrfs
> >
>
> Hi Andrei,
>
> thanks for that info. So I will not waste my time and restore from a
> backup.
> Or fresh installation with SLES 12 SP3 on my two cluster nodes, because
> SLES
> 11 SP4 is pretty old and support ends in beginning of 2019.
> I also found the culprit for the disaster: the battery from the 
> write-cache
> of the RAID-Controller was empty, I ordered a new one.
>

Is it generally possible to restore a btrfs partition from a tape backup ?
I'm just starting, and I'm asking myself. What is about the subvolumes ?
This information isn't stored in files, but in the fs ? This is not on a 
file-based backup on a tape.

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

