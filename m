From: Arne Jansen <sensille@gmx.net>
Subject: Re: Quota Implementation
Date: Sat, 04 Jun 2011 08:25:38 +0200
Message-ID: <4DE9CFE2.9050104@gmx.net>
References: <4DE90AC9.5040106@gmx.net> <201106032318.38305.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>, hch@infradead.org,
	ricwheeler@gmail.com, linux-fsdevel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201106032318.38305.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 03.06.2011 23:18, Johannes Hirte wrote:
> On Friday 03 June 2011 18:24:41 Arne Jansen wrote:
>> Hi,
>>
>> If no one is already working on it, I'd like to take the Quota lock and
>> see how far I come.
>> Let me sketch out in short what I'm planning to do:
>>
>>    - Quota will be subvolume based. Only the FS-trees and data extents
>>      will be accounted.
>>    - Quota Groups can be defined. Every quota group can comprise any
>>      number of subvolumes. A subvolume can be assigned to any number
>>      of quota groups.
>>    - A Quota Group can account/limit the total amount of space that is
>>      referenced by it and/or the amount of space that is exclusively
>>      referenced (i.e. referenced by no other quota group).
>>    - With this it is possible to define a hierarchical quota that need
>>      not necessarily reflect the filesystem hierarchy.
>>    - It is also possible to decide for each snapshot if it should be
>>      accounted into the parent group. So in a scenario where each
>>      subvolume reflect a user home, it's possible to have some snapshots
>>      accounted to the user and others not (e.g. the ones needed for system
>>      backups).
>>    - Quota information will be stored in new records, possibly in a
>>      separate tree.
>>    - It should be possible to change the Quota config and group
>>      assignments online, though this might need a full re-scan of the fs.
>>    - It does NOT include any kind of user/group (UID/GID) quota.
>>
>> Any addenda or arguments why it's impossible or insane welcome.
>
> What's the benefit of this complexity? Why not a more simple quota/reservation
> per subvolume?

Because it's already the simplest solution I can think of. The
described scenarios are not arbitrary, I'm going to need all of
them. Just having a subvolume limitation in the sense that the
amount of referenced data is limited makes implementation of those
impossible, even with user quota. Implementation with the proposed
mechanisms would be very straightforward and wouldn't need any
tricks. Btw, in my use case every user has the same UID.

> The semantics you described, can be achived by user/group
> quotas too. And we need them anyway. Perhaps this can be implemented together,
> reusing the code. Then we have the question if user/group quotas are per
> filesystem or per subvolume.

I currently have no use of user quotas, and sensibly implementing them
in the presence of writable snapshots and cp --reflink would probably
lead to a design similar to the above.

-Arne

>
> regards,
>    Johannes
