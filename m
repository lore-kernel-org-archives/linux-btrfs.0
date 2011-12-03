From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 07/99] btrfs: Use mempools for extent_state structures
Date: Fri, 02 Dec 2011 23:53:24 -0500
Message-ID: <4ED9AB44.60600@suse.de>
References: <20111124003533.395674389@suse.com> <20111124004220.628076319@suse.com> <m27h2j6byr.fsf@firstfloor.org> <4ED42171.6090704@suse.de> <4ED7DB9F.4030502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED7DB9F.4030502@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/01/2011 02:55 PM, Jeff Mahoney wrote:
> On 11/28/2011 07:04 PM, Jeff Mahoney wrote:
>> On 11/28/2011 06:53 PM, Andi Kleen wrote:
>>> Jeff Mahoney <jeffm@suse.com> writes:
> 
>>>> The extent_state structure is used at the core of the extent 
>>>> i/o code for managing flags, locking, etc. It requires 
>>>> allocations deep in the write code and if failures occur
>>>> they are difficult to recover from.
>>>> 
>>>> We avoid most of the failures by using a mempool, which can 
>>>> sleep when required, to honor the allocations. This allows 
>>>> future patches to convert most of the 
>>>> {set,clear,convert}_extent_bit and derivatives to return
>>>> void.
> 
>>> Is this really safe?
> 
>>> iirc if there's any operation that needs multiple mempool 
>>> objects you can get into the following ABBA style deadlock:
> 
>>> thread 1                     thread 2
> 
>>> get object A from pool 1 get object C from pool 2 get object B 
>>> from pool 2 pool 2 full -> block get object D from pool 2
>> ^ pool1, i assume
>>> pool1 full -> block
> 
> 
>>> Now for thread 1 to make progress it needs thread 2 to free its
>>>  object first, but that needs thread 1 to free its object also
>>>  first, which is a deadlock.
> 
>>> It would still work if there are other users which eventually 
>>> make progress, but if you're really unlucky either pool 1 or 2 
>>> is complete used by threads doing a multiple object operation.
>>> So you got a nasty rare deadlock ...
> 
>> Yes, I think you're right. I think the risk is probably there
>> and I'm not sure it can be totally mitigated. We'd be stuck if
>> there is a string of pathological cases and both mempool are
>> empty. The only way I can see to try to help the situation is to
>> make the mempool fairly substantial, which is what I did here.
>> I'd prefer to make the mempools per-fs but that would require
>> pretty heavy modifications in order to pass around a per-fs
>> struct. In any case, the risk isn't totally eliminated.
> 
> The more I look into it, the more I don't think this is an
> uncommon scenario in the kernel. Device mapper draws from a number
> of mempools that can be interspersed with allocations from the bio
> pool. Even without stacking different types of dm devices, I think
> we can run into this scenario. The DM scenario is probably even
> worse since the allocs are GFP_NOIO instead of the (relatively)
> more relaxed GFP_NOFS.
> 
> I'm not saying it's ok, just that there are similar sites already
> that seem to be easier to hit but we haven't heard of issues there
> either. It seems to be a behavior that is largely mitigated by
> establishing mempools of sufficient size.

... and the next installment:

My understanding of mempools is inaccurate and the pathological case
can be hit much more quickly than I anticipated, or at least have a
performance impact I'd rather not see. It turns out that the pool will
be depleted *before* the other pathological cases are hit. In fact,
the pool is hit before reclaim starts at all.

Rather than:

normal alloc with gfp_t
(normal alloc fails after trying reclaim)
pool alloc
(pool alloc fails)
(wait, timeout, retry)

it is:
normal alloc with gfp_t & ~(__GFP_WAIT|__GFP_IO)
(which is GFP_NOFS & ~GFP_NOFS for the common case)

.. so:

normal alloc with GFP_NOWAIT
(normal alloc fails) (much more often)
pool alloc
(pool alloc fails)
((wait until an object is freed or timeout) and retry with GFP_NOFS)

So, using mempools for all cases as I'd hoped isn't what I want. I'll
work up another set of patches that use a straight kmem_cache_alloc
where possible. The good news is that slab-backed mempools can be
replenished with objects from the slab that weren't allocated from the
pool. So there's that.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO2atEAAoJEB57S2MheeWy2CYP/iix4znJVqBkN8wUg31MELGB
UpodfZkwlhrD/8PfJrisjA1wLLKpK5GzJ0m6rhKCYvkBau28yCSAWGW9sJIfGM0I
4fLAoupncoJqmYyQvrZIczxztDVwMu37bL7fNfCkC64HoaETChQbaDbrwu+L8Rn2
Lls7EtkUNWrpY+J4F0zq9b8eE46WjbpZBKhI/PuqAE0LfSXK8nd46Z5qA/MM7fab
tFftC0AyBLP2dq8R0H1IX0yjri6YD0xwwfdHdbzVAoJ/tINVbfiQxntYyONgNnBF
6sNogCtcskpTSDHZyVK7ATuJJL6ZAIFO0ZUJjZYFc+q0q1oYMfmbhNs9Qq5le7bZ
Ig6pcMgHqGOqkis95jqzgStl2A1OIYPZsn6K1329N44fvZ8PjxDVCHS83FzBY0qw
YuEgBNd8vRrdjtcMax2QOs9yaSmvEXDkws1+tLWg/ZV0Ik8crbW0ctVqsyDpWwPN
2dSyrlxGbAJyXzELUg498dLORw+chHokUhsEvwYEmL1HGLsZGFoXAV3H5df4v6Mx
wsKZeT+Nsp16CyYOXVCAWGRyp6FPDWECJAUxygjyEaIGWmiJjMKU1GizL9J4fgc+
59fantrAMbFwPpRwJxfHumCdnQOi55qtrcP1UvCB3o9jBH4QsUofP4sGQsIAw4oQ
ctuvtI1R7zcub0906BwP
=h+a2
-----END PGP SIGNATURE-----
