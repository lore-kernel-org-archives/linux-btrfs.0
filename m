From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: Error handling: How to "lose" a transaction
Date: Wed, 21 Dec 2011 22:38:41 -0500
Message-ID: <4EF2A641.7070308@suse.de>
References: <4EE7C7F2.2080905@suse.com> <20111214001319.GX31158@shiny> <4EF29D0C.90709@suse.de> <4EF2A24D.7040501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>, Mark Fasheh <mfasheh@suse.de>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF2A24D.7040501@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/21/2011 10:21 PM, Liu Bo wrote:
> On 12/22/2011 10:59 AM, Jeff Mahoney wrote: Sorry I haven't
> responded to this yet. I started digging right in and I've started
> to have some good results. It turns out there's already a 
> btrfs_cleanup_transaction call that will tear down outstanding 
> transactions. It's not perfect and I've fixed a few bugs in there,
> but it saved me a bunch of effort. I just wished I noticed it a day
> before since I had it half implemented myself. :)
> 
> 
>> Hi Jeff,
> 
>> Yes, it should be, and I wrote this cleanup_transaction where I
>> should notice you earlier... Anyway, thanks for your effort.
> 
>> The error handling part has lots of corner cases, so I just pick
>> up a brute way to tear down the current transaction in order to
>> make the FS RO.

Oh, and it's worked great. The brute force method is a good start and
will address the most severe problems (and most cases) well. I've
decided to ignore most cases of -ENOMEM for now. The biggest bug I ran
into so far was calling mutex_lock while holding a spinlock. It was a
quick fix.

The method I've generally used is to mark the transaction aborted and
pass the error up as quickly as possible, cleaning up the local
allocations and locks as I go. The transaction gets completed
normally, returns an error, isn't committed, and then is destroyed
(with others, potentially) when called from in
btrfs_commit_transaction. Btrfs makes this super easy since we can
just skip all the CoW writes.

Thanks!

- -Jeff


>> thanks, liubo
> 
> This afternoon I started running xfstests on a dm-linear mapped 
> partition. Halfway through a sufficiently long test, I swap out
> the linear mapping to an error mapping. It still crashes, but
> somewhat less spectacularly. There are still a ton of BUG_ON's I
> need to eliminate as well as work out the usual I/O error-recovery
> issue of uninterruptible, unrecoverable writeback contexts and
> still-locked pages holding up exit. I'm pretty pleased with the
> results so far and am pretty optimistic.
> 
> -Jeff
> 
> 
>> -- To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>> 
> 

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO8qZBAAoJEB57S2MheeWyCtYP/0+VGdUrdPceYkMGngweINFI
Y6K/xzDG2tiogFyb8mVj4XH9xtGoODWiZ+yb2FkRfoqsq1dS34/XzM1Cf1SBgFTu
J8xIxv3gVp0lDycV6QqpetNaPPpxDz61LmiFqNRd6bn/usBoYdlyexX3HmPll7Je
MS0uAiUVNTJIK+W3qN9BIyvg8F61XFy3SdeCY5dmzClDJft1dgu6mWlHhcKVL7LW
uDrX9vldV56qoL6rrNyR/wBVg8rhMxVN5z9qFttWsSpORwZdIOIUdKiTULqnCdvf
mzs1yNAsAMTcE0GCLOIWEyiTSZrDlg4nGgZMIDKnzD0GywJDy+qc/9XPL+5WkyaD
Z48a6sBCXGhmQsux8iEeGAlTfP5/YJMd2PqaKfFlpSeL2u+Pt6EAFUpEUfXDYRhI
aBxzJK7D+GrgduheWTQc2AgeH8ee7bUEe1k+d4+EIWJTq5vKkPWH7x580q0yL+t2
qiLqzSlSTPaCr9tJlQo3d+dHu2L2r43+2qYeHut0JjFtp2dDjWO7AzcQ2JsL0yZR
jL0dVT96OsWkmKu/qfvSbFZ6LLR+QrlqBzTgNA4R69nLlUj1f05AVaYvwuVqnIPH
QdCf53kaEjvVlRw2WScsRHT1gMY62jmES0glIBgAH9bKAYKADlnzIAW6RSpB8NcO
GZoCa+90OHl/kkXWB2eZ
=DR3D
-----END PGP SIGNATURE-----
