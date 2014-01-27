Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54833 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753781AbaA0Tta convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 14:49:30 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: =?windows-1252?Q?Re=3A_Snapshots_=96_noob_questions?=
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140127185008.GN3314@carfax.org.uk>
Date: Mon, 27 Jan 2014 12:49:27 -0700
Cc: KC <impactoria@googlemail.com>, linux-btrfs@vger.kernel.org
Message-Id: <E6CD1D22-3297-42C2-A951-D296E4156132@colorremedies.com>
References: <52E664E0.5070909@gmail.com> <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com> <20140127185008.GN3314@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 27, 2014, at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Mon, Jan 27, 2014 at 11:44:24AM -0700, Chris Murphy wrote:
>> 
>> On Jan 27, 2014, at 6:53 AM, KC <impactoria@googlemail.com> wrote:
>>> 4. If I have a snapshot of  /, can I completely erase this partition and later restore it in full form that snapshot, or do snapshots work only if a limited number of files has been changed?
>>> If the former, then does it mean that snapshot size will be comparable to the original data size?
>> 
>> I'm confused by what you mean by completely erase this partitions and later restore it. What do you mean by partition? Taken literally I'd say no because a snapshot is a subvolume, it's a function of a Btrfs file system, and if you erase the partition you've erased the file system and everything on it.
>> 
>> Otherwise, either the snapshot or its parent subvolume can be deleted at any time. At the moment the snapshot is taken, they are clones, but they behave as completely separate file systems. Any changes to one do not affect the other.
> 
>   Probably slightly more accurate to say "completely different file
> trees", as they're part of the same filesystem (the single btrfs FS
> that contains all of the subvolumes in this example).

Yes good point. File system = volume; file tree = subvolume.

> 
>>> 5. Can a snapshot be stored on a different partition?
>> 
>> Yes Btrfs send/receive.
> 
>   Mmmm... debatable semantics again. You can transfer the data with
> btrfs send/receive, but after that it's not really a snapshot in the
> sense of being a CoW copy on the same filesystem…

Ahh yes I was being very literal rather than thinking of a magical hard link that can work across file system boundaries.

Maybe the question needs to be phrased in terms of a use case question, and possibly a seed-device would fit?

https://btrfs.wiki.kernel.org/index.php/Seed-device


Chris Murphy

