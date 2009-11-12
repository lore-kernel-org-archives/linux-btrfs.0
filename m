From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: Re: BUG? a possible race due to the absence of memory barrier
Date: Thu, 12 Nov 2009 10:14:48 +0900
Message-ID: <2014bcab0911111714m7cbc3909r9af0e7117ed08749@mail.gmail.com>
References: <2014bcab0911110707i3f2e8782i772603a9b899e353@mail.gmail.com>
	 <20091111160643.GF5566@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	=?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091111160643.GF5566@think>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the review.

I did not notice that lock_chunks() is a locking function.

I am using my own static analysis for finding bugs.
As I register lock_chunks() as a locking functions,
the bug alarm is disappeared.

On Thu, Nov 12, 2009 at 1:06 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Thu, Nov 12, 2009 at 12:07:05AM +0900, =ED=99=8D=EC=8B=A0 shin hon=
g wrote:
>> Hello. I am reporting possible data race
>> due to the the absence of memory barriers.
>>
>> I reported a similar issue. Although the previous one turns out to b=
e safe,
>> please examine this issue and let me know your opinion.
>>
>> In btrfs_init_new_device(), a btrfs_device object is allocated and i=
nitialized
>> and then links to &root->fs_info->fs_devcies->alloc_list.
>>
>> It seems that a memory barrier is necessary
>> between the initialization and the linking to the list.
>>
>> If these two operations are re-ordered so that executed opposite ord=
ers,
>> it may result data race where uninitialized values are read by other=
 threads.
>>
>> For btrfs_init_new_device(), i think __btfs_alloc_chunk() is a suspe=
cted
>> to be possible to contribute data race by concurrent execution.
>
> Thanks for searching for races in this code, it definitely has a lot =
of
> locks to go through.
>
> In this case, btrfs_init_new_device has the chunk mutex held (from
> lock_chunks), and __btrfs_alloc_chunk should always be called by with
> the chunk mutex held as well.
>
> In general the btrfs locking tries not to rely on barriers and orderi=
ng
> unless a given area of the code is very performance sensitive. =C2=A0=
It's
> very easy for subtle bugs to creep in with barriers only, so I try to
> use mutexes and spinlocks everywhere that I can get away with it.
>
> -chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
