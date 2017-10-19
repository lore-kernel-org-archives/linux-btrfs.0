Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtaextp1.scidom.de ([146.107.103.20]:46457 "EHLO
        mtaextp1.scidom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbdJSRuz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 13:50:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 14BCD14614B
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:43:41 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id S3sa24LnpokU for <linux-btrfs@vger.kernel.org>;
        Thu, 19 Oct 2017 19:43:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 41235146159
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:43:39 +0200 (CEST)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DALOvGJplMg6 for <linux-btrfs@vger.kernel.org>;
        Thu, 19 Oct 2017 19:43:39 +0200 (CEST)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id 0E3A714614B
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:43:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 06E2C100248
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:43:39 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id CFSBgkiuSAse for <linux-btrfs@vger.kernel.org>;
        Thu, 19 Oct 2017 19:43:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 5946E10066A
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:43:38 +0200 (CEST)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cvAXBJzxbiBZ for <linux-btrfs@vger.kernel.org>;
        Thu, 19 Oct 2017 19:43:38 +0200 (CEST)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 3997C100248
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:43:38 +0200 (CEST)
Date: Thu, 19 Oct 2017 19:43:37 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Btrfs ML <linux-btrfs@vger.kernel.org>
Message-ID: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
Subject: SLES 11 SP4: can't mount btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is the continuation of a thread i started on a SLES forum (https://forums.suse.com/showthread.php?10109-lv-with-btrfs-corrupt-some-tips-please), but i think this is the more appropriate place.
I have a SLES 11 SP4 with a btrfs on top of a logical volume i can't mount anymore. The host was fenced in a two-node cluster, and the boot procedure can't mount the lv, and i reside in simple shell (i assume the one from initrd).

I have a second nearly identical node, so i can give you some information:

ha-idg-2:/etc/corosync # uname -a
Linux ha-idg-2 3.0.101-84-default #1 SMP Tue Oct 18 10:32:51 UTC 2016 (15251d6) x86_64 x86_64 x86_64 GNU/Linux

ha-idg-2:/etc/corosync # rpm -qa|grep -i btrfs
libbtrfs0-3.18.2-0.40.48
btrfsmaintenance-0.1-3.1
btrfsprogs-3.18.2-0.40.48

I try to follow the recommendations on https://btrfs.wiki.kernel.org/index.php/Problem_FAQ.

I booted the system now with knoppix 8.1, which has kernel 4.12.7 and btrfs-progs 4.7.3-1. Is that ok ?
I tried:

mount /dev/vg1/lv_root /lv_root -o recovery,ro
and got:
mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg1-lv_root,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.


and got via dmesg:
[92518.955408] BTRFS info (device dm-0): disk space caching is enabled
[92518.990561] BTRFS error (device dm-0): parent transid verify failed on 196314759168 wanted 793932 found 793496
[92518.990911] BTRFS error (device dm-0): parent transid verify failed on 196314759168 wanted 793932 found 793496
[92518.990919] BTRFS error (device dm-0): failed to read block groups: -5
[92519.070084] BTRFS error (device dm-0): open_ctree failed

next step:

root@Microknoppix:~# btrfs device scan
Scanning for Btrfs filesystems
root@Microknoppix:~#

no result !?!

Now i changed to https://btrfs.wiki.kernel.org/index.php/Restore:

btrfs restore -smSvi /dev/vg1/lv_root /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/ |tee /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/recover.log

I just started it. I get lines like:
offset is 61440
offset is 98304
offset is 4096
offset is 143360
offset is 8192
offset is 184320

or

Error searching /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/@/tmp/localhpsum/assets/doc/help/en
Error searching /mnt/idg-2/SysAdmin_AG_Wurst/recover/ha-idg-1/@/tmp/localhpsum/assets/doc/help/ja/images/callouts

What does that mean ?


Bernd



-- 
Bernd Lentes 

Systemadministration 
institute of developmental genetics 
Gebäude 35.34 - Raum 208 
HelmholtzZentrum München 
bernd.lentes@helmholtz-muenchen.de 
phone: +49 (0)89 3187 1241 
fax: +49 (0)89 3187 2294 

no backup - no mercy
 

Helmholtz Zentrum Muenchen
Deutsches Forschungszentrum fuer Gesundheit und Umwelt (GmbH)
Ingolstaedter Landstr. 1
85764 Neuherberg
www.helmholtz-muenchen.de
Aufsichtsratsvorsitzende: MinDir'in Baerbel Brumme-Bothe
Geschaeftsfuehrer: Prof. Dr. Guenther Wess, Heinrich Bassler, Dr. Alfons Enhsen
Registergericht: Amtsgericht Muenchen HRB 6466
USt-IdNr: DE 129521671

