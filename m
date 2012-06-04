Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57035 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab2FDSh5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jun 2012 14:37:57 -0400
Received: by lahd3 with SMTP id d3so3203743lah.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 11:37:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FCCF882.5080500@gmail.com>
References: <4FCC9C63.7000605@gmail.com>
	<4FCC9CD5.2050309@gmx.net>
	<4FCC9F6C.5090305@gmail.com>
	<20120604114901.GA15986@carfax.org.uk>
	<4FCCA39C.8060409@gmail.com>
	<20120604121134.GB15986@carfax.org.uk>
	<4FCCA9E6.3030209@gmail.com>
	<20120604123431.GC15986@carfax.org.uk>
	<4FCCE125.7000004@gmail.com>
	<20120604170422.GD15986@carfax.org.uk>
	<20120604170936.GE15986@carfax.org.uk>
	<CAGJTRcg7bwR0ASCLshQYj42erPa5cLV5R3NvWe335m05_R7rJA@mail.gmail.com>
	<4FCCF882.5080500@gmail.com>
Date: Mon, 4 Jun 2012 13:37:55 -0500
Message-ID: <CAGJTRciBERUNgRvgx4f4Ns+F2QBwPKUTZ25QCj9LW_=W-4ZoRg@mail.gmail.com>
Subject: Re: Help with data recovering
From: Michael <mike@draftx.net>
To: Maxim Mikheev <mikhmv@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Below is what you used? So you have RAID 0 for data, RAID 1 for
metadata. This doesn't help any, but a point of info.
# Create a filesystem across four drives (metadata mirrored, data striped)
mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde


Just to make sure I understand correctly: This FS with critical info
used a non-production filesystem, in RAID 0(no redundancy), with no
backups.

Another option I found(and I am no authority on the subject) is to use
btrfs.restore with -i
-i: Ignore errors. Normally the restore tool exits immediately for any
error. This option forces it to keep going if it can, usually this
results in some missing data.
Again, this can be destructive, and it would be very smart to make
block level copies of everything.

On Mon, Jun 4, 2012 at 1:03 PM, Maxim Mikheev <mikhmv@gmail.com> wrote:
> It was a RAID0 unfortunately.
>
>
> On 06/04/2012 02:02 PM, Michael wrote:
>>
>> If he has it in a RAID 1, could he manually fail the bad disk and try
>> it from there? Obviously this could be harmful, so a dd copy would be
>> a VERY good idea(truthfully, that should have been the first thing
>> that was done).
>> Michael
>>
>> On Mon, Jun 4, 2012 at 12:09 PM, Hugo Mills<hugo@carfax.org.uk>  wrote:
>>>
>>> On Mon, Jun 04, 2012 at 06:04:22PM +0100, Hugo Mills wrote:
>>>>
>>>>    I'm out of ideas.
>>>
>>>   ... but that's not to say that someone else may have some ideas. I
>>> wouldn't get your hopes up too much, though.
>>>
>>>>    At this point, though, you're probably looking at somebody writing
>>>> custom code to scan the FS and attempt to find and retrieve anything
>>>> that's recoverable.
>>>>
>>>>    You might try writing a tool to scan all the disks for useful
>>>> fragments of old trees, and see if you can find some of the tree roots
>>>> independently of the tree of tree roots (which clearly isn't
>>>> particularly functional right now). You might try simply scanning the
>>>> disks looking for your lost data, and try to reconstruct as much of it
>>>> as you can from that. You could try to find a company specialising in
>>>> data recovery and pay them to try to get your data back. Or you might
>>>> just have to accept that the data's gone and work on reconstructing
>>>> it.
>>>
>>>   Hugo.
>>>
>>> --
>>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>>  --- A linked list is still a binary tree.  Just a very unbalanced ---
>>>                             one.  -- dragon
