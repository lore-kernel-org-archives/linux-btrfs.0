From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: Copy/move btrfs volume
Date: Thu, 1 Jul 2010 11:33:59 +0000 (UTC)
Message-ID: <i0huf7$98a$1@dough.gmane.org>
References: <i0hqkk$r4h$1@dough.gmane.org>
	<AANLkTin1O6Oa7oq4nFMfNhv4N5FWCko7bcuTMoR5Xkob@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Daniel J Blueman, Thu, 01 Jul 2010 12:26:10 +0100:
>> What is the correct way to do this?
> 
> The only way to do this preserving duplication is to use hardlinks
> between duplicated files (which reference counts the inode), and use
> 'rsync -H'.
> 
> Dan

But when the files are on different snaphots, does rsync see them as 
hardlinked?

A scenario - I have raid5 of say, 1TB HDDs. It contains many snapshots.
Then, few years later, new machine is bought and there are, say, 5TB 
discs.

So I need to transfer the btrfs volume to the new machine. 

But how to do it so that it looks the *same*, ie. the same snapshots?
I could of course write a custom script to create the subvolume, rsync 
the files, create snapshot, rsync files, etc,

but it would be nice if the btrfs toolset supports this by default...

Lubos

