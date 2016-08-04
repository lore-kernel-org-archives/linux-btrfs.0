Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:37127 "EHLO
	mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbcHDLf4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 07:35:56 -0400
Received: by mail-it0-f44.google.com with SMTP id f6so257218034ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 04:34:21 -0700 (PDT)
Subject: Re: Extents for a particular subvolume
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <57A24C51.2050302@cobb.uk.net> <20160803203708.GA26505@angband.pl>
 <57A26867.5020403@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <24f6c93c-fc88-1a4e-4f6a-8e40655e829e@gmail.com>
Date: Thu, 4 Aug 2016 07:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <57A26867.5020403@cobb.uk.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-03 17:55, Graham Cobb wrote:
> On 03/08/16 21:37, Adam Borowski wrote:
>> On Wed, Aug 03, 2016 at 08:56:01PM +0100, Graham Cobb wrote:
>>> Are there any btrfs commands (or APIs) to allow a script to create a
>>> list of all the extents referred to within a particular (mounted)
>>> subvolume?  And is it a reasonably efficient process (i.e. doesn't
>>> involve backrefs and, preferably, doesn't involve following directory
>>> trees)?
>>
>> Since the size of your output is linear to the number of extents which is
>> between the number of files and sum of their sizes, I see no gain in
>> trying to avoid following the directory tree.
>
> Thanks for the help, Adam.  There are a lot of files and a lot of
> directories - find, "ls -R" and similar operations take a very long
> time. I was hoping that I could query some sort of extent tree for the
> subvolume and get the answer back in seconds instead of multiple minutes.
>
> But I can follow the directory tree if I need to.
>
>>> I am not looking to relate the extents to files/inodes/paths.  My
>>> particular need, at the moment, is to work out how much of two snapshots
>>> is shared data, but I can think of other uses for the information.
>>
>> Thus, unlike the question you asked above, you're not interested in _all_
>> extents, merely those which changed.
>>
>> You may want to look at "btrfs subv find-new" and "btrfs send --no-data".
>
> Unfortunately, the subvolumes do not have an ancestor-descendent
> relationship (although they do have some common ancestors), so I don't
> think find-new is much help (as far as I can see).
>
> But just looking at the size of the output  from "send -c" would work
> well enough for the particular problem I am trying to solve tonight!
> Although I will need to take read-only snapshots of the subvolumes to
> allow send to work. Thanks for the suggestion.
FWIW, if you're not using any files in the subvolumes, you can run:
btrfs property set <subvolume> ro true

to mark them read-only so you don't need the snapshots, and then run the 
same command with 'false' at the end instead of true to mark them 
writable again.
>
> I would still be interested in the extent list, though.  The main
> problem with find-new and send is that they don't tell me how much has
> been deleted, only added.  I am thinking about using the extents to get
> a much better handle on what is using up space and what I could recover
> if I removed (or moved to another volume) various groups of related
> subvolumes.
You may want to look into 'btrfs filesystem usage' and 'btrfs filesystem 
du' commands.  I'm not sure if they'll cover what you need, but they can 
show info about how much is shared.

