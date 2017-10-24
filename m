Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:43787 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdJXLx3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 07:53:29 -0400
Received: by mail-io0-f173.google.com with SMTP id 134so23540412ioo.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 04:53:29 -0700 (PDT)
Subject: Re: SLES 11 SP4: can't mount btrfs
To: Adam Borowski <kilobyte@angband.pl>,
        "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
 <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
 <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
 <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
 <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de>
 <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>
 <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de>
 <20171021180752.iqkspyi2whnm4vui@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com>
Date: Tue, 24 Oct 2017 07:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <20171021180752.iqkspyi2whnm4vui@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-21 14:07, Adam Borowski wrote:
> On Sat, Oct 21, 2017 at 01:46:06PM +0200, Lentes, Bernd wrote:
>> ----- Am 21. Okt 2017 um 4:31 schrieb Duncan 1i5t5.duncan@cox.net:
>>> Lentes, Bernd posted on Fri, 20 Oct 2017 20:40:15 +0200 as excerpted:
>>>
>>>> Is it generally possible to restore a btrfs partition from a tape backup
>>>> ?
>>>> I'm just starting, and I'm asking myself. What is about the subvolumes ?
>>>> This information isn't stored in files, but in the fs ? This is not on a
>>>> file-based backup on a tape.
>>>
>>> Yes it's possible to restore a btrfs partition from tape backup, /if/ you
>>> backed up the partition itself, not just the files on top of it.
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
I think partimage _might_ have BTRFS support by now, and if so, that's 
likely to be the best you can get for quite some time.
> 
>>> Otherwise, as you deduce, you get the files, but not the snapshot history
>>> or relationship, nor the subvolumes, which will look to normal file-level
>>> backup software (that is, backup software not designed with btrfs-
>>> specifics like subvolumes, which if it did, would likely use btrfs send/
>>> receive at least optionally) like normal directories.
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
And this is the important part.  If you're just using them to segregate 
workloads (like I do), or exclude things from snapshots (like I used to 
do when I was using snapshots for backups), then any old backup program 
is fine as long as you know enough to replicate the subvolume layout 
when extracting (if you need the same layout that is).  I'm actually 
working on a script to automate this for file-level backups (stuff like 
Amanda, Bareos, and borgbackup), but I don't have anything ready to 
share yet.>
> While a simple file-base backup may be inadequate for the general case, for
> most actual uses it works well or at least well enough.  Only if you're
> doing something special, bothering with the complexity might be worth it.
SLES (and OpenSUSE in general) does do something special though, they 
use subvolumes and qgroups to replicate multiple independent partitions 
(which is a serious pain in the arse), and they have snapshotting with 
snapper by default as well.  On OpenSUSE at least you can dispense with 
all that crap by telling the installer to not enable snapshot support, 
not sure about SLES though.
