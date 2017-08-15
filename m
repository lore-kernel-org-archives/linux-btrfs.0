Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35060 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbdHOLhJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 07:37:09 -0400
Received: by mail-io0-f172.google.com with SMTP id m88so2526016iod.2
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Aug 2017 04:37:09 -0700 (PDT)
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fff8aae1-285b-ffb4-15b6-d255004fe3c2@gmail.com>
Date: Tue, 15 Aug 2017 07:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <1502740488.5384.5.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-14 15:54, Christoph Anton Mitterer wrote:
> On Mon, 2017-08-14 at 11:53 -0400, Austin S. Hemmelgarn wrote:
>> Quite a few applications actually _do_ have some degree of secondary
>> verification or protection from a crash.  Go look at almost any
>> database
>> software.
> Then please give proper references for this!
> 
> This is from 2015, where you claimed this already and I looked up all
> the bigger DBs and they either couldn't do it at all, didn't to it per
> default, or it required application support (i.e. from the programs
> using the DB)
> https://www.spinics.net/lists/linux-btrfs/msg50258.html
Go look at Chrome, or Firefox, or Opera, or any other major web browser. 
  At minimum, they will safely bail out if they detect corruption in the 
user profile and can trivially resync the profile from another system if 
the user has profile sync set up.  Go take a look at any enterprise 
database application from a reasonable company, it will almost always 
support replication across systems and validate data it reads.  Note 
that in both cases this isn't the same as BTRFS checking block 
checksums, and I never said that the application had to work without 
issue, even BTRFS and ZFS can only provide that guarantee with multiple 
devices or dup profiles on a single disk, but I can count on one hand 
the software I've used in the last few years that didn't at least fail 
gracefully when fed bad data (and sending -EIO when a checksum fails is 
essentially the same thing).
> 
>> It usually will not have checksumming, but it will almost
>> always have support for a journal, which is enough to cover the
>> particular data loss scenario we're talking about (unexpected
>> unclean
>> shutdown).
> 
> I don't think we talk about this:
> We talk about people wanting checksuming to notice e.g. silent data
> corruption.
> 
> The crash case is only the corner case about what happens then if data
> is written correctly but csums not.
> 
> 
>> In my own experience, the things that use nodatacow fall into one of
>> 4
>> categories:
>> 1. Cases where the data is non-critical, and data loss will be
>> inconvenient but not fatal.  Systemd journal files are a good example
>> of
>> this, as are web browser profiles when you're using profile sync.
> 
> I'd guess many people would want to have their log files valid and
> complete. Same for their profiles (especially since people concerned
> about their integrity might not want to have these synced to
> Mozilla/Google etc.)
Agreed, but there's also the counter argument for log files that most 
people who are not running servers rarely (if ever) look at old logs, 
and it's the old logs that are the most likely to have at rest 
corruption (the longer something sits idle on media, the more likely it 
will suffer from a media error).
> 
> 
>> 2. Cases where the upper level can reasonably be expected to have
>> some
>> degree of handling, even if it's not correction.  VM disk images and
>> most database applications fall into this category.
> 
> No. Wrong. Or prove me that I'm wrong ;-)
> And these two (VMs, DBs) are actually *the* main cases for nodatacow.
Go install OpenSUSE in a VM.  Look at what filesystem it uses.  Go 
install Solaris in a VM, lo and behold it uses ZFS _with no option for 
anything else_ as it's root filesystem.  Go install a recent version of 
Windows server in a VM, notice that it also has the option of a properly 
checked filesystem (ReFS).  Go install FreeBSD in a VM, notice that it 
provides the option (which is actively recommended by many people who 
use FreeBSD) to install with root on ZFS.  Install Android or Chrome OS 
(or AOSP or Chromium OS) in a VM.  Root the system and take a look at 
the storage stack, both of them use dm-verity, and Android (and possibly 
Chrome OS too, not 100% certain) uses per-file AEAD through the VFS 
encryption API on encrypted devices.  The fact that some OS'es blindly 
trust the underlying storage hardware is not our issue, it's their 
issue, and it shouldn't be 'fixed' by BTRFS because it doesn't just 
affect their customers who run the OS in a VM on BTRFS.

As far as databases, I know of only one piece of enterprise level 
database software that doesn't have some kind of handling for this type 
of thing, and it's a a horribly designed piece of software other than 
that too.  Most enterprise database apps offer support for replication, 
and quite a few do their own data validation when reading from the 
database.  And if you care about non-enterprise database apps, then you 
need to worry about the edge case caused by unclean shutdown.
> 
> 
>> And I and most other sysadmins I know would prefer the opposite with
>> the
>> addition of a secondary notification method.  You can still hook the
>> notification to stop the application, but you don't have to if you
>> don't
>> want to (and in cases 1 and 2 I listed above, you probably don't want
>> to).
> 
> Then I guess btrfs is generally not the right thing for such people, as
> in the CoW case it will also give them EIO on any corruptions and their
> programs will fail.
For a single disk?  Yes, I'd agree that BTRFS isn't the correct answer 
unless you're running dup for all profiles on said single disk when you 
care about data safety.  Once you add another though, it's far superior 
to regular RAID because it knows inherently which copy is wrong.
