From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 07/99] btrfs: Use mempools for extent_state structures
Date: Mon, 28 Nov 2011 19:04:01 -0500
Message-ID: <4ED42171.6090704@suse.de>
References: <20111124003533.395674389@suse.com> <20111124004220.628076319@suse.com> <m27h2j6byr.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Mahoney <jeffm@suse.com>,
	Btrfs List <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m27h2j6byr.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/28/2011 06:53 PM, Andi Kleen wrote:
> Jeff Mahoney <jeffm@suse.com> writes:
> 
>> The extent_state structure is used at the core of the extent i/o
>> code for managing flags, locking, etc. It requires allocations
>> deep in the write code and if failures occur they are difficult
>> to recover from.
>> 
>> We avoid most of the failures by using a mempool, which can sleep
>> when required, to honor the allocations. This allows future
>> patches to convert most of the {set,clear,convert}_extent_bit and
>> derivatives to return void.
> 
> Is this really safe?
> 
> iirc if there's any operation that needs multiple mempool objects
> you can get into the following ABBA style deadlock:
> 
> thread 1                     thread 2
> 
> get object A from pool 1 get object C from pool 2 get object B from
> pool 2 pool 2 full -> block get object D from pool 2
					^ pool1, i assume
> pool1 full -> block
> 
> 
> Now for thread 1 to make progress it needs thread 2 to free its 
> object first, but that needs thread 1 to free its object also 
> first, which is a deadlock.
> 
> It would still work if there are other users which eventually make
> progress, but if you're really unlucky either pool 1 or 2 is
> complete used by threads doing a multiple object operation. So you
> got a nasty rare deadlock ...

Yes, I think you're right. I think the risk is probably there and I'm
not sure it can be totally mitigated. We'd be stuck if there is a
string of pathological cases and both mempool are empty. The only way
I can see to try to help the situation is to make the mempool fairly
substantial, which is what I did here. I'd prefer to make the mempools
per-fs but that would require pretty heavy modifications in order to
pass around a per-fs struct. In any case, the risk isn't totally
eliminated.

> The only way to handle this would be to always preallocate all
> objects needed for a operation in an atomic way.

This was how I wanted to do it at first but I couldn't see a way to
make it work in a manner that wouldn't kill performance since the
calculations effectively need to be done twice and are pretty common.
The other issue is that operations can be pretty complex and
preallocating for all cases will either be really wasteful or really
error prone.

> Or never use more than one object.

I need to do some analysis here to see if that is even possible.

- -Jeff


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIbBAEBAgAGBQJO1CFxAAoJEB57S2MheeWyL1EP+Pd+c1hodWEA6StTnE1pG+Tl
u5Rg+VBmN8AdcfdOzvyoyfZgPaCxtHzaJVX2y3PzHtY1INEMp2EoijaL1X9afKQF
lJP1BmpIARARMrQrYbqvZrl+DGUeIwIhC2LBuNffYifbMAn3KdTLRhkvcGehTmQO
Vik1bgmo6ZKjAIP/FLViGdB4hITITwHtT7n4bDyZ9ATgqgq5sGUWnw7f0sILeBqR
NOt8QVgaCmzZIF5foUr2UsBBxjo0joiW2V7YWs4roJeCtDx+6mwyRifQFTGuN2xi
1CVTnTT+FYXkD8IB6mKNHptIDLu7q29RaikSFsgV684IYAp510OBStgBuCpBeeNc
Xd77XJkf9UCYSXWs1j587MnOqaeV818OqvwxHAGZnavBHZ/+8AFOJ77GAVaP1Xlm
M6gYP1TXjL0yjJEWNVtP0kBjimKUFw5ECv86DCQllRTY/5oWmAxjyJviEzVgJBiM
EDtzf17APyiTSWawRZlDc6a46kG2Jm6QiNmx4MyAlSFu81Qv0EDOpC4TAwiRDZKa
KLjaW10TKcC5TDwZXcOBiF/PrpvBCvJjd0N3sCFVD0Tn0cdqME9BuFUP1hI1ku+T
L5VyzHsp07ndCk+H6gGWkCZzEtSSyWFG4gHkFcV7z/IF5bPpsyxcxdGXGzBGbYUh
9NdrCz5lMb49VTBBSaY=
=ZXGi
-----END PGP SIGNATURE-----
