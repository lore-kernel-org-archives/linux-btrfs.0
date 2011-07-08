From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH v1 0/2] Btrfs-progs: commands "resolve inode" and "resolve
 logical"
Date: Fri, 08 Jul 2011 18:42:01 +0200
Message-ID: <4E173359.1020407@libero.it>
References: <cover.1310053983.git.list.btrfs@jan-o-sch.net> <4E163EF5.4070405@libero.it> <4E16BED8.50106@jan-o-sch.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E16BED8.50106@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/08/2011 10:24 AM, Jan Schmidt wrote:
> On 08.07.2011 01:19, Goffredo Baroncelli wrote:
>> On 07/07/2011 06:01 PM, Jan Schmidt wrote:
>>> The kernel patch series just sent (Subject: "Btrfs: scrub: print path to
>>> corrupted files and trigger nodatasum fixup") introduces two new ioctls to
>>> do in-kernel filesystem path construction. This series provides the
>>> corresponding userspace changes, adding two new commands to the btrfs utility:
>>
>> Which is the aim of these commands ? It seems more a "debug" utilities
>> than a standard command. If so, these commands may be put under a new
>> group called "debug" or "test" or whichever we decided to use. But,
>> please, highlight the fact that these commands aren't for a general use.
> 
> Well, in my opinion, they are. Finding files for an inode is not that
> exotic, is it?

In my opinion it is a bit exotic. But there would be some interesting
case, like: find all the link which point to an inode.

> 
> The command to find files for logical addresses is useful until each and
> every error message in the kernel log does that resolving itself.
> Currently, we log logical addresses everywhere. Once that's changed,
> this one becomes more like a debug command, I agree.

I am not fully aligned to you, but the difference is so small that
doesn't matter anyway.

> 
>> I suggest to use
>>
>> 	btrfs debug resolve ...
>>
>> Or better
>>
>> 	btrfs inspect resolve ...
> 
> I don't give much in command names (I admit they should make sense), I'm
> happy to insert an "inspect" there. Although "btrfs inspect resolve
> inode" sounds strange to me. Any other opinions? I suggest we'd better
> do the naming process in #btrfs.

For the name my I can suggest:

	btrfs inspect-internal inode-resolve

	btrfs inspect-internal logical-resolve

which may be abbreviate to

	btrfs inspect inode

	btrfs inspect logical

which are (IMHO) a good balancing between shortness and clarity

The command group "inspect-internal" (IMHO) is quite generic and in the
future other commands may be inserted here. And the name is sufficent
"strange" to highlight that these command are not for "faint of heart"'
admins.



> 
>>>
>>> --
>>> btrfs resolve inode [-v] <inode> <path>
>>> 	resolves an <inode> to all filesystem paths local to the fs mounted
>>> 	at <path>.
>>> 		-v  print count of returned and missed paths
>>>
>>> btrfs resolve logical [-v] [-P] <logical> <path>
>>> 	resolves a <logical> address to all filesystem paths in the file
>>> 	system mounted at <path> and all its subvolumes.
>>> 		-v  print count of returned and missed inode/offset/root
>>> 		    triples
>>> 		-P  do not resolve the path but stop after finding all
>>> 		    inodes at this logical address and print them instead
>>> --
>>>
>>> These patches are based on Hugo's current integration branch.
>>>
>>> Please try them out and report bugs here. I'll send an update to the manpages
>>> later.
>>
>> Please update the man pages at the same time of the code. Develop the
>> man page coupled with the code may help to design a "good interface"
>> (from an user point of view) and to explain better the aim of the new
>> command.
> 
> Agreed. Next version will come with man pages.
> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

