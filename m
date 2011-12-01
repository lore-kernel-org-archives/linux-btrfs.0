From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 07/99] btrfs: Use mempools for extent_state structures
Date: Thu, 01 Dec 2011 14:55:11 -0500
Message-ID: <4ED7DB9F.4030502@suse.de>
References: <20111124003533.395674389@suse.com> <20111124004220.628076319@suse.com> <m27h2j6byr.fsf@firstfloor.org> <4ED42171.6090704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Mahoney <jeffm@suse.com>,
	Btrfs List <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED42171.6090704@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/28/2011 07:04 PM, Jeff Mahoney wrote:
> On 11/28/2011 06:53 PM, Andi Kleen wrote:
>> Jeff Mahoney <jeffm@suse.com> writes:
> 
>>> The extent_state structure is used at the core of the extent
>>> i/o code for managing flags, locking, etc. It requires
>>> allocations deep in the write code and if failures occur they
>>> are difficult to recover from.
>>> 
>>> We avoid most of the failures by using a mempool, which can
>>> sleep when required, to honor the allocations. This allows
>>> future patches to convert most of the
>>> {set,clear,convert}_extent_bit and derivatives to return void.
> 
>> Is this really safe?
> 
>> iirc if there's any operation that needs multiple mempool
>> objects you can get into the following ABBA style deadlock:
> 
>> thread 1                     thread 2
> 
>> get object A from pool 1 get object C from pool 2 get object B
>> from pool 2 pool 2 full -> block get object D from pool 2
> ^ pool1, i assume
>> pool1 full -> block
> 
> 
>> Now for thread 1 to make progress it needs thread 2 to free its 
>> object first, but that needs thread 1 to free its object also 
>> first, which is a deadlock.
> 
>> It would still work if there are other users which eventually
>> make progress, but if you're really unlucky either pool 1 or 2
>> is complete used by threads doing a multiple object operation. So
>> you got a nasty rare deadlock ...
> 
> Yes, I think you're right. I think the risk is probably there and
> I'm not sure it can be totally mitigated. We'd be stuck if there is
> a string of pathological cases and both mempool are empty. The only
> way I can see to try to help the situation is to make the mempool
> fairly substantial, which is what I did here. I'd prefer to make
> the mempools per-fs but that would require pretty heavy
> modifications in order to pass around a per-fs struct. In any case,
> the risk isn't totally eliminated.

The more I look into it, the more I don't think this is an uncommon
scenario in the kernel. Device mapper draws from a number of mempools
that can be interspersed with allocations from the bio pool. Even
without stacking different types of dm devices, I think we can run
into this scenario. The DM scenario is probably even worse since the
allocs are GFP_NOIO instead of the (relatively) more relaxed GFP_NOFS.

I'm not saying it's ok, just that there are similar sites already that
seem to be easier to hit but we haven't heard of issues there either.
It seems to be a behavior that is largely mitigated by establishing
mempools of sufficient size.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO19ueAAoJEB57S2MheeWyDb4QAKZ3T9JGTXZN9MikO0Q8aH08
KE0X4NSnagn/goS/88+6Hj9Z165gQ3ERUaoW4+VsdpLOAaJuNo4YtMShoN7pgC9X
HeaddX1cQb8aducWPt9o7sglkpERJHzdSNKO4rJaYQbJLZFBQ1KLQEISRjS1ZAiu
74Y/t3tESiJO8W5XV1b06pythUKG4sLPK8+ssBvpYt+qrfhfp//dse/sKPE3L1k5
zHP0GIePRazhkE9RUB8+5rjItUR7MSvECJviCKKhxyY/TsQRm4g27AhbL717Ew/9
V3LyyZe5ojhXWNDyaCeLUu4j/xOcYVftkxuQLHcVltTDaAzxCkaRBnzxoz5nouc+
SusUzVYy/aR14QyNbtFpfJVAB3E9djXsaA3EZO2ar+NPeBch28LEJRfC8hoItej3
O39PAFpviYRSHa12GDIqJ0x3q9auTeU5DRPt3gnpstT26t4vICkFn4B/cp9EzpQI
G1Gm09ftkehpSdBiFFSBXCpPg/7qTAMPnaF1Yq3ueQoWbAqVEtnPnaWQLfH4IBBj
5fp6ei0/zAS2qr1iBKZnWUKJKCIAyvCkEeLusTcLymFzLzVMpywYWchU+EW0AZ5G
98tx8Dgzi77ImHG4uF9uWuNJ80G7iR+nGgE+8dKIoEKLETHdoQMRgTCc05o9tTHM
Gk0GUwRESn97r/ytUm8n
=zdAv
-----END PGP SIGNATURE-----
