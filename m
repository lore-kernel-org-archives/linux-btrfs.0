Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:33537 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753338AbdJULqL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Oct 2017 07:46:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 29118146182
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 13:46:10 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id l2JWO4lbviyN for <linux-btrfs@vger.kernel.org>;
        Sat, 21 Oct 2017 13:46:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 7DA58145717
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 13:46:08 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6LMAqqrwqycH for <linux-btrfs@vger.kernel.org>;
        Sat, 21 Oct 2017 13:46:08 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id 4E804145408
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 13:46:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 42E8010009B
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 13:46:08 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GifLhwc4GIBw for <linux-btrfs@vger.kernel.org>;
        Sat, 21 Oct 2017 13:46:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id D0753100664
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 13:46:07 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nPtSMLAR-fKe for <linux-btrfs@vger.kernel.org>;
        Sat, 21 Oct 2017 13:46:07 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id A72F9100663
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 13:46:07 +0200 (CEST)
Date: Sat, 21 Oct 2017 13:46:06 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Btrfs ML <linux-btrfs@vger.kernel.org>
Message-ID: <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de> <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de> <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>
Subject: Re: SLES 11 SP4: can't mount btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



----- Am 21. Okt 2017 um 4:31 schrieb Duncan 1i5t5.duncan@cox.net:

> Lentes, Bernd posted on Fri, 20 Oct 2017 20:40:15 +0200 as excerpted:
> 
>> Is it generally possible to restore a btrfs partition from a tape backup
>> ?
>> I'm just starting, and I'm asking myself. What is about the subvolumes ?
>> This information isn't stored in files, but in the fs ? This is not on a
>> file-based backup on a tape.
> 
> Yes it's possible to restore a btrfs partition from tape backup, /if/ you
> backed up the partition itself, not just the files on top of it.
> 
> Otherwise, as you deduce, you get the files, but not the snapshot history
> or relationship, nor the subvolumes, which will look to normal file-level
> backup software (that is, backup software not designed with btrfs-
> specifics like subvolumes, which if it did, would likely use btrfs send/
> receive at least optionally) like normal directories.
> 
> --

Hi Duncan,

i apprehend that i have just a file based backup. We use EMC Networker (version 8.1 or 8.2), and from what i read in the net i think it
does not support BTRFS. So i have to reinstall, which is maybe not the worst, because i'm thinking about using SLES 11 SP3.

What i know now is that i can't rely on our EMC backup.
What would you propose to backup a complete btrfs partition (https://btrfs.wiki.kernel.org/index.php/Incremental_Backup) ?
We have a NAS with propable enough space, and the servers aren't used heavily over night. So using one of the mentioned tools in a cronjob over night is possible.
Which tool do you recommend ?

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

