Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:38877 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdHPNyC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 09:54:02 -0400
Received: by mail-io0-f182.google.com with SMTP id g71so13171829ioe.5
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 06:54:01 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Anton Mitterer <calestyo@scientia.net>, Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <1502890308.5446.5.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <152c3e70-72e2-0d26-e145-979f602257b7@gmail.com>
Date: Wed, 16 Aug 2017 09:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <1502890308.5446.5.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-16 09:31, Christoph Anton Mitterer wrote:
> Just out of curiosity:
> 
> 
> On Wed, 2017-08-16 at 09:12 -0400, Chris Mason wrote:
>> Btrfs couples the crcs with COW because
> 
> this (which sounds like you want it to stay coupled that way)...
> 
> plus
> 
> 
>> It's possible to protect against all three without COW, but all
>> solutions have their own tradeoffs and this is the setup we
>> chose.  It's
>> easy to trust and easy to debug and at scale that really helps.
> 
> ... this (which sounds more you think the checksumming is so helpful,
> that it would be nice in the nodatacow as well).
> 
> What does that mean now? Things will stay as they are... or it may
> become a goal to get checksumming for nodatacow (while of course still
> retaining the possibility to disable both, datacow AND checksumming)?
It means that you have other options if you want this so badly that you 
need to keep pestering the developers about it but can't be arsed to try 
to code it yourself.  Go try BTRFS on top of dm-integrity, or on a 
system with T10-DIF or T13-EPP support (which you should have access to 
given the amount of funding CERN gets), or even on a ZFS zvol if you're 
crazy enough.  It works wonderfully in the first two cases, and reliably 
(but not efficiently) in the third, and all of them provide exactly what 
you want, plus the bonus that they do a slightly better job of 
differentiating between media and memory errors.
> 
> 
>> In general, production storage environments prefer clearly defined
>> errors when the storage has the wrong data.  EIOs happen often, and
>> you
>> want to be able to quickly pitch the bad data and replicate in good
>> data.
> 
> Which would also rather point towards getting clear EIOs (and thus
> checksumming) in the nodatacow case.
Except it isn't clear with nodatacow, because it might be a false positive.
> 
> 
> 
>> My real goal is to make COW fast enough that we can leave it on for
>> the
>> database applications too.  Obviously I haven't quite finished that
>> one
>> yet ;)
> 
> Well the question is, even if you manage that sooner or later, will
> everyone be fully satisfied by this?!
> I've mentioned earlier on the list that I manage one of the many big
> data/computing centres for LHC.
> Our use case is typically big plain storage servers connected via some
> higher level storage management system (http://dcache.org/)... with
> mostly write once/read many.
> 
> So apart from some central DBs for the storage management system
> itself, CoW is mostly no issue for us.
> But I've talked to some friend at the local super computing centre and
> they have rather general issues with CoW at their virtualisation
> cluster.
> Like SUSE's snapper making many snapshots leading the storage images of
> VMs apparently to explode (in terms of space usage).
SUSE is pathological case of brain-dead defaults.  Snapper needs to 
either die or have some serious sense beat into it.  When you turn off 
the automatic snapshot generation for everything but updates and set the 
retention policy to not keep almost everything, it's actually not bad at 
all.
> For some of their storage backends there simply seem to be no de-
> duplication available (or other reasons that prevent it's usage).
If the snapshots are being CoW'ed, then dedupe won't save them any 
space.  Also, nodatacow is inherently at odds with reflinks used for dedupe.
> 
>  From that I'd guess there would be still people who want the nice
> features of btrfs (snapshots, checksumming, etc.), while still being
> able to nodatacow in specific cases.
Snapshots work fine with nodatacow, each block gets CoW'ed once when 
it's first written to, and then goes back to being NOCOW.  The only 
caveat is that you probably want to defrag either once everything has 
been rewritten, or right after the snapshot.
