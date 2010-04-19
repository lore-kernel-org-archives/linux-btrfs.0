From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH 02/12] Btrfs: Kill allocate_wait in space_info
Date: Mon, 19 Apr 2010 23:34:25 +0800
Message-ID: <n2v3d0408631004190834q731a489didb8ff2e4d43a18e2@mail.gmail.com>
References: <4BCC3458.5030600@oracle.com>
	 <20100419135713.GA2352@localhost.localdomain>
	 <s2o3d0408631004190746wcc55e7bdp572e9cce8a36fcd6@mail.gmail.com>
	 <20100419144843.GC2352@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100419144843.GC2352@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 19, 2010 at 10:48 PM, Josef Bacik <josef@redhat.com> wrote:
> On Mon, Apr 19, 2010 at 10:46:12PM +0800, Yan, Zheng wrote:
>> On Mon, Apr 19, 2010 at 9:57 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > The purpose of maybe_allocate_chunk was that there is no way to kn=
ow if some
>> > other CPU is currently trying to allocate a chunk for the given sp=
ace info. =A0We
>> > could have two cpu's come inot do_chunk_alloc at relatively the sa=
me time and
>> > end up allocating twice the amount of space, which is why I did th=
e waitqueue
>> > thing. =A0It seems like this is still a possibility with your patc=
h. =A0Thanks,
>> >
>> This is impossible because the very first thing do_chunk_alloc does =
is
>> lock the chunk_mutex.
>>
>
> Sure, that just means we don't get two things creating chunks at the =
same time,
> but not from creating them one right after another. =A0So CPU 0 and 1=
 come in to
> the check free space stuff, realize they need to allocate a chunk, an=
d race to
> call do_chunk_alloc. =A0One of them wins, and the other blocks on the=
 chunk_mutex
> lock. =A0When the first finishes the other one is able to continue an=
d do what it
> was originally going to do, and then you get two chunks when you real=
ly only
> wanted one. =A0Thanks,
>

there is a check in do_chunk_alloc, so the later one will do nothing
if the first
call adds enough space.

Yan Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
