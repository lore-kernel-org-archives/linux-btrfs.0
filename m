Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:51883 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdJVKhG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Oct 2017 06:37:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 6336A144CD7
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 12:37:04 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id EJXAmPx4eJRH for <linux-btrfs@vger.kernel.org>;
        Sun, 22 Oct 2017 12:37:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id F2840144C93
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 12:37:01 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ng-IEt-Vi31N for <linux-btrfs@vger.kernel.org>;
        Sun, 22 Oct 2017 12:37:01 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id C5F24144CD7
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 12:37:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id BEF4D1001E8
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 12:37:01 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WuEbkzJZTGgg for <linux-btrfs@vger.kernel.org>;
        Sun, 22 Oct 2017 12:37:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id E06E51004F2
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 12:37:00 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tuhojBUxMWvv for <linux-btrfs@vger.kernel.org>;
        Sun, 22 Oct 2017 12:37:00 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id B88F91001E8
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 12:37:00 +0200 (CEST)
Date: Sun, 22 Oct 2017 12:36:59 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Btrfs ML <linux-btrfs@vger.kernel.org>
Message-ID: <1444095567.8220834.1508668619882.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <20171021180752.iqkspyi2whnm4vui@angband.pl>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de> <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com> <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com> <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de> <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de> <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net> <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de> <20171021180752.iqkspyi2whnm4vui@angband.pl>
Subject: Re: SLES 11 SP4: can't mount btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----- Am 21. Okt 2017 um 20:07 schrieb Adam Borowski kilobyte@angband.pl:

>> > Yes it's possible to restore a btrfs partition from tape backup, /if/ you
>> > backed up the partition itself, not just the files on top of it.
> 
> Which is usually a quite bad idea: unless you shut down (or remount ro) the
> filesystem in question, the data _will_ be corrupted, and in the case of
> btrfs, this kind of corruption tends to be fatal.  You also back up all the
> unused space (trim greatly recommended), and the backup process takes ages
> as it needs to read everything.
> 
> An efficient block-level backup of btrfs _would_ be possible as it can
> nicely enumerate blocks touched since generation X, but AFAIK no one wrote
> such a program yet.  It'd be also corruption free if done in two passes:
> first a racey copy, fsfreeze(), copy of just newest updates.
> 
>> > Otherwise, as you deduce, you get the files, but not the snapshot history
>> > or relationship, nor the subvolumes, which will look to normal file-level
>> > backup software (that is, backup software not designed with btrfs-
>> > specifics like subvolumes, which if it did, would likely use btrfs send/
>> > receive at least optionally) like normal directories.
> 
> If the backup software does incrementals well, this is not as bad as it
> sounds.  While rsync takes half an hour just to stat() a typical small piece
> spinning rust (obviously depending on # of files), that's still in the
> acceptable range.  That backup software can be then be told to back every
> snapshot in turn.  You still lose reflinks between unrelated subvolumes but
> those tend to be quite rare -- and you can re-dedupe.
> 
>> i apprehend that i have just a file based backup.  We use EMC Networker
>> (version 8.1 or 8.2), and from what i read in the net i think it does not
>> support BTRFS.  So i have to reinstall, which is maybe not the worst,
>> because i'm thinking about using SLES 11 SP3.
>> 
>> What i know now is that i can't rely on our EMC backup.
>> What would you propose to backup a complete btrfs partition
>> (https://btrfs.wiki.kernel.org/index.php/Incremental_Backup) ?
>> We have a NAS with propable enough space, and the servers aren't used
>> heavily over night.  So using one of the mentioned tools in a cronjob over
>> night is possible.
> 
>> Which tool do you recommend ?
> 
> It depends on what you use subvolumes for.
> 
> While a simple file-base backup may be inadequate for the general case, for
> most actual uses it works well or at least well enough.  Only if you're
> doing something special, bothering with the complexity might be worth it.
> 
> 

SLES creates a resonable number of subvolumes for e.g. /var/lib, /var/log, /tmp ...
About 15 on a normal system. My setup would be a root-Partition on btrfs, with all the subvolumes.
Here mount from a SLES 12 SP2 system:
/dev/sda1 on / type btrfs (rw,ssd,space_cache,subvolid=1011,subvol=/@/.snapshots/355/snapshot)
/dev/sda1 on /var/crash type btrfs (rw,relatime,ssd,space_cache,subvolid=264,subvol=/@/var/crash)
/dev/sda1 on /var/log type btrfs (rw,relatime,ssd,space_cache,subvolid=268,subvol=/@/var/log)
/dev/sda1 on /boot/grub2/x86_64-efi type btrfs (rw,relatime,ssd,space_cache,subvolid=259,subvol=/@/boot/grub2/x86_64-efi)
/dev/sda1 on /var/tmp type btrfs (rw,relatime,ssd,space_cache,subvolid=271,subvol=/@/var/tmp)
/dev/sda1 on /var/opt type btrfs (rw,relatime,ssd,space_cache,subvolid=269,subvol=/@/var/opt)
/dev/sda1 on /usr/local type btrfs (rw,relatime,ssd,space_cache,subvolid=263,subvol=/@/usr/local)
/dev/sda1 on /opt type btrfs (rw,relatime,ssd,space_cache,subvolid=260,subvol=/@/opt)
/dev/sda1 on /var/lib/named type btrfs (rw,relatime,ssd,space_cache,subvolid=266,subvol=/@/var/lib/named)
/dev/sda1 on /var/spool type btrfs (rw,relatime,ssd,space_cache,subvolid=270,subvol=/@/var/spool)
/dev/sda1 on /var/lib/mailman type btrfs (rw,relatime,ssd,space_cache,subvolid=265,subvol=/@/var/lib/mailman)
/dev/sda1 on /var/lib/pgsql type btrfs (rw,relatime,ssd,space_cache,subvolid=267,subvol=/@/var/lib/pgsql)
/dev/sda1 on /tmp type btrfs (rw,relatime,ssd,space_cache,subvolid=262,subvol=/@/tmp)
/dev/sda1 on /boot/grub2/i386-pc type btrfs (rw,relatime,ssd,space_cache,subvolid=258,subvol=/@/boot/grub2/i386-pc)
/dev/sda1 on /srv type btrfs (rw,relatime,ssd,space_cache,subvolid=261,subvol=/@/srv)
/dev/sda1 on /.snapshots type btrfs (rw,relatime,ssd,space_cache,subvolid=275,subvol=/@/.snapshots)

My setup would be identical.
It will be a node of a HA-cluster, no databases or s.th. else on the root-Partition. The resources are virtual machines on dedicated partitions.

What would be the appropriate backup solution from https://btrfs.wiki.kernel.org/index.php/Incremental_Backup to be able to restore the complete btrfs partition 
including all subvolumes if i have a complete corruption like now ?

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

