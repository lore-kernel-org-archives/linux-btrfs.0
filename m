Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3HCVhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Aug 2013 17:37:00 -0400
Message-ID: <51FD77F6.2070800@redhat.com>
Date: Sat, 03 Aug 2013 16:36:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: remove duplicated code in cmds-restore.c
References: <1373395794-29140-1-git-send-email-fdmanana@gmail.com> <1373395794-29140-2-git-send-email-fdmanana@gmail.com> <20130710161255.GD25386@twin.jikos.cz> <51FC5005.20101@redhat.com>
In-Reply-To: <51FC5005.20101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/2/13 7:34 PM, Eric Sandeen wrote:
> On 7/10/13 11:12 AM, David Sterba wrote:
>> On Tue, Jul 09, 2013 at 07:49:53PM +0100, Filipe David Borba Manana wrote:
>>> The module cmds-restore.c was defining its own next_leaf()
>>> function, which did exactly the same as btrfs_next_leaf()
>>> from ctree.c.
>>
>> This has been removed by Eric's patch present in the integration
>> branches:
>>  Btrfs-progs: remove cut & paste btrfs_next_leaf from restore
>> http://www.spinics.net/lists/linux-btrfs/msg24477.html
>>
>> but now Chris has a fix in the master branch,
>>  btrfs-restore: deal with NULL returns from read_node_slot
>> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=194aa4a1bd6447bb545286d0bcb0b0be8204d79f
> 
> Just noticed this.  :(
> 
> Is there some reason that kernelspace should not also get Chris' fix, though?

Or for that matter the other copy in ctree.c...

Ok, my email didn't make a ton of sense.  :/  But there are basically 3 copies
of this function now, diverging further - in btrfs-progs' ctree.c and cmds-restore.c,
as well as kernelspace ctree.c  Should they differ?

Now that I have some time I guess I'll get back to trying to bring userspace
in line w/ kernelspace again...

-Eric


>> the code of updated next_leaf is not identical to btrfs_next_leaf and I
>> think 'restore' could be more tolerant to partially corrupted
>> structures, so both functions could make sense in the end.
> 
> Surely kernelspace should be at least as tolerant as userspace; it
> it seems like Chris's BUG_ON removal patch could benefit kernelspace too, no?
> 
> And then we could take one more baby step towards a cleaner, non-
> cut-and-pasted codebase.
> 
> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

