Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4044 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbcEKBDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 21:03:35 -0400
Subject: Re: About in-band dedupe for v4.7
To: Mark Fasheh <mfasheh@suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
Date: Wed, 11 May 2016 09:03:24 +0800
MIME-Version: 1.0
In-Reply-To: <20160510221119.GD7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/05/10 15:11 -0700:
> On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
>> Hi, Chris, Josef and David,
>>
>> As merge window for v4.7 is coming, it would be good to hear your
>> ideas about the inband dedupe.
>>
>> We are addressing the ENOSPC problem which Josef pointed out, and we
>> believe the final fix patch would come out at the beginning of the
>> merge window.(Next week)
>
> How about the fiemap performance problem you referenced before? My guess is
> that it happens because you don't coalesce writes into anything larger than
> a page so you're stuck deduping at some silly size like 4k. This in turn
> fragments the files so much that fiemap has a hard time walking backrefs.
Nope. Default dedupe size is 128K, and minimal dedupe size is limited to 
64K maximum to 8M.
Yes, it's going to cause fragements, but just check the test case I 
submitted, it doesn't ever need dedupe to trigger the bug.
Clone range will also trigger it.

The problem is quite obvious, btrfs_check_shared() is doing wrong judgment.

It's using find_parent_nodes() to do shared check, while it's completely 
possible a file extent to be shared with other inodes inside the same root.

So our fix is to change btrfs_check_shared(), if a file extent is shared 
between even the same inode but different offset, then it's a shared 
extent, btrfs_check_shared() will exit.

The fix shows pretty positive result yet, and we are just doing the 
final check.
It would be out in recent days.


Yes, there is still root cause hidden behind the whole thing:
Slow(non-cached) backref walk, which will not only affects the old 
check_shared() function, but impact more on qgroup.
(Walking through all the 8192 backrefs of a fully dedupe 1G file takes 
about 5 full seconds)

However the cache for backref walk is almost impossible to implement, as 
any snapshot can easily trash all the cache we have done before.

For that case, we are going to add TTL(time to live) for in-memory cache 
after v4.7, to ensure a dedupe hash will be trashed after specified 
cache hit (64 or 128 seems quite reasonable for me, of course it's 
tuneable).

Oh, you're then going to think I'm not fixing the thing?
It's an *EXISTING* defeat and it's dedupe to make *you* aware of the bug.

>
> I have to check the patches to be sure but perhaps you can tell me whether
> my hunch is correct or not.
>
>
> In fact, I actually asked privately for time to review your dedupe patches,
> but I've been literally so busy cleaning up after the mess you left in your
> last qgroups rewrite I haven't had time.
>
> You literally broke qgroups in almost every spot that matters. In some cases
> (drop_snapshot) you tore out working code and left in a /* TODO */ comment
> for someone else to complete.  Snapshot create was so trivially and
> completely broken by your changes that weeks later, I'm still hunting a
> solution which doesn't involve adding an extra _commit_ to our commit.  This
> is a MASSIVE regression from where we were before.

If you think my rework is a mess, then before that, qgroup is just 
rubbish, it can't even handle reflink between subvolume(btrfs/091), not 
to mention the hell of leaked reserved space(btrfs/099).


You were just overlooking the old qgroup things, thinking old one 
working and use the corner spot to express your disappointment.

The rework is mainly focused on fixing the main and real part of the 
qgroup. Normal accounting routine.

If you think the already broken qgroups is better just because it can 
handle snapshot and subvolume delete but all other part broken.
Then, feel free to revert all my qgroup rework and provide a better 
solution.

>
> IMHO, you should not be trusted with large features or rewrites until you
> can demonstrate:
>
>  - A willingness to *completely* solve the problem you are trying to 'fix',
>    not do half the job which someone else will have to complete for you.

OK, just let the qgroup break forever?
Have you ever noticed the problem before the rework? What are you doing 
before that?
Did you ever want to fix it before the rework?

Yes good corner spot and good whole accounting is perfect.

But it's super wired for you to think bad whole accounting with good 
corner case is even better than good whole accounting with bad corner case.

Any sane will fix the whole part thing first, and then the corner case.
>
>  - Actual testing. The snapshot bug I reference above exists purely because
>    nobody created a snapshot inside of one and checked the qgroup numbers!

Just check the qgroup test cases.

Same word can also be said to yourself.

Why didn't you spot leaked reserve space and reflink problem and even 
the long failed test cases of qgroup test group?

It's always easier to complain others work than provide a good one.

Thanks,
Qu

>
> Sorry to be so harsh.
>    --Mark
>
> --
> Mark Fasheh
>
>


