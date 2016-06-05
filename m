Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36782 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbcFEPgd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 11:36:33 -0400
Received: by mail-oi0-f45.google.com with SMTP id j1so193211343oih.3
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 08:36:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465089045.6662.19.camel@scientia.net>
References: <1464977432.1571.20.camel@gmail.com>
	<1464977591.6679.13.camel@scientia.net>
	<1464979359.1571.25.camel@gmail.com>
	<1464980373.6679.28.camel@scientia.net>
	<89aaee85-9ad5-9bde-b4fb-6c4758e8fd34@swiftspirit.co.za>
	<1465089045.6662.19.camel@scientia.net>
Date: Sun, 5 Jun 2016 09:36:32 -0600
Message-ID: <CAJCQCtSLsA5RfPG1Q2m99DHmYCp3EAXkTnZxBbfX8usLvFbgCw@mail.gmail.com>
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        Mitchell Fossen <msfossen@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 4, 2016 at 7:10 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> Well the RAID1 was IMHO still bad choice as it's pretty ambiguous.

That's ridiculous. It isn't incorrect to refer to only 2 copies as
raid1. You have to explicitly ask both mdadm and lvcreate for the
number of copies you want, it doesn't automatically happen. The man
page for mkfs.btrfs is very clear you only get two copies.

What's ambiguous is raid10 expectations with multiple device failures.


> Well I'd say, for btrfs: do away with the term "RAID" at all, use e.g.:
>
> linear = just a bunch of devices put together, no striping
>          basically what MD's linear is

Except this isn't really how Btrfs single works. The difference
between mdadm linear and Btrfs single is more different in behavior
than the difference between mdadm raid1 and btrfs raid1. So you're
proposing tolerating a bigger difference, while criticizing a smaller
one. *shrug*



> mirror (or perhaps something like clones) = each device in the fs
>                                             contains a copy of
>                                             everything (i.e. classic
>                                             RAID1)


If a metaphor is going to be used for a technical thing, it would be
mirrors or mirroring. Mirror would mean exactly two (the original and
the mirror). See lvcreate --mirrors. Also, the lvm mirror segment type
is legacy, having been replaced with raid1 (man lvcreate uses the term
raid1, not RAID1 or RAID-1). So I'm not a big fan of this term.


> striped = basically what RAID0 is

lvcreate uses only striped, not raid0. mdadm uses only RAID0, not
striped. Since striping is also employed with RAIDs 4, 5, 6, 7, it
seems ambiguous even though without further qualification whether
parity exists, it's considered to mean non-parity striping. The
ambiguity is probably less of a problem than the contradiction that is
RAID0.



> replicaN = N replicas of each chunk on distinct devices
> <whatever>-replicaN = N replicas of each chunk NOT necessarily on
>                       distinct devices

This is kinda interesting. At least it's a new term so all the new
rules can be stuffed into that new term and helps distinguish it from
other implementations, not entirely different with how ZFS does this
with their raidz.



> parityN = n parity chunks i.e. parity1 ~= RAID5, parity2 ~= RAID6
> or perhaps better: striped-parityN or striped+parityN ??

It's not easy, is it?


>
> And just mention in the manpage, which of these names comes closest to
> what people understand by RAID level i.

It already does this. What version of btrfs-progs are you basing your
criticism on that there's some inconsistency, deficiency, or ambiguity
when it comes to these raid levels? The one that's unequivocally
problematic alone without reading the man page is raid10. The historic
understanding is that it's a stripe of mirrors, and this suggests you
can lose a mirror of each stripe i.e. multiple disks and not lose
data, which is not true for Btrfs raid10. But the man page makes that
clear, you have 2 copies for redundancy, that's it.





>
>
>>
>> The reason I say "naively" is that there is little to stop you from
>> creating a 2-device "raid1" using two partitions on the same
>> physical
>> device. This is especially difficult to detect if you add
>> abstraction
>> layers (lvm, dm-crypt, etc). This same problem does apply to mdadm
>> however.
> Sure... I think software should try to prevent people from doing stupid
> things, but not by all means ;-)
> If one makes n partitions on the same device an puts a RAID on that,
> one probably doesn't deserve it any better ;-)
>
> I'd guess it's probably doable to detect such stupidness for e.g.
> partitions and dm-crypt (because these are linearly on one device)...
> but for lvm/MD it really depends on the actual block allocation/layout,
> whether it's safe or not.
> Maybe the tools could detect *if* lvm/MD is in between and just give a
> general warning what that could mean.

On the CLI? Not worth it. If the user is that ignorant, too bad, use a
GUI program to help build the storage stack from scratch. I'm really
not sympathetic if a user creates a raid1 from two partitions of the
same block device anymore than if it's ultimately the same physical
device managed by a device mapper variant.

Anyway, I think there's a whole separate github discussion on Btrfs
UI/Ux that presumably also includes terminology concerns like this.


-- 
Chris Murphy
