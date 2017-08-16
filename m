Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751287AbdHPNMy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 09:12:54 -0400
Date: Wed, 16 Aug 2017 09:12:31 -0400
From: Chris Mason <clm@fb.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Message-ID: <20170816131230.GA28619@clm-mbp.thefacebook.com>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net>
 <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
In-Reply-To: <1502740488.5384.5.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 09:54:48PM +0200, Christoph Anton Mitterer wrote:
>On Mon, 2017-08-14 at 11:53 -0400, Austin S. Hemmelgarn wrote:
>> Quite a few applications actually _do_ have some degree of secondary 
>> verification or protection from a crash.  Go look at almost any
>> database 
>> software.
>Then please give proper references for this!
>
>This is from 2015, where you claimed this already and I looked up all
>the bigger DBs and they either couldn't do it at all, didn't to it per
>default, or it required application support (i.e. from the programs
>using the DB)
>https://www.spinics.net/lists/linux-btrfs/msg50258.html
>
>
>> It usually will not have checksumming, but it will almost 
>> always have support for a journal, which is enough to cover the 
>> particular data loss scenario we're talking about (unexpected
>> unclean 
>> shutdown).
>
>I don't think we talk about this:
>We talk about people wanting checksuming to notice e.g. silent data
>corruption.
>
>The crash case is only the corner case about what happens then if data
>is written correctly but csums not.

We use the crcs to catch storage gone wrong, both in terms of simple 
things like cabling, bus errors, drives gone crazy or exotic problems 
like every time I reboot the box a handful of sectors return EFI 
partition table headers instead of the data I wrote.  You don't need 
data center scale for this to happen, but it does help...

So, we do catch crc errors in prod and they do keep us from replicating 
bad data over good data.  Some databases also crc, and all drives have 
correction bits of of some kind.  There's nothing wrong with crcs 
happening at lots of layers.

Btrfs couples the crcs with COW because it's the least complicated way 
to protect against:

* bits flipping
* IO getting lost on the way to the drive, leaving stale but valid data 
in place
* IO from sector A going to sector B instead, overwriting valid data 
with other valid data.

It's possible to protect against all three without COW, but all 
solutions have their own tradeoffs and this is the setup we chose.  It's 
easy to trust and easy to debug and at scale that really helps.

In general, production storage environments prefer clearly defined 
errors when the storage has the wrong data.  EIOs happen often, and you 
want to be able to quickly pitch the bad data and replicate in good 
data.

My real goal is to make COW fast enough that we can leave it on for the 
database applications too.  Obviously I haven't quite finished that one 
yet ;) But I'd rather keep the building block of all the other btrfs 
features in place than try to do crcs differently.

-chris
