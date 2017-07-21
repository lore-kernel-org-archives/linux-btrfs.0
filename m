Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47353 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751504AbdGUSx4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 14:53:56 -0400
Message-Id: <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
From: Paul Jackson <pj@usa.net>
To: David Goodwin <david@codepoets.co.uk>, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: Re: kernel btrfs file system wedged -- is it toast?
Date: Fri, 21 Jul 2017 13:53:56 -0500
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
 <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
 <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
 <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk>
In-Reply-To: <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


My btrfs file system, after doing a "mount -oclear_cache", followed
by a "mount -ospace_cache", eleven hours ago now, is still hung.

David Goodwin suggested:
>> 'perf top' is my first thought.... it might at least highlight the area 
>> gobbling up cpu time.

Thanks for suggesting that. It has been a long time since I've done
any kernel work, and I didn't know of (or had forgotten about)
perf-tools.   I just now installed these perf tools, and perf-top shows
this btrfs activity on the system stil trying to handle the above
"mount -ospace_cache":

+   78.00%    78.00%  [btrfs]                      [k] btrfs_merge_delayed_refs
+   38.56%     0.00%  [btrfs]                      [k] transaction_kthread
+   38.56%     0.00%  [btrfs]                      [k] btrfs_commit_transaction
+   38.56%     0.00%  [btrfs]                      [k] btrfs_start_dirty_block_groups
+   38.56%     0.00%  [btrfs]                      [k] btrfs_run_delayed_refs
+   38.56%     0.00%  [btrfs]                      [k] __btrfs_run_delayed_refs

Regarding the time to balance - yes I too have many  snapshots,
perhaps 100's to over a 1000 snapshots on each of a half dozen
subvolumes, with major sharing within the subvolumes.

Graham Cobb wrote:
>>  If I understand correctly, this is because btrfs does not have
>> an efficient structure to help find all the references 

Yeah this feels like  an Order n^2 or n^3 algorithm, or worse,  in
the wrong place(s).

If this conclusion  is anywhere close to acccurate, then I would
STRONGLY encourage the key developers of btrfs to announce
loudly and clearly to any potential users, in multiple places
(perhaps a key announcement in a few places and links to that
announcement from many places, such as prominent WARNING's
in man pages, at the top of Wiki pages, and in posts on prominent
forums and Youtube with "click-bait" titles):

... Do NOT create more  than a few btrfs snapshots  in file systems
... that cannot tolerate being unexpectedly locked in uninterruptible
... kernel code, for minutes, hours, even days, depending on the
... operations being performed on them.  DO expect to first have to
... learn, the hard way, of whatever special mitigations might apply
... in ones particular circumstances, before considering deploying
... btrfs into a production environment where this, or other (what
... other?) surprising limitations of btrfs may apply.

(The above suggested warning text may be technically inaccurate.
 I'm just  guessing.)

The btrfs developers should have known this, and announced this,
a long time ago, in various prominent ways that it would be difficult
for potential new users to miss.  All the prominent places that
respond to the question of whether btrfs is ready for production
use (spanning several years now) should if possible display this
warning.

Would you buy a car with an "unusual" engine that, whenever
it happened to be driven in a certain way (a unique and wonderful
way that no other car could do), would sometimes  recommend
a certain strange button on the dash board be pushed, which
then caused the car to freeze, in place, without notice, for hours
or days?  No ... and if you had such a car, you'd be looking to
replace it, no matter how unique and useful some of its features
 were. ... and if you had not been prominently warned of this
unusual behavior ahead of time, you'd likely avoid ever buying
another car from that company ever again.

I will now reboot this PC, as that btrfs file system  is still hung after
 that  "mount -oclear_cache",  "mount -ospace_cache" sequence.
This may mean that I lose the eleven hours I've spent so far
trying to get that file system remounted and operational.  I have
no way of knowing, that I know of.  (P.S. -- Update -- Once again,
the time I've taken to compose a diatribe was time well spent.
That  "mount -ospace_cache"  has completed successfully,
in under 12 hours.)

Whether or not the key developers of btrfs know of this or not ...
either way it is sad.  They should have known, and they should
have quite public about it, for many years now.

Back in my day, such a performance bug would have made the
software containing it unreleasable, _especially_ in software such
as a major file system that is expected to provide reliable service,
where "reliable" means both preserving data integrity and 
doing so within an order of magnitude of a reasonably
expected  time.

P.S. -- Hopefully my above diatribe represents an embarrassing
lack of understanding on my part, rather than an embrarrassing
lack of integrity on the part of key btrfs developers.

-- 
                Paul Jackson
                pj@usa.net
