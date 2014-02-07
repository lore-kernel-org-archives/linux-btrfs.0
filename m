Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52435 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaBGBB0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 20:01:26 -0500
Received: by mail-vc0-f176.google.com with SMTP id la4so2075752vcb.21
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 17:01:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <r5mdsa-hng.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de>
	<52F1923D.8090306@fb.com>
	<20140205020239.GP1364@twin.jikos.cz>
	<6qbasa-fq1.ln1@hurikhan77.spdns.de>
	<pan$9252f$8363907a$3eaa17a6$f558018@cox.net>
	<r5mdsa-hng.ln1@hurikhan77.spdns.de>
Date: Thu, 6 Feb 2014 19:01:25 -0600
Message-ID: <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com>
Subject: Re: Are nocow files snapshot-aware
From: cwillu <cwillu@cwillu.com>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 6, 2014 at 6:32 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> Duncan <1i5t5.duncan@cox.net> schrieb:
>
>>> Ah okay, that makes it clear. So, actually, in the snapshot the file is
>>> still nocow - just for the exception that blocks being written to become
>>> unshared and relocated. This may introduce a lot of fragmentation but it
>>> won't become worse when rewriting the same blocks over and over again.
>>
>> That also explains the report of a NOCOW VM-image still triggering the
>> snapshot-aware-defrag-related pathology.  It was a _heavily_ auto-
>> snapshotted btrfs (thousands of snapshots, something like every 30
>> seconds or more frequent, without thinning them down right away), and the
>> continuing VM writes would nearly guarantee that many of those snapshots
>> had unique blocks, so the effect was nearly as bad as if it wasn't NOCOW
>> at all!
>
> The question here is: Does it really make sense to create such snapshots of
> disk images currently online and running a system. They will probably be
> broken anyway after rollback - or at least I'd not fully trust the contents.
>
> VM images should not be part of a subvolume of which snapshots are taken at
> a regular and short interval. The problem will go away if you follow this
> rule.
>
> The same applies to probably any kind of file which you make nocow - e.g.
> database files. Most of those file implement their own way of transaction
> protection or COW system, e.g. look at InnoDB files. Neither they gain
> anything from using IO schedulers (because InnoDB internally does block
> sorting and prioritizing and knows better, doing otherwise even hurts
> performance), nor they gain from file system semantics like COW (because it
> does its own transactions and atomic updates and probably can do better for
> its use case). Similar applies to disk images (imagine ZFS, NTFS, ReFS, or
> btrfs images on btrfs). Snapshots can only do harm here (the only
> "protection" use case would be to have a backup, but snapshots are no
> backups), and COW will probably hurt performance a lot. The only use case is
> taking _controlled_ snapshots - and doing it all 30 seconds is by all means
> NOT controlled, it's completely undeterministic.

If the database/virtual machine/whatever is crash safe, then the
atomic state that a snapshot grabs will be useful.
