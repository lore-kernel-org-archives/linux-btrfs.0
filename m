Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:53855 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbcHCV4g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Aug 2016 17:56:36 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id E26AA9BA08
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 22:55:51 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id C98225FBA1
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 22:55:51 +0100 (BST)
Subject: Re: Extents for a particular subvolume
To: linux-btrfs@vger.kernel.org
References: <57A24C51.2050302@cobb.uk.net> <20160803203708.GA26505@angband.pl>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <57A26867.5020403@cobb.uk.net>
Date: Wed, 3 Aug 2016 22:55:51 +0100
MIME-Version: 1.0
In-Reply-To: <20160803203708.GA26505@angband.pl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/08/16 21:37, Adam Borowski wrote:
> On Wed, Aug 03, 2016 at 08:56:01PM +0100, Graham Cobb wrote:
>> Are there any btrfs commands (or APIs) to allow a script to create a
>> list of all the extents referred to within a particular (mounted)
>> subvolume?  And is it a reasonably efficient process (i.e. doesn't
>> involve backrefs and, preferably, doesn't involve following directory
>> trees)?
> 
> Since the size of your output is linear to the number of extents which is
> between the number of files and sum of their sizes, I see no gain in
> trying to avoid following the directory tree.

Thanks for the help, Adam.  There are a lot of files and a lot of
directories - find, "ls -R" and similar operations take a very long
time. I was hoping that I could query some sort of extent tree for the
subvolume and get the answer back in seconds instead of multiple minutes.

But I can follow the directory tree if I need to.

>> I am not looking to relate the extents to files/inodes/paths.  My
>> particular need, at the moment, is to work out how much of two snapshots
>> is shared data, but I can think of other uses for the information.
> 
> Thus, unlike the question you asked above, you're not interested in _all_
> extents, merely those which changed.
> 
> You may want to look at "btrfs subv find-new" and "btrfs send --no-data".

Unfortunately, the subvolumes do not have an ancestor-descendent
relationship (although they do have some common ancestors), so I don't
think find-new is much help (as far as I can see).

But just looking at the size of the output  from "send -c" would work
well enough for the particular problem I am trying to solve tonight!
Although I will need to take read-only snapshots of the subvolumes to
allow send to work. Thanks for the suggestion.

I would still be interested in the extent list, though.  The main
problem with find-new and send is that they don't tell me how much has
been deleted, only added.  I am thinking about using the extents to get
a much better handle on what is using up space and what I could recover
if I removed (or moved to another volume) various groups of related
subvolumes.

Thanks again for the help.
