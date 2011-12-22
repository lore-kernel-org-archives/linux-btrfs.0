From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Error handling: How to "lose" a transaction
Date: Thu, 22 Dec 2011 11:21:49 +0800
Message-ID: <4EF2A24D.7040501@cn.fujitsu.com>
References: <4EE7C7F2.2080905@suse.com> <20111214001319.GX31158@shiny> <4EF29D0C.90709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>, Mark Fasheh <mfasheh@suse.de>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF29D0C.90709@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/22/2011 10:59 AM, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/13/2011 07:13 PM, Chris Mason wrote:
>> On Tue, Dec 13, 2011 at 04:47:30PM -0500, Jeff Mahoney wrote:
>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>>
>>>
>>> Hi Chris -
>>>
>>> I'm starting to dig into the fun part of error handling and 
>>> btrfs_commit_transaction is a minefield right now.
>>>
>>> I've been thinking about how I would go about recovering from a 
>>> serious error like an -EIO while writing out or an -ENOMEM in a
>>> deep part of the code that it's prohibitively expensive to
>>> recover from. Mostly I'm looking for the best way to make calling
>>> btrfs_std_error() be functionally equivalent to killing the power
>>> on the disk. We already block off new writers, but that's
>>> obviously nowhere near enough. We could have an open transaction
>>> floating around, uncommitted transactions queued, and then an
>>> unrecoverable error hits, forcing us to shut it all down.
>>>
>>> It seems to me that that a similar method of recovery that I
>>> wrote for reiserfs can be used here as well. Am I understanding
>>> correctly that if I go through the motions of committing the
>>> transaction *except* for updating the tree roots, or maybe even
>>> doing that but declining to write the superblocks out, that the
>>> transaction essentially doesn't exist on disk? Including the
>>> allocations? The in-memory representation will not match what's
>>> on disk, but that's what happens with every file system in
>>> RO-failure mode. With CoW even for data, data is essentially 
>>> frozen in time as well. (I suppose with nodatacow that's not
>>> true, but that's for another day.)
>> Hi Jeff,
>>
>> Thanks for taking another pass at this.
>>
>> It should be possible to just skip the step where we update the
>> roots in the super and you'll keep a fully consistent FS on disk.
>> The only rule would be that you're not allowed to take a block that
>> we've freed in the aborted transaction and reuse it.
> 
> Perfect.
> 
> Sorry I haven't responded to this yet. I started digging right in and
> I've started to have some good results. It turns out there's already a
> btrfs_cleanup_transaction call that will tear down outstanding
> transactions. It's not perfect and I've fixed a few bugs in there, but
> it saved me a bunch of effort. I just wished I noticed it a day before
> since I had it half implemented myself. :)
> 

Hi Jeff,

Yes, it should be, and I wrote this cleanup_transaction where I should notice you earlier...
Anyway, thanks for your effort.

The error handling part has lots of corner cases, so I just pick up
a brute way to tear down the current transaction in order to make the FS RO.

thanks,
liubo

> This afternoon I started running xfstests on a dm-linear mapped
> partition. Halfway through a sufficiently long test, I swap out the
> linear mapping to an error mapping. It still crashes, but somewhat
> less spectacularly. There are still a ton of BUG_ON's I need to
> eliminate as well as work out the usual I/O error-recovery issue of
> uninterruptible, unrecoverable writeback contexts and still-locked
> pages holding up exit. I'm pretty pleased with the results so far and
> am pretty optimistic.
> 
> - -Jeff
> 
> 
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJO8p0MAAoJEB57S2MheeWyF4YP/A6uUzuP4zui+iwenSP44trw
> FkONuTidZRjSgA4tXNrdsnIF2txtiewzp0HvWWudw5rnMNQzznyO0WynKHSPG3ep
> xFZnfpvaYoCaMQt70IxAQFDsZpowbPAI8194mbJqKAql4f2RNzlg/3fR4k+Fz6Ye
> Gu824uEbtyHghy96C37e/E30Zizu6+S7xrx8jwmnKbq44docoIV3Pw9LZGOU99Db
> 1IFipExd0Z/ZhTTiK4gZ787nPhM9QNfxw/9+h1g4gUfJqlcmRrcwGJmOj5iOBGBt
> Man51ZCI8hYBpubTgvTQalut+uLq9lCoBZQGTbKHLNLd21qM+Ji4KCAQzMBUtqGn
> pzSfs3Gdwa1WjYszINAS6gqA+0ubh1F/WxGwJKW85JnAYy8OjTJHru7GlYzt3C9Y
> gouU7xgrneVn+lZFwV9X0gwX8yLQx5Lh9YEF6AJLXJuXHg4zGZyhpFjVkmTlle93
> dFUblB92q9lxdw5V8f1Uw+EDIlACZZRo7MFDSypjdTTryRFiAjhCtBdBpnu54Mrb
> fH2kdhPCBm4YqAQLlo43aOPAbkOYElAr0rgPvqaLzimZLAW0kd/nGU/if3mhMMa2
> 7ad7tKTQyktyGKuEkMPnSCU8SqFNGA750aeFG22uJJjbdCytyzkJmeqYQD5oykqm
> vDpKh0g20Fcqb98q+qbt
> =jjDk
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

