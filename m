From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v0 07/18] btrfs: generic data structure to build unique
 lists
Date: Fri, 07 Oct 2011 10:12:18 +0200
Message-ID: <4E8EB462.7000908@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>	<3a697c3e44dd5955c167f2f548ee4ced1e3dabef.1317915010.git.sensille@gmx.net> <m2y5wx3loj.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m2y5wx3loj.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.10.2011 22:33, Andi Kleen wrote:
> Arne Jansen <sensille@gmx.net> writes:
> 
>> ulist is a generic data structures to hold a collection of unique u64
>> values. The only operations it supports is adding to the list and
>> enumerating it.
>> It is possible to store an auxiliary value along with the key.
>> The implementation is preliminary and can probably be sped up
>> significantly.
>> It is used by subvolume quota to translate recursions into iterative
>> loops.
> 
> Hmm, sounds like a job for lib/idr.c 
> 
> What do your ulists do that idr doesn't?
> Ok idr doesn't have merge, but that should be simple
> enough to add.
> 

This is indeed a part I'm not feeling particularly well about, adding a
generic data structure to btrfs instead of to the core. If I'm not the
only one feeling this data structure might be handy outside of btrfs, I
can move it, if someone points me to the right place.
Since I built it, I found many applications for it, so I have some hopes
I won't stay the only one to like it. Of course the current version is
not very optimized, though on small sets it should work well.

As to the differences to idr:
 - as David pointed out, idr works on int, while I always need u64 to
   represent btrfs logical addresses.
 - as I understand idr (though I never used it), it is designed to manage
   small consecutive integers, while ulists hold completely unrelated
   numbers, e.g. btrfs logical adresses. For small sets ulists might be
   much faster than idr
 - ulists as used here are very short lived. I don't know if idr handles
   this case well
 - the purpose of ulists is to add a specific number, and not to find a
   free one. I don't see a direct interface for this in idr.

-Arne

> -Andi

