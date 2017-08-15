Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36224 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdHOPna (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 11:43:30 -0400
Received: by mail-it0-f50.google.com with SMTP id 77so6164436itj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Aug 2017 08:43:29 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <fff8aae1-285b-ffb4-15b6-d255004fe3c2@gmail.com>
 <1502808076.5369.2.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5a6b2c7a-07a2-1d5c-ea25-9386e680bd7b@gmail.com>
Date: Tue, 15 Aug 2017 11:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <1502808076.5369.2.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-15 10:41, Christoph Anton Mitterer wrote:
> On Tue, 2017-08-15 at 07:37 -0400, Austin S. Hemmelgarn wrote:
>> Go look at Chrome, or Firefox, or Opera, or any other major web
>> browser.
>>    At minimum, they will safely bail out if they detect corruption in
>> the
>> user profile and can trivially resync the profile from another system
>> if
>> the user has profile sync set up.
> 
> Aha,... I'd rather see a concrete reference to some white paper or
> code, where one can really see that these programs actually *do* their
> own checksumming.
> But even from what you claim here now (that they'd only detect the
> corruption and then resync from another system - which is nothing else
> than recovering from a backup), I wouldn't see the big problem with
> EIO.
It isn't a problem if it isn't a false positive.  It is a problem when 
it's not correct and the data is accurate.  This breaks from current 
behavior on BTRFS in a not insignificant way.  As things stand right 
now, -EIO on BTRFS means one of two things:
* The underlying device returned an IO error.
* The data there is incorrect.

While it technically is possible for there to be a false positive with 
CoW, it is a statistical impossibility even at Google and Facebook scale 
(I will comment that I've had this happen (exactly once), but it 
resulted from severe widespread media issues in the storage device that 
should have caused catastrophic failure of the device).

There is no way to avoid false positives without CoW or journaling.  We 
have CoW, and people aren't using it for performance reasons.  Adding 
journaling instead will make performance worse (and brings up the 
important question of whether or not the journal is CoW) for NOCOW, and 
has the potential to make performance worse than without NOCOW.
> 
> 
>> Go take a look at any enterprise
>> database application from a reasonable company, it will almost
>> always
>> support replication across systems and validate data it reads.
> 
> Okay, I already showed you, that PostgreSQL, MySQL, BDB, sqlite can't
> or don't do per default... so which do you mean with the enterprise DB
> (Oracle?) and where's the reference that shows that they really do
> general checksuming? And that EIO would be a problem for their recovery
> strategies?
Again, I never said it had to be checksumming.  Type and range checking 
and validation of the metadata (not through checksumming, but through 
verifying that the metadata makes sense, essentially the equivalent of 
fsck on older filesystems) _is_ done by almost everything dealing with 
databases these days except for trivial one-off stuff.

As far as EIO, see my reply above.
> 
> And again, we're not talking about the WALs (or whatever these programs
> call it) which are there to handle a crash... we are talking about
> silent data corruption.
Reread what I said.  Database _APPLICATION_ is not the same as database 
system.  PGSQL, MySQL, BDB, SQLite, MSSQL, Oracle, etc, are all database 
systems, they provide a database that an application can build on top 
of, and yes, none of them provide any significant protection (except 
possibly MSSQL, but I'm not sure about that and it's not hugely relevant 
to this particular discussion).  Things like MythTV, Bugzilla, Kodi, and 
other stuff that utilize the database for back-end storage (including 
things like many media players and web browsers) are database 
applications.  The distinction here is no different from Linux 
applications versus Linux systems.

In the context of actual applications using the database, it's still not 
rigorous verification like you seem to think I'm talking about, but most 
of them do enough sanity checking that most stuff beyond single bit 
errors in numeric and string types will be caught and at least reported.>
> 
>> Agreed, but there's also the counter argument for log files that
>> most
>> people who are not running servers rarely (if ever) look at old
>> logs,
>> and it's the old logs that are the most likely to have at rest
>> corruption (the longer something sits idle on media, the more likely
>> it
>> will suffer from a media error).
> 
> I wouldn't have any valid prove that it's really the "idle" data, which
> is the most likely one to have silent corruptions (at least not for all
> types of storage medium), but even if this is the case as you say...
> then it's probably more likely to hit the /usr/ /lib/ and so on stuff
> on stable distros... logs are typically rotated and then at least once
> re-written (when compressed).
Except that /usr and /lib are trivial to validate on any modern Linux or 
BSD system because the package manager almost certainly has file 
validation built in.  At minimum, emerge, Entropy, DNF, yum, FreeBSD 
pkg-ng, pkgin, Zypper, YaST2, Nix, and Alpine APK, all have this 
functionality, and there is at least one readily available piece of 
software (debsigs) for dpkg based systems.  Sensibly security minded 
individuals generally already have this type of validation in a cron job 
or systemd timer.
> 
> 
>> Go install OpenSUSE in a VM.  Look at what filesystem it uses.  Go
>> install Solaris in a VM, lo and behold it uses ZFS _with no option
>> for
>> anything else_ as it's root filesystem.  Go install a recent version
>> of
>> Windows server in a VM, notice that it also has the option of a
>> properly
>> checked filesystem (ReFS).  Go install FreeBSD in a VM, notice that
>> it
>> provides the option (which is actively recommended by many people
>> who
>> use FreeBSD) to install with root on ZFS.  Install Android or Chrome
>> OS
>> (or AOSP or Chromium OS) in a VM.  Root the system and take a look
>> at
>> the storage stack, both of them use dm-verity, and Android (and
>> possibly
>> Chrome OS too, not 100% certain) uses per-file AEAD through the VFS
>> encryption API on encrypted devices.
> 
> So your argument for not adding support for this is basically:
> People don't or shouldn't use btrfs for this? o.O
No, you shouldn't be using a CoW filesystem directly for VM image 
storage if you care at all about performance, and especially not BTRFS. 
Even with NOCOW, performance of this on BTRFS is absolutely horrendous. 
This goes double if you're using QCOW2 or other allocate-on-demand 
formats.  Ideal order of decreasing preference if you care about 
performance is:
* Native block devices
* SAN devices
* LVM or ZFS ZVols (believe it or not, ZVols actually get remarkably 
good performance despite being on a CoW backend)
* Simple filesystems like ext4 or XFS that don't do CoW or use log 
structures for data
* Files on ZFS or F2FS
* Most other CoW or log structured filesystems
* BTRFS

BTRFS should literally be your last resort for VM image storage if you 
care about performance.
> 
> 
> 
>>    The fact that some OS'es blindly
>> trust the underlying storage hardware is not our issue, it's their
>> issue, and it shouldn't be 'fixed' by BTRFS because it doesn't just
>> affect their customers who run the OS in a VM on BTRFS.
> 
> Then you can probably drop checksumming from btrfs altogether. And with
> the same "argument" any other advanced feature.
> For resilience there is hardware RAID or Linux' MD raid... so no need
> to keep it in btrfs o.O
**NO**.  That is not what I'm arguing.  That would be regressing BTRFS 
to a state that I'm arguing needs to be _FIXED_ in other systems.  My 
complaint is that operating systems (and by extension, VM's) should be 
doing the checking themselves because they inherently can't rely on the 
underlying storage in almost all cases, in particular in the ones in 
which they are almost always used.

Notice in particular that I mentioned OpenSUSE, which has this 
validation _because_ it uses BTRFS by default for the root filesystem. 
I would have thought that that would not need to be explained here, but 
apparently I was wrong.
> 
> 
>> Most enterprise database apps offer support for
>> replication,
>> and quite a few do their own data validation when reading from the
>> database.
> First of all,... replication != the capability to detect silent data
> corruption.
So how is proper verified replication not able to detect silent data 
corruption exactly?  I mean, that's what RAID1 is and it does provide 
the ability to detect such things (unless your RAID implementation is 
brain dead), it just doesn't fix it reliably by itself.
> 
> You still haven't named a single one which does checksumming per
> default. At least those which are quite popular in the FLOSS world all
> don't seem to do.
Again, checksumming is not the only way to detect data corruption. 
Comparison to other copies, metadata validation (databases aren't just a 
jumble of data, there is required structure that can be validated), and 
type and range checking are all ways of detecting silent corruption.

Are they perfect? No.
Is checksumming better? In some circumstances.
Are they sufficient for most use cases? Absolutely.
