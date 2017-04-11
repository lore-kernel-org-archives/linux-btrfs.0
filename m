Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33705 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdDKLQ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 07:16:27 -0400
Received: by mail-io0-f193.google.com with SMTP id k87so1274133ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 04:16:27 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id m41sm755475iti.0.2017.04.11.04.16.24
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Apr 2017 04:16:25 -0700 (PDT)
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: linux-btrfs@vger.kernel.org
References: <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
 <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
 <20170410144533.664fc304@jupiter.sol.kaishome.de>
 <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
 <20170410184444.08ced097@jupiter.sol.local>
 <20170410185437.235b3b86@jupiter.sol.kaishome.de>
 <7ea65b63-d399-c049-d466-681c1df2d025@gmail.com>
 <20170410201842.216893be@jupiter.sol.kaishome.de>
 <ce3ddbc7-da26-9fc7-e783-e9d566009ae8@gmail.com>
 <20170411060119.65b34774@jupiter.sol.kaishome.de>
 <20170411095552.o5b4wysjqlbp57xa@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8bbd6b5c-58c8-62d2-78de-76ce31ff0bc9@gmail.com>
Date: Tue, 11 Apr 2017 07:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <20170411095552.o5b4wysjqlbp57xa@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-11 05:55, Adam Borowski wrote:
> On Tue, Apr 11, 2017 at 06:01:19AM +0200, Kai Krakow wrote:
>> Yes, I know all this. But I don't see why you still want noatime or
>> relatime if you use lazytime, except for super-optimizing. Lazytime
>> gives you POSIX conformity for a problem that the other options only
>> tried to solve.
>
> (Besides lazytime also working on mtime, and, technically, ctime.)
Nope, it by definition can't work on ctime because a ctime update means 
something else changed in the inode, which in turn will cause it to be 
flushed to disk normally (lazytime only defers the flush as long as 
nothing else in the inode is different, so it won't help much on stuff 
like traditional log files because their size is changing regularly 
(which updates the inode, which then causes it to get flushed)).
>
> First: atime, in any form, murders snapshots.  On any filesystem that has
> them, not just btrfs -- I've tested zfs and LVM snapshots, there's also
> qcow2/vdi and so on.  On all of them, every single read-everything operation
> costs you 5% disk space.  For a _read_ operation!
>
> I've tested /usr-y mix of files, for consistency with the guy who mentioned
> this problem first.  Your mileage will vary depending on whether you store
> 100GB disk images or a news spool.
>
> Read-everything is quite rare, but most systems have at least one
> stat-everything cronjob.  That touches only diratime, but that's still
> 1-in-11 inodes (remarkably consistent: I've checked a few machines with
> drastically different purposes, and somehow the min was 10, max 12).
>
> And no, marking snapshots as ro doesn't help: reading the live version still
> breaks CoW.
>
>
> Second: atime murders media with limited write endurance.  Modern SSD can
> cope well, but I for one work a lot with SD and eMMC.  Every single SoC
> image I've seen uses noatime for this reason.
Even on SSD's it's still an issue, especially if it's something like 
ext4 which uses inode tables (updating one inode will usually require a 
RMW of an erase block regardless, but using inode tables means that this 
happens _all the time_).
>
>
> Third: relatime/lazytime don't eliminate the performance cost.  They fix
> only frequently read files -- if you have a big filesystem where you read a
> lot but individual files tend to be read rarely, relatime is as bad as
> strictatime, and lazytime actually worse.  Both will do an unnecessary write
> of all inodes.
>
>
> Four: why?  Beside being POSIXLY_CORRECT, what do you actually gain from
> atime?  I can think only of:
> * new mail notification with mbox.  Just patch the mail reader to manually
>   futimens(..., {UTIME_NOW,UTIME_OMIT}), it has no extra cost on !noatime
>   mounts.  I've personally did so for mutt, the updated version will ship
>   in Debian stretch; you can patch other mail readers although they tend
>   to be rarely used in conjunction with shell access (and thus they have
>   no need for atime at all).
> * Debian's popcon's "vote" field.  Use "inst", and there's no gain from
>   popcon for you personally.
> * some intrusion detection forensics (broken by open(..., O_NOATIME))
On top of all that:
Five:
Handling of atime slows down stat and a handful of other things.  If you 
take a source tree the size of the Linux kernel, write a patch that 
changes every file (even just one character), and then go to commit it 
in Git (or SVN, or Bazaar, or Mercurial), you'll see a pretty serious 
difference in the time it takes to commit because almost all VCS 
software calls stat() on the entire tree.  relatime won't help much here 
because the check to determine whether or not to update the atime still 
has to happen (in fact, it will hurt slightly, strictatime eliminates 
that check).

Six:
It doesn't behave how most users would inherently expect, partly because 
there are ways to bypass it even if the FS is mounted with strictatime.
>
>
> Conclusion: death to atime!
>

