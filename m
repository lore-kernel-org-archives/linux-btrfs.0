Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:57562 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaLPNYk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 08:24:40 -0500
Received: by mail-yk0-f174.google.com with SMTP id 10so5875432ykt.5
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 05:24:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <549017E8.7060107@cn.fujitsu.com>
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>
	<548B4117.1040007@inwind.it>
	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>
	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com>
	<CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com>
	<548E377D.6030804@cn.fujitsu.com>
	<548E7A7A.90505@pobox.com>
	<548E929B.2090203@pobox.com>
	<548E9B38.9080202@cn.fujitsu.com>
	<548EABBB.4060204@pobox.com>
	<548FA762.2070504@pobox.com>
	<549017E8.7060107@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 21:24:39 +0800
Message-ID: <CA+qeAOoJ5w-Sqts4j+o56ko72RztGyXWTaWohY2GmAPDvjq+NA@mail.gmail.com>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Robert White <rwhite@pobox.com>, Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 16, 2014 at 7:30 PM, Dongsheng Yang
<yangds.fnst@cn.fujitsu.com> wrote:
> On 12/16/2014 11:30 AM, Robert White wrote:
>>
>> On 12/15/2014 01:36 AM, Robert White wrote:
>>>
>>> So we don't just hand-wave over statfs(). We include the
>>> dev_item.bytes_excluded in the superblock and we decide once-and-for-all
>>> (with any geometry creation, or completed conversion) how many bytes
>>> just _can't_ be reached but only once we _know_ they cant be reached.
>>> And we memorialize that unreachable data in the superblocks.
>>>
>>> Thereafter we report the raw numbers after subtracting anything we know
>>> cannot be reached.
>>>
>>> All other "helpful" solutions are NP-complete and insoluble.
>>
>>
>> On multiple re-readings of my own words and running off to the POSIX
>> definitions _and_ kernel sources (which don't agree).
>>
>> The practical bits first ::
>>
>> I would add a "-c | --compatable" option to btrfs fi df
>> that let it produce /bin/df format-compatable output that gave the "real"
>> numbers as defined near the end.
>>
>>
>> /dev/sda 1TiB
>> /dev/sdb 2TiB
>>
>>
>> mkfs.btrfs /dev/sd{a,b} -d raid1
>>
>> @size=3TiB @used=0TiB @available=2TiB
>>
>> The above would be ideal. But POSIX says "no". f_blocks is defined (only
>> in the comments) as "total data blocks in the filesystem" and /bin/df pivots
>> on that assumption, so the only usable option left is ::
>>
>> @size=2TiB @used=0TiB @available=2TiB
>>
>> After which @used would be the real, raw space consumed. If it takes 2GiB
>> or 4GiB to store 1GiB (q.v. RAID 1 and 10) then @used would go up by that 2
>> or 4 GiB.
>
>
> Hi Robert, thanx for your proposal about this.
>
> IMHO, output of df command shoud be more friendly to user.
> Well, I think we have a disagreement on this point, let's take a look at
> what the zfs is doing.
>
> /dev/sda7- 10G
> /dev/sda8- 10G
> # zpool create myzpool mirror /dev/sda7 /dev/sda8 -f
> # df -h /myzpool/
> Filesystem      Size  Used Avail Use% Mounted on
> myzpool         9.8G   21K  9.8G   1% /myzpool
>
> That said that df command should tell user the space info they can see.
> It means the output is the information from the FS level rather than device
> level or _storage_manager level.

Addition:

There are some other ways to get the space information in btrfs, btrfs
fi df, btrfs fi show, btrfs-debug-tree.

The df command we discussed here is on the top level which is directly
facing the user. Let me try to show the difference in different level.

1), TOP level, for a linux user: df command.
For a linux user, he does not care about the detail how the data is
stored in devices.
They do not care even not know what's Single, what does DUP mean, and how
a fs implement the RAID10. What they want to know is *what is the size
of the filesystem
I am using and how much space is still available to me*. That's what I
said by "FS space level)

2). Middle level, for a btrfs user: btrfs fi df/show.
For a btrfs user, they know about the single, dup and RAIDX. When they
want to know
what's the raid level in each space info, they can use btrfs fi df to
print the information
they want.

3). Device level. for debugging.
Sometimes, you need to know how the each chunk is stored in device. Please
use btrfs-debug-tree to show details you want as more as possible.

After all, I would say, the information you want to show is *not*
incorrect to me, but it's not the
business of df command.

Thanx
>
> Thanx
> Yang
>
>>
>> Given the not-displayed, not reported, excluded_by_geometry values (e.g.
>> @waste) the equation should always be ::
>>
>> @size - @waste = @used + @available
>>
>> The fact that /bin/df doesn't display all four values is just tough, The
>> fact that it calculates one "for us" is really annoying, show-super would be
>> the place to go find the truth.
>>
>> The @waste value is soft because while 1TiB of /dev/sdb that is not going
>> to be used isn't a _particular_ 1TiB. It could be low blocks or high blocks
>> or randomly distributed blocks that end up not having data.
>>
>> So keeping with my thought that (ideally) @size should be the "safe dd
>> size" for doing a raw-block transcribe of the devices and filesystem, it is
>> most correct for @size to be real storage size. But sadly, posix didn't
>> define that value for that role, so we are forced to munge around.
>> (particularly since /bin/df calculates stuff "for us").
>>
>>
>> Calculation of the @waste would have to happen in two phases. At
>> initiation phase of any convert @waste would be set to zero. At completion
>> of any _full_ convert, when we know that there are no leftover bits that
>> could lead to rampant mis-report, @waste would be calculated for each device
>> as a dev_item. Then the total would be stored as a global item.
>>
>> btrfs tools would report all four items.
>>
>> statfs() would have to report (@size-@waste) and @available, but that's a
>> problem with limits to the assumptions made by statfs() designers two
>> decades ago.
>>
>> I don't know which numbers we keep on hand and which we derive so...
>>
>> @available, if calculated dynamically would be
>> sum(@size, -@waste, -@used).
>>
>> @used, if calculated dynamically, would be
>> sum(@size, -@waste, -@available).
>>
>> This would also keep all the determinations of @waste well defined and
>> relegated to specific, infrequently executed blocks of code.
>>
>> GIVEN ALSO ::
>>
>> The BTRFS dynamic internal layout allows for completely valid states that
>> are inconsistent with the current filesystem flags... Such as it is legal to
>> set the RAID1 mode for data but still having RAID0, RAID5, and any manner of
>> other extents present... there is no finite solution to every particular
>> layout that exists.
>>
>> This condition is even _mandatory_ in an evolving system. May persist if
>> conversion is interrupted and then the balance is aborted. And might be
>> purely legal if you supply a convert option and limit the number of blocks
>> to process in the same run.
>>
>> Each individual extent block is it's own master in terms of what "mode the
>> filesystem is actally in" when that extent is being accessed. This fact is
>> _unchangeable_.
>>
>>
>> STANDARDS REFERENCES and Issues...
>>
>> The actual standard from POSIX at The Open Group refers to f_blocks as
>> "Total number of blocks on file system in units of f_frsize".
>>
>> See ::
>> http://pubs.opengroup.org/onlinepubs/009695399/basedefs/sys/statvfs.h.html
>>
>> The linux kernel source and man pages say "total data blocks in
>> filesystem".
>>
>> I don't know where/when/why the "total blocks" got re-qualified as "total
>> data blocks" in the linux history, but it's probably incorrect on plain
>> reading.
>>
>> The df command itself suffers a similar problem as the POSIX standard
>> doesn't talk about "data blocks" etc.
>>
>> Problematically, of course, the statfs() call doesn't really allow for any
>> means to address slack/waste space and the reverse calculation for us
>> becomes impossible.
>>
>> This gets back to the "no right answer in BTRFS" issue.
>>
>> There is a lot of missing magic here. Back when INODES where just one
>> thing with one size statfs results were probably either-or and "Everybody
>> Knew" how to turn the inode count into a block count and history just rolled
>> on.
>>
>> I think the real answer would be to invent an expanded statfs() call that
>> returned the real numbers for @total_size, @system_overhead_used,
>> @waste_space, @unusable_space, etc -- that is to come up with a generic
>> model for a modern storage system -- and let real calculations take place.
>> But I don't have the "community chops" to start that ball rolling.
>>
>> CONCLUSIONS ::
>>
>> Given the inherent assumptions of statfs(), there is _no_ solution that
>> will be correct in all cases.
>> .
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
