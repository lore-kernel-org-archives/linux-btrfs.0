From: Arne Jansen <sensille@gmx.net>
Subject: Re: Quota Implementation
Date: Sat, 04 Jun 2011 10:04:03 +0200
Message-ID: <4DE9E6F3.7060200@gmx.net>
References: <4DE90AC9.5040106@gmx.net> <20110603164730.GB10842@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>, hch@infradead.org,
	ricwheeler@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110603164730.GB10842@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 03.06.2011 18:47, Hugo Mills wrote:
> On Fri, Jun 03, 2011 at 06:24:41PM +0200, Arne Jansen wrote:
>> Hi,
>>
>> If no one is already working on it, I'd like to take the Quota lock and
>> see how far I come.
>> Let me sketch out in short what I'm planning to do:
>>
>>   - Quota will be subvolume based. Only the FS-trees and data extents
>>     will be accounted.
>>   - Quota Groups can be defined. Every quota group can comprise any
>>     number of subvolumes. A subvolume can be assigned to any number
>>     of quota groups.
>>   - A Quota Group can account/limit the total amount of space that is
>>     referenced by it and/or the amount of space that is exclusively
>>     referenced (i.e. referenced by no other quota group).
>>   - With this it is possible to define a hierarchical quota that need
>>     not necessarily reflect the filesystem hierarchy.
>>   - It is also possible to decide for each snapshot if it should be
>>     accounted into the parent group. So in a scenario where each
>>     subvolume reflect a user home, it's possible to have some snapshots
>>     accounted to the user and others not (e.g. the ones needed for system
>>     backups).
>>   - Quota information will be stored in new records, possibly in a
>>     separate tree.
>>   - It should be possible to change the Quota config and group
>>     assignments online, though this might need a full re-scan of the fs.
>>   - It does NOT include any kind of user/group (UID/GID) quota.
>>
>> Any addenda or arguments why it's impossible or insane welcome.
>
>     There's a problem in that in some cases, it's possible to get into
> a situation where you can't *delete* files because you're going over
> quota. If I have two subvolumes that share most of their data
> (e.g. one is a snapshot of the other), and both subvolumes have a
> limit under the "exclusive use" clause, then deleting material from
> subvolume A could cause subvolume B to go over quota.

I wouldn't prevent the deletion in A, but let go B over quota instead.
Maybe a limit on exclusive use is of little practical use, but a
tracking of it is very useful, as it is the space that will get freed
if this subvol should get deleted. So it is an answer to the question
'how big is this snapshot?'.

