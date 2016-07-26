Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33384 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbcGZJ21 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 05:28:27 -0400
Received: by mail-it0-f66.google.com with SMTP id d65so238336ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 02:28:27 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <8893545f-3a01-d1ac-517f-6536539dc69b@cn.fujitsu.com>
References: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H7sbHH16nFextVEwY_zYHyKhpSQE7phm687Viuq5U0k6A@mail.gmail.com> <8893545f-3a01-d1ac-517f-6536539dc69b@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 26 Jul 2016 10:28:25 +0100
Message-ID: <CAL3q7H46wzBB0w3iBb9B_1Zu2yRKp27LyFSXHVuEnaq861FKGQ@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: send: Disable clone detection
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 26, 2016 at 1:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 07/25/2016 09:48 PM, Filipe Manana wrote:
>>
>> On Mon, Jul 25, 2016 at 8:19 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> This patch will disable clone detection of send.
>>>
>>> The main problem of clone detetion in send is its memory usage and long
>>> execution time.
>>>
>>> The clone detection is done by iterating all backrefs and adding backref
>>> whose root is the source.
>>>
>>> However iterating all backrefs is already quite a bad idea, we should
>>> never try to do it in a loop, and unfortunately in-band/out-of-band and
>>> reflink can easily create a file whose file extents are point to the
>>> same extent.
>>>
>>> In that case, btrfs will do backref walk for the same extent again and
>>> again, until either OOM or soft lockup is triggered.
>>>
>>> So disabling clone detection until we find a method that iterates
>>> backrefs of one extent only once, just like what balance/qgroup is doing.
>>
>>
>> Is this really a common scenario?
>
>
> If any user can create such file without root privilege, and takes kernel
> CPU for a long time, no matter if it's a common scenario, it's a big
> problem.

He can also cause large cpu consumption by making an extent shared
many many times. There's a recent generic fstests case that exercises
that (keeps doing reflinks until ENOSPC happens).
Shall we disable reflink support too? (clone and extent_same ioctls)

>
>> I don't recall ever seeing a report of such slow down or oom due to
>> the same file pointing to the same extent thousands of times.
>
> Then, check the test case I submitted days ago. No dedupe involved at all.
> IIRC, I have Cced you.
>
> https://patchwork.kernel.org/patch/9235825/
>
> And, FIEMAP ioctl has the same problem, test case is already merged into
> fstests, check generic/352.

Yes, I saw that.

>
>> Sure it's easy to create such scenario with artificial test data for
>> our inband deduplication feature (and we should really strive to make
>> what we have stable and reliable rather than add yet more features).
>
>
> This can be triggered even without the dedupe. Just check the test case.

I have been around long enough to realize we can get shared extents
without the dedupe ioctl...
What I'm telling you is that instead of adding yet more ways for a
user to shoot himself/herself in the foot, we should fix first the
core problems.


>
> And you should yell at out-of-band dedupe first than in-band, because with
> out-of-band dedupe, all these bugs can be triggered for a long time, but no
> one really cares until it's exposed by in-band dedupe.

Just because we already have ways to get into a problem, then it's ok
to add yet one more way to get into the problem?
Doesn't make a lot of sense to me.

>
> The only thing dedupe get involved is, it makes us know there is still a lot
> of bugs that no one really cares before.

Or you think no one cares about.

>
>>
>> What needs to be fixed here is the common backref walking code, called
>> by send plus a few other places (fiemap and some ioctls at least), for
>> which IIRC there was
>> some recent patch from one of your colleagues.
>
>
> Yes, Lu's fix for fiemap is OK, but that won't really fix the problem.
> The fix is only for fiemap, as it just do a early exit, instead of always do
> a backref walk.
>
> There are several backref callers, including:
> 1) balance
> 2) qgroup
> 3) fiemap (check_shared)
> 4) send
>
> But for the same reflinked file, 1) and 2) won't cause such long execution
> time, just because balance and qgroup will at most call find_parent_nodes()
> on the same *EXTENT* twice.
>
> However for old fiemap, or current send, they call find_parent_nodes() on
> every *FILE* *EXTENT*, which points to the same *EXTENT*.
>
> And according to my ftrace, for one extent shared by 4096 times, it will
> takes about 1.6sec to execute find_parent_nodes().
>
> So for balance and qgroup, extra 3.2 seconds won't be a big problem.
> (Although mix balance and qgroup is another problem)
>
> But for fiemap or send, it will be 4096 * 1.6 = 6553 secs, definitely not
> the right thing.
>
>>
>> Disabling this code makes the problem go away for the scenario of the
>> same file pointing to the same extent thousands of times (or tens or
>> hundreds of thousands, whatever).
>> But what happens if a file points to an extent once but the extent is
>> referenced by other 100k files (possibly in different snapshots or
>> subvolumes), isn't it the same problem?
>
>
> No, not the same problem.
> In that case, the extent will only be iterated once, just 1.6sec.

And you have many different extents for which it takes 1.6 seconds,
the problem ends up being the same - long execution time.
What I'm trying to tell you is that, with shared extents, you can get
into long execution times in many different ways. Be it with
the same file pointing to the same extent thousands of time or
pointing to a lot of different extents that happen to be shared with
many other files/snapshots.

>
> Nothing will be wrong at all.
>
> The only wrong thing is, send lacks the method to avoid calling
> find_parent_nodes() again and again on the same extent.
>
> And yes, we can fix it in backref code, but now send is the only caller
> which may call find_parent_nodes() on the same extent again and again.
>
> Qgroup has been changed from call find_parent_nodes() every time to only
> call it twice.
> Balance itself is already extent based, nothing to do with the bug.
> And fiemap adds early quit.
>
> Only send is left here.
>
>> The backref code has to find
>> all such inodes/offsets/roots and take again the same long time...
>>
>> Following your logic, it seems like everything that uses the backref
>> walking code should be disabled.
>
> Just check my previous statement.
>
> It's not about execution time of find_parent_nodes() and its variants, but
> the caller behavior.
>
> If caller only call find_parent_nodes() once for one extent, it's just less
> than 2 seconds.(almost linear growth with the number of reference)
>
> While caller call find_parent_nodes() on every file extent it finds, then
> there is the problem. (squared to cubic growth)

Even if those extent items point to different extents that are shared
between many files/snapshots.

>
>
> And, I know this is a quite bad idea to disable clone detection, so I send
> this patch as RFC.
> Just to raise the concern of any find_paren_nodes() caller, and to find a
> good method to fix the bug.
>
> Thanks,
> Qu
>
>>
>>>
>>> Cc: Filipe Manana <fdmanana@gmail.com>
>>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/send.c | 22 ++++++++++++++++++++--
>>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>> index 2db8dc8..eed3f1c 100644
>>> --- a/fs/btrfs/send.c
>>> +++ b/fs/btrfs/send.c
>>> @@ -1166,6 +1166,7 @@ struct backref_ctx {
>>>         int found_itself;
>>>  };
>>>
>>> +#if 0
>>>  static int __clone_root_cmp_bsearch(const void *key, const void *elt)
>>>  {
>>>         u64 root = (u64)(uintptr_t)key;
>>> @@ -1177,6 +1178,7 @@ static int __clone_root_cmp_bsearch(const void
>>> *key, const void *elt)
>>>                 return 1;
>>>         return 0;
>>>  }
>>> +#endif
>>>
>>>  static int __clone_root_cmp_sort(const void *e1, const void *e2)
>>>  {
>>> @@ -1190,6 +1192,7 @@ static int __clone_root_cmp_sort(const void *e1,
>>> const void *e2)
>>>         return 0;
>>>  }
>>>
>>> +#if 0
>>>  /*
>>>   * Called for every backref that is found for the current extent.
>>>   * Results are collected in sctx->clone_roots->ino/offset/found_refs
>>> @@ -1445,6 +1448,7 @@ out:
>>>         kfree(backref_ctx);
>>>         return ret;
>>>  }
>>> +#endif
>>>
>>>  static int read_symlink(struct btrfs_root *root,
>>>                         u64 ino,
>>> @@ -5291,7 +5295,6 @@ static int process_extent(struct send_ctx *sctx,
>>>                           struct btrfs_path *path,
>>>                           struct btrfs_key *key)
>>>  {
>>> -       struct clone_root *found_clone = NULL;
>>>         int ret = 0;
>>>
>>>         if (S_ISLNK(sctx->cur_inode_mode))
>>> @@ -5333,12 +5336,27 @@ static int process_extent(struct send_ctx *sctx,
>>>                 }
>>>         }
>>>
>>> +       /*
>>> +        * Current clone detection is both time and memory consuming.
>>> +        *
>>> +        * Time consuming is caused by iterating all backref of extent.
>>> +        * Memory consuming is caused by allocating "found_clone" every
>>> +        * time for a backref.
>>> +        *
>>> +        * XXX: Disabling it is never the best method, but at least it
>>> +        * won't cause OOM nor super long execution time.
>>> +        * The root fix needs to change the iteration basis, from
>>> iterating
>>> +        * file extents to iterating extents, so find_parent_nodes() and
>>> +        * backref walk should be called only once for one extent.
>>> +        */
>>> +#if 0
>>>         ret = find_extent_clone(sctx, path, key->objectid, key->offset,
>>>                         sctx->cur_inode_size, &found_clone);
>>>         if (ret != -ENOENT && ret < 0)
>>>                 goto out;
>>> +#endif
>>>
>>> -       ret = send_write_or_clone(sctx, path, key, found_clone);
>>> +       ret = send_write_or_clone(sctx, path, key, NULL);
>>>         if (ret)
>>>                 goto out;
>>>  out_hole:
>>> --
>>> 2.9.0
>>>
>>>
>>>
>>
>>
>>
>
>



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
