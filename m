Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:59030 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaEGSam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 14:30:42 -0400
Message-ID: <536A7C6D.2030300@libero.it>
Date: Wed, 07 May 2014 20:33:17 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: How does Suse do live filesystem revert with btrfs?
References: <20140504005257.GF9061@merlins.org> <20140504232645.GQ9061@merlins.org> <20140505003639.GO24298@carfax.org.uk> <20140505050459.GF10159@merlins.org> <pan$4eac3$a2d76a4$a81e0fed$b4b18c9e@cox.net> <20140507085612.GB19238@merlins.org> <pan$2da2e$d0644856$de7d595b$8d7f256e@cox.net> <20140507113942.GY10159@merlins.org>
In-Reply-To: <20140507113942.GY10159@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2014 01:39 PM, Marc MERLIN wrote:
> On Wed, May 07, 2014 at 11:35:52AM +0000, Duncan wrote:
>> Marc MERLIN posted on Wed, 07 May 2014 01:56:12 -0700 as excerpted:
>>
>>> On Tue, May 06, 2014 at 04:26:48PM +0000, Duncan wrote:
>>>> Marc MERLIN posted on Sun, 04 May 2014 22:04:59 -0700 as excerpted:
>>>>
>>>>>
>>>>> Aaah, right, you can use a script to see the file differences between
>>>>> two snapshots, and then restore that with reflink if you can truly
>>>>> get a list of all changed files.
>>>>> However, that is indeed not atomic at all, even if faster than rsync.
>>>>
>>>> Would send/receive help in such a script?
>>>
>>> Not really, you still end up with a new snapshot that you can't live
>>> switch to.
>>>
>>> It's really either 1) reboot 2) use cp --reflink to copy a list of
>>> changed files (as well as rm to delete the ones that were removed).
>>
>> What I meant was... use send/receive locally, in place of the
>> cp --reflink.
> 
> This won't work since it can only work on another read-only subvolume.
> 
> But you could use btrfs send -p to get a list of changes between 2
> snapshots, decode that (without btrfs receive) just to spit out the
> names of the files that changed or got deleted.
> It would be wasteful since it would cause all the changed blocks to be
> read on the source, but still better than nothing.
> 
> Really, we'd just need a btrfs --send --dry-run -v -p vol1 vol2 
> which would spit out a list of the file ops it would do.
> 
> That'd be enough to simply grep out the deletes, do them locally and
> then use cp --reflink on everything else.

What happens to the already opened files ? I suppose that a process which has already opened a file, see the old one; instead a new open could see the new one.
If this is acceptable, why not doing "mount --bind /snapshot /", or use pivot_root(2), or a overlay filesystem ?
May be that we need to move also the other already mounted_filesystem (like /proc, /sys)...



> 
> Marc
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
