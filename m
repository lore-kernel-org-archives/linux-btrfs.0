From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: synchronous removal?
Date: Tue, 08 Mar 2011 09:36:47 +0100
Message-ID: <4D75EA9F.1030302@gmail.com>
References: <4C55E2F3.3030202@noir.com> <AANLkTin=o404zv6qtgfzdbV2KoHkDxTaHEifk26XWnCY@mail.gmail.com> <C76A65F2-765A-44EB-977C-0268049A82F7@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Leonidas Spyropoulos <artafinde@gmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C76A65F2-765A-44EB-977C-0268049A82F7@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi,

I came across this when I tried to build a backup server. Was there
any change on this in the meantime?

Thanks,
Andreas

On 02.08.2010 17:25, K. Richard Pixley wrote:
> How would you determine whether to remove another snapshot or to
> wait for previously removed space to be digested?
>
> If you simply remove snapshots then you'll end up removing all if
> your snapshots and df will still say you don't have enough space.
> Btdt. What I'm doing right now is removing a snapshot and
> immediately sleeping for 60 seconds in hopes that it will be
> digested in that time. Judicious use of df and log lines tell me
> that some of the space is digested in that time but I have no way,
> (that I know of), to determine whether all of it has been.
>
> --rich
>
> On Aug 2, 2010, at 4:35, Leonidas Spyropoulos <artafinde@gmail.com>
> wrote:
>
>> I think a cron job checking the output of df could do that. The
>> shell script will check if there is enough space to create a
>> snapshot otherwise remove a snapshot.
>>
>> How about that?
>>
>> On Sun, Aug 1, 2010 at 10:11 PM, K. Richard Pixley
>> <rich@noir.com> wrote:
>>> I have an application where I want to snapshot, then do
>>> something, and based on the result, snapshot either the result
>>> or the previous state and then repeat.
>>>
>>> So far, so good. But eventually my disk fills and I want to
>>> remove the oldest snapshots, as many as I need to in order to
>>> make room enough for the next cycle.
>>>
>>> I notice that when I remove old snapshots and delete old
>>> directories, the free space on my disk, (according to df),
>>> doesn't rise immediately. But instead, I see an active
>>> btrfs_cleaner for a while and my free space rises while it
>>> runs. I'm presuming that the removed files and snapshots
>>> aren't fully reclaimed immediately but rather wait for
>>> something akin to a garbage collection much the way modern
>>> berkeley file systems do.
>>>
>>> How can I either:
>>>
>>> a) wait for the cleaner to digest the free space b) determine
>>> that the cleaner has digested all available free space for
>>> now, (if not I can sleep for a while) c) synchronously force
>>> the cleaner to digest available free space d) something else I
>>> haven't thought of yet
>>>
>>> Basically, I want to check to see if there's enough space
>>> available. If not, I want to remove some things, (including at
>>> least one snapshot), wait for the cleaner to digest, and then
>>> start over with the checking to see if there's enough space
>>> available and loop until I've removed enough things that there
>>> is enough space available. How can I do that on a btrfs file
>>> system?
>>>
>>> --rich -- To unsubscribe from this list: send the line
>>> "unsubscribe linux-btrfs" in the body of a message to
>>> majordomo@vger.kernel.org More majordomo info at
>>> http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> -- Caution: breathing may be hazardous to your health. -- To
>> unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNdeqeAAoJEJIcBJ3+Xkgiba8P/jb1a5K5cNuyrQTH9G3fM9X6
d1a249qdKTgr7AJkuNPQzu3xjvBJeKtFraHfMDBDQTRPmysqnUvMQmHz+dp9NmMe
mqStwhKLxxmus5B3IfGClztbhTPmkVJPVykFwcga9zYvNK3jrC+D6Y85IjLFGRBx
BCHaZIwzlDtcsDf38+/6zd7pHUtN5UR64mlvyyMQVOl+KEcAyNmDNwgvVDG3BhJK
wswF3GE1H0G69jkJb0dOLfLzdLvNyxjdLHYVGMx7GMnEMuYIEgJZsVkT1Anqmql8
gcKjE4kvyC9zz93c6gdJOyO/RVF7dcHP4uQY7FvM9kp+ubkeA08jZcctqz+B2yR8
fpomkeogg/7AUb2my4bpmqEULpSf6PgcKUshZFFAJQBmDxbfyiIDIo2oExbnN+qq
m+Kmg7CBwMTtVNUUen+Cdl3y7oleQ8d8XzzW+hSBq3KQQfGowh1bpp12FKbwbgDx
h4WvGbLF1tLXedP2puCYR6Dg0Th/WWwxBytKZjdyVSWX4XaJUePw/CLfvtNSpAt4
GbCiltIa8LSnJvlYZabwJhTtcEoeUl+Xu/03pZbiaDnFP3kMDqUBm8RMHwnpkmmo
z9tr5mBZFXYb7x2T2Idk5Oh7Ii53Q3XW0bgKf7mkxVvSb9TM+t/vnOX4mLBoVMun
qJoGA8SiN72k13Ki8F1H
=jxH9
-----END PGP SIGNATURE-----

