From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v0 03/18] btrfs: add nested locking mode for paths
Date: Fri, 07 Oct 2011 10:39:25 +0200
Message-ID: <4E8EBABD.1050501@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>	<55d5758142bf964aefbbaadc2188f66ca178f876.1317915010.git.sensille@gmx.net>	<m2ty7l3lji.fsf@firstfloor.org>	<CANvN+ems8D+wB_YPzoNpsqxZ8on-z7xCEXQuQ0LgoF_T=gw+Yw@mail.gmail.com>	<CANvN+emRvTQD-epGJrELs_WAF06zuuBb0ELpSFrGazzAbo29gg@mail.gmail.com>	<20111006205045.GU14482@one.firstfloor.org> <CANvN+e=GtjwG9+G1BggsbQOwe+iP4DzqQUvjDP=rw_+FuPZM7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANvN+e=GtjwG9+G1BggsbQOwe+iP4DzqQUvjDP=rw_+FuPZM7w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.10.2011 22:54, Andrey Kuzmin wrote:
> 
> 
> On Friday, October 7, 2011, Andi Kleen <andi@firstfloor.org
> <mailto:andi@firstfloor.org>> wrote:
>> On Fri, Oct 07, 2011 at 12:44:30AM +0400, Andrey Kuzmin wrote:
>>> Perhaps you could just elaborate on "needs this feature"? In general, write
>>> lock gives one exclusive access, so the need for additional read
>>> (non-exclusive) lock does not appear easily understandable.
>>
>> Usually it's because the low level code can be called both with and
>> without locking and it doesn't know.
>>
>> But that usually can be avoided with some restructuring.
> Exactly.

One premise was to change the existing paths as little as possible to
make it easier for Chris to judge the impact when qgroups are turned
off. For this I hook into the generic "add a backref" path, which is
called from diverse places all around the code. Some of these places
already hold a lock on the fs tree I'm going to read, others don't,
but in any case it is ok to just go ahead and read it.
I think by restructuring you mean serializing both operations and only
calling into my code after the previous operation is done. But that
would on one hand mean queuing up all that needs to be done afterwards,
and on the other hand at least keeping a read lock on all these extents,
as no changes are allowed in between.
This restructuring would be a major operation, but maybe I'm just not
seeing the obvious way to go. Maybe Chris has a good idea...

All my code is now doing is when it encounters a write lock, check if the
upper layers are holding it and allowing read access if that's the case.
Only one additional reader is allowed. This is not full recursive locking,
but at least part of it.

-Arne

>>
>> -Andi
>>
> 
> -- 
> Sent from Gmail Mobile

