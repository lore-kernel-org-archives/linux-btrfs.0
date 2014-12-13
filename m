Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:53971 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966321AbaLMJjU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 04:39:20 -0500
Message-ID: <548C0942.6020304@pobox.com>
Date: Sat, 13 Dec 2014 01:39:14 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548B5FD6.5080306@pobox.com> <ce7dba343916e4262a92071af863d014@admin.virtall.com> <548B6D58.6080804@pobox.com> <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com> <548B7329.80208@pobox.com> <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com>
In-Reply-To: <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 12:16 AM, Tomasz Chmielewski wrote:
> On 2014-12-12 23:58, Robert White wrote:
>
>> I don't have the history to answer this definitively, but I don't
>> think you have a choice. Nothing else is going to touch that error.
>>
>> I have not seen any "oh my god, btrfsck just ate my filesystem errors"
>> since I joined the list -- but I am a relative newcomer.
>>
>> I know that you, of course, as a contentious and well-traveled system
>> administrator, already have a current backup since you are doing
>> storage maintenance... right? 8-)
>
> Who needs backups with btrfs, right? :)
>
> So apparently btrfsck --repair fixed some issues, the fs is still
> mountable and looks fine.
>
> Running balance again, but that will take many days there.

Might I ask why you are running balance? After a persistent error I'd 
understand going straight to scrub, but balance is usually for 
transformation or to redistribute things after atypical use.

An entire generation of folks have grown used to defraging windows boxes 
and all, but if you've already got an array that is going to take "many 
days" to balance what benefit do you actually expect to receive?


Defrag -- used for "I think I'm getting a lot of unnecessary head seek 
in this application, these files need to be brought into closer order".

Scrub -- used for defensive checking a-la checkdisk. "I suspect that 
after that unexpected power outage something may be a little off", or 
alternately "I think my disks are giving me bitrot, I better check".

Btrfsck -- used for "I suspect structural problems caused by real world 
events like power hits or that one time when the cat knocked over my 
tower case while I was vacuuming all my sql tables." (often reserved for 
"hey, I'm getting weird messages from the kernel about things in my 
filesystem".)

Balance -- primary -- used for "Well I used to use this filessytem for a 
small number of large files, but now I am processing a large number of 
small files and I'm running out of metadata even though I've got a lot 
of space." (or vice versa)

Balance -- other -- used for "I just changed the geometry of my 
filessytem by adding or removing a disk and I want to spread out.

Balance -- (conversion/restructuring) -- used for "single is okay, but 
I'd rather raid-0 to spread out my load across these many disks" or 
"gee, I'd like some redundancy now that I have the room.



Frequent balancing of a Copy On Write filesystem will tend to make 
things somewhat anti-optimal. You are burping the natural working space 
out of the natural layout.

Since COW implies mandatory movement of data, every time you burp out 
all the slack and pack all the data together you are taking your 
regularly modified files and moving them far, far away from the places 
where frequently modified files are most happy (e.g. the 
only-partly-full data region they were just living in).

Similarly two files that usually get modified at the same time (say a 
databse file and its rollback log) will tend to end up in the same 
active data extent as time goes on, and if balance decides it can "clean 
up" that extent it will likely give those two files a data-extent 
divorce and force them to the opposite ends of dataland.

COW systems are inherently somewhat chaotic. If you fight that too 
aggressively you will, at best, be wasting the maintenance time.

It may be a decrease in performance measured in very small quanta, but 
so is the expected benefit of most maintenance.


 From the wiki::

https://btrfs.wiki.kernel.org/index.php/FAQ#What_does_.22balance.22_do.3F

btrfs filesystem balance is an operation which simply takes all of the 
data and metadata on the filesystem, and re-writes it in a different 
place on the disks, passing it through the allocator algorithm on the 
way. It was originally designed for multi-device filesystems, to spread 
data more evenly across the devices (i.e. to "balance" their usage). 
This is particularly useful when adding new devices to a nearly-full 
filesystem.
Due to the way that balance works, it also has some useful side-effects:
If there is a lot of allocated but unused data or metadata chunks, a 
balance may reclaim some of that allocated space. This is the main 
reason for running a balance on a single-device filesystem.
On a filesystem with damaged replication (e.g. a RAID-1 FS with a dead 
and removed disk), it will force the FS to rebuild the missing copy of 
the data on one of the currently active devices, restoring the RAID-1 
capability of the filesystem.


