Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob06.myregisteredsite.com ([209.17.115.102]:47101 "EHLO
	atl4mhob06.myregisteredsite.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752382Ab3FGOAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Jun 2013 10:00:39 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.114])
	by atl4mhob06.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r57E0bmm017334
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Jun 2013 10:00:37 -0400
Message-ID: <51B1E78B.4050808@chinilu.com>
Date: Fri, 07 Jun 2013 07:00:43 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: How do I safely terminate COW on pre-existing files?
References: <51B14AB0.4040906@chinilu.com> <20130607115254.GH18160@twin.jikos.cz>
In-Reply-To: <20130607115254.GH18160@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, I would never have understood the phrase "it is undefined when 
the blocks assigned to the file will be fully stable" without your 
further explanation.  The man page could be far clearer in its choice of 
wording.  At this point I have also discovered that setting the "nocow" 
flag also disables checksums, which should also be noted on the same man 
page, and I am not sure I want to do that anyway, especially in a raid1 
configuration.

I currently have two major problems.  The first is the open_ctree boot 
issue which NEVER occurs when I do a FULL (every directory and file) 
offline defragmentation immediately before boot.  That process ALWAYS 
guarantees I will see a clean boot.  So the problem may not be 
fragmentation, but certainly the defrag process is doing something that 
prevents the open_ctree issue from manifesting.  So that is the approach 
I will use until this thing is solved.  The second issue is the systemd 
journal corruption issue.  I don't have that problem on a parallel 
non-btrfs system on the same hardware.  BUT ... I just this morning 
moved the journal logging to an ext4 partition and the same journal 
corruption is occurring which tells me that this problem is most likely 
not related to btrfs at all and has something to do with the unique 
configuration of the system instead.  So that leave only the boot 
problem and I will just continue to use the very effective band-aid on 
that one until it is finally fixed upstream.

Thanks so much for taking the time to respond to my question.  It is 
MUCH appreciated.  - George

On 06/07/2013 04:52 AM, David Sterba wrote:
> On Thu, Jun 06, 2013 at 07:51:28PM -0700, George Mitchell wrote:
>> I want to eliminate the COW feature on all of my OS files.  It is a nice
>> feature for user files, but I don't see a clear benefit for the actual OS
>> files.  And I suspect that COW induced fragmentation is causing or
>> aggravating problems with my system including the boot open_ctree problem.
> Fragmentation does not cause open_ctree boot problems, it could affect
> boot speed.
>
>> I had planned to recursively chattr these files to "nodatacow" status but
>> then I ran into this cryptic warning on the chattr man page:
>>
>> (Note: For btrfs, the 'C' flag should be set on new or empty files. If it is
>> set on a file which already has data blocks, it is undefined when the blocks
>> assigned to the file will be fully stable.  If the  'C'  flag  is set on a
>> directory, it will have no effect on the directory, but new files created in
>> that directory will the No_COW attribute.)
>>
>> So what exactly does that mean?  Does it mean that it is unsafe?  Or does it
>> mean that it is simply unreliable?  If I run a btrfs balance first will that
>> clear out the COW snapshots and enable me to perform the recursive chattrs?
>> What is the best way to approach this?
> The COW status cannot be changed once a file has data, implementation
> reasons. The cryptic message should tell you that doing chattr on a
> non-empty file has undefined result, which in practice means that it
> does nothing. The file's cow-status is kept intact.
>
> Setting nocow on a directory has clear semantics, it sets nocow on any
> new (empty) file just fine.
>
> If you want to switch files between cow<->nocow, set the cow-status in
> advance and then do cp.
>
>
> david
>
>

