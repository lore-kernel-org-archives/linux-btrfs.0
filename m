Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f50.google.com ([209.85.167.50]:40728 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeIOJOT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Sep 2018 05:14:19 -0400
Received: by mail-lf1-f50.google.com with SMTP id x26-v6so9455135lfi.7
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 20:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
 <pan$425cf$32d9f075$987b0e87$b2aa40b1@cox.net>
In-Reply-To: <pan$425cf$32d9f075$987b0e87$b2aa40b1@cox.net>
From: "James A. Robinson" <jim.robinson@gmail.com>
Date: Fri, 14 Sep 2018 20:56:13 -0700
Message-ID: <CAPd04b6Zd3=u7Fna3NJu=fNE4xRG--AY6EDR55Q0XNW9fe+z4A@mail.gmail.com>
Subject: Re: state of btrfs snapshot limitations?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wow, thank to everyone for all that information, I'm going to have to
take some time to digest everything. :)

I just wanted to quickly say one thing: As Duncan surmised, I'm not
treating this as my primary backup, but more of an experimental add-on
feature.  The primary backup goes to an ext4 partition that is then
rsynced to a 'current' btrfs subvolume, the latter is what I'm taking
snapshots of.  These both share a RAID 1+0 enclosure.  The partitions
are oversized, 3TB each, so based on this thread that size is something
to watch out for if I use up a lot more of the space.

For other backups I've also got a Amazon Glacier based backup (large
"offsite" but painful to recover with) via Arq, and an Apple
TimeCapsule backup (easy point-and-click restore for a single item, but
damn flakey and painfully slow for anything complicated).  So I'm not
trusting any one device or scheme.

As an aside, one of the things I loved about reading the Plan 9 papers
was their description of their three-tier storage.  Where they had "infinite"
long term storage via a WORM array, SCSI disks on big servers for the
"cache," and then local disk / memory for the files they were working
on right at that moment (http://doc.cat-v.org/plan_9/misc/cw/cw.pdf).

I do like the idea of periodic "copy to a clean disk" and "mkfs of the
old disk" scheme instead of a complicated in-place rebuilding and/or
defragmentation, I think I have enough capacity that I will probably
try that if/when it becomes necessary.

I've got to read up a bit more on subvolumes, I am missing some
context from the warnings given by Chris regarding per-subvolume
options.
