Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:46505 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2GaNid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 09:38:33 -0400
Received: from a.earth.lavabit.com (a.earth.lavabit.com [192.168.111.10])
	by karen.lavabit.com (Postfix) with ESMTP id AC3DC11B98B
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 08:38:32 -0500 (CDT)
Received: from lavabit.com (70-88-36-65-miami-fl.hfc.comcastbusiness.net [70.88.36.65])
	by lavabit.com with ESMTP id CL13DND81MPP
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 08:38:32 -0500
Message-ID: <62481.70.88.36.65.1343741912.squirrel@lavabit.com>
In-Reply-To: <1343731366.6064.28.camel@ayu>
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com>
    <1343731366.6064.28.camel@ayu>
Date: Tue, 31 Jul 2012 09:38:32 -0400 (EDT)
Subject: Re: filesystem finder / fixer
From: serialhex@lavabit.com
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, 2012-07-30 at 23:26 -0400, serialhex@lavabit.com wrote:
>> Hi all, so I've filled out an awesome ID10T form this weekend (all
>> starting with a forded update) and completely annialated my
>> partitions...
>> I was running btrfs and was wondering 2 things:
>>
>> 1) is there a tool to help me recover data from my fs? I don't have a
>> backup of my partition table and so I have about 500GB of space where a
>> few partitionns might reside... GPT partitions mind you
>
> One of the nice things about GPT is that it stores a backup partition
> table in a second spot near the end of the disk. It may be possible to
> recover it.
>
> Try running 'gdisk' on your drive, then hit 'r' to switch to recovery
> mode. Try the 'c' recovery command to load the backup partition table
> from disk.
> More details and some other things you might want to try are at
> http://www.rodsbooks.com/gdisk/repairing.html
>

i've already tried some of the recovery options... i'm going to try the
MBR recovery later on, but i doubt that will work.  i typically do a lot
of the data recovery at the place where i work, but it's all windows-based
stuff and thus very easy (i use a bunch of linuxy tools... because they
rock!)  unfortunately, i havn't found anything that will work with btrfs,
which is why i was asking for direction for a fs-finder (scan the drive,
look for data structures, pull out data) or what i need to learn to build
one.  i've never worked on something like that, but i wouldnt mind doing
it (i'd need help of course, but that's what the community is for).  :)

> This wouldn't have been a major problem if you had backups in the first
> place :)
> --
> Calvin Walton <calvin.walton@kepstin.ca>

you know, i scold people for not having backups, and my latest backup is
3+months old... :'(  being a hypocrite sucks!!  :P

thanks!
Justin



