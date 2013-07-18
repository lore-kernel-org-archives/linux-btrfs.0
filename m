Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob13.myregisteredsite.com ([209.17.115.51]:34957 "EHLO
	atl4mhob13.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570Ab3GRARA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 20:17:00 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob13.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r6I0Gwdr026186
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 20:16:58 -0400
Message-ID: <51E733FF.2070102@chinilu.com>
Date: Wed, 17 Jul 2013 17:17:03 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: What is the current status of defragmentation?
References: <51E7182F.9020009@statystyka.net>
In-Reply-To: <51E7182F.9020009@statystyka.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Adam,  I routinely defrag my filesystems and here is how I do it:

find /home -type d -mtime -3 -o -type f -mtime -3 | egrep -v 
"Cache|cache" | while read file; do /usr/sbin/btrfs filesystem defrag -f 
-v "${file}"; done

The above is what I use to defrag my data (non-OS) files.  I use a while 
loop because it relieves pressure on the system by guaranteeing that 
each file and directory are processed one at a time.  I use "-mtime -3" 
because I run this script daily via anacron and I see no reason to 
defragment user files over and over again.  I specifically filter out 
"cache" directories because they take forever to defragment and are 
refragmented in no time anyway and they are simply low priority for me 
in terms of performance. I may revisit that policy again sometime in the 
future, but for now I have been skipping them.

The following is what I use for system files:


find / -type d -mtime -3 -o -type f | while read file; do 
/usr/sbin/btrfs filesystem  defrag -f -v "${file}"; done

This is very similar to what I use for user files except I go back only 
for 3 days on directories (meta data), but run defrag on every file in 
the system every day just in case.  This approach has worked very well 
for me, but your mileage may vary (no guarantees).  Also, in the case of 
the system files noted above, I defrag daily and ALWAYS OFFLINE, because 
at this point as I understand things, btrfs cannot defragment files when 
they are currently in use.  I get around this issue by doing system (/) 
defrags only offline.

That's how I do it.

- George



On 07/17/2013 03:18 PM, Adam Ryczkowski wrote:
> Today I booted my linux-mint 14 into the latest 3.10.1 kernel to
> defragment the root btrfs filesystem on my ASUS N56VZ laptop with hybrid
> Seagate Momentus XT disk. I did something like
>
>     find / -exec btrfs filesystem defrag {}
>
> To my amazement it didn't really made a lot of I/O (the HDD LED wasn't
> blinking). Confident that at the beginning the defragmentation is
> CPU-bound (like it sometimes is for instance in case of O&O Defrag on
> Windows world), I let it go on, and I switched myself to my other
> chores. After a few minutes my system froze. I was barely able to switch
> to text terminal and login, but I couldn't reach bash prompt; it looked
> like the OS couln't perform any I/O on the disk. At the end, the system
> responded to SysRq REISUB combination though; Unfortunately I can't
> reproduce exactly what I typed in, because the command was not logged to
> the bash history...).
>
> It clearly showed me, that defragmenting the filesystem is not that
> trivial, as it is for ext4. So I have quesions:
>
> * Is the defragmentation of the whole filesystem supported at all? I
> can't find a single reference that it is, and a syntax of btrfs-progs
> suggest that it isn't. If supported, under what conditions? Like what %
> of free space should be available?
>
> * How to check the level of defragmentation, and what are the reasonable
> threshold values, that should indicate the desktop filesystem needs
> defragmenting? I know, that everyone's millage my vary; I just want to
> know some values as a point-of-reference.
>
> * What is the recommended command, that would efficiently defragment the
> whole file system, preferably with some sort of progress indication?
> Does this command
>
> find / -type f -o -type d -print0 | xargs --null --no-run-if-empty btrfs
> filesystem defragment -cv
>
> look like a reasonable idiom for defragmenting the whole filesystem?
>
> Thank you for your help,
>
> Adam Ryczkowski
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

