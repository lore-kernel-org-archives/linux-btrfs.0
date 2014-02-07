Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38335 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704AbaBGB2m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 20:28:42 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Are nocow files snapshot-aware
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com>
Date: Thu, 6 Feb 2014 18:28:40 -0700
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <6C86A9EB-75D7-4783-B055-8D509F695412@colorremedies.com>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net> <r5mdsa-hng.ln1@hurikhan77.spdns.de> <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com>
To: cwillu <cwillu@cwillu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 6, 2014, at 6:01 PM, cwillu <cwillu@cwillu.com> wrote:

> On Thu, Feb 6, 2014 at 6:32 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
>> Duncan <1i5t5.duncan@cox.net> schrieb:
>> 
>>>> Ah okay, that makes it clear. So, actually, in the snapshot the file is
>>>> still nocow - just for the exception that blocks being written to become
>>>> unshared and relocated. This may introduce a lot of fragmentation but it
>>>> won't become worse when rewriting the same blocks over and over again.
>>> 
>>> That also explains the report of a NOCOW VM-image still triggering the
>>> snapshot-aware-defrag-related pathology.  It was a _heavily_ auto-
>>> snapshotted btrfs (thousands of snapshots, something like every 30
>>> seconds or more frequent, without thinning them down right away), and the
>>> continuing VM writes would nearly guarantee that many of those snapshots
>>> had unique blocks, so the effect was nearly as bad as if it wasn't NOCOW
>>> at all!
>> 
>> The question here is: Does it really make sense to create such snapshots of
>> disk images currently online and running a system. They will probably be
>> broken anyway after rollback - or at least I'd not fully trust the contents.
>> 
>> VM images should not be part of a subvolume of which snapshots are taken at
>> a regular and short interval. The problem will go away if you follow this
>> rule.
>> 
>> The same applies to probably any kind of file which you make nocow - e.g.
>> database files. Most of those file implement their own way of transaction
>> protection or COW system, e.g. look at InnoDB files. Neither they gain
>> anything from using IO schedulers (because InnoDB internally does block
>> sorting and prioritizing and knows better, doing otherwise even hurts
>> performance), nor they gain from file system semantics like COW (because it
>> does its own transactions and atomic updates and probably can do better for
>> its use case). Similar applies to disk images (imagine ZFS, NTFS, ReFS, or
>> btrfs images on btrfs). Snapshots can only do harm here (the only
>> "protection" use case would be to have a backup, but snapshots are no
>> backups), and COW will probably hurt performance a lot. The only use case is
>> taking _controlled_ snapshots - and doing it all 30 seconds is by all means
>> NOT controlled, it's completely undeterministic.
> 
> If the database/virtual machine/whatever is crash safe, then the
> atomic state that a snapshot grabs will be useful.

How fast is this state fixed on disk from the time of the snapshot command? Loosely speaking. I'm curious if this is < 1 second; a few seconds; or possibly up to the 30 second default commit interval? And also if it's even related to the commit interval time at all?

I'm also curious what happens to files that are presently writing. e.g. I'm writing a 1GB file to subvol A and before it completes I snapshot subvol A into A.1. If I go find the file I was writing to, in A.1, what's its state? Truncated? Or or are in-progress writes permitted to complete if it's a rw snapshot? Any difference in behavior if it's an ro snapshot?


Chris Murphy

