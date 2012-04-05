From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: [PATCH] btrfs/extent_io.c: return -ENOMEM instead of BUG_ON on
 allocation failure in set_extent_bit if __GFP_WAIT is set in the mask
Date: Thu, 05 Apr 2012 10:10:20 +0800
Message-ID: <4F7CFF0C.7020300@gmail.com>
References: <4F76B15D.9010801@gmail.com> <4F7C4CC8.7060007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F7C4CC8.7060007@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 2012=E5=B9=B404=E6=9C=8804=E6=97=A5 21:29, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On 03/31/2012 03:25 AM, Wang Sheng-Hui wrote:
>> If __GFP_WAIT is set in the mask, set_extent_bit should return=20
>> -ENOMEM to its caller to decide what to do on allocation failure,=20
>> instead of BUG_ON.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com> ---=20
>> fs/btrfs/extent_io.c |    3 ++- 1 files changed, 2 insertions(+), 1
>> deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c index
>> b67814c..fd2411e 100644 --- a/fs/btrfs/extent_io.c +++
>> b/fs/btrfs/extent_io.c @@ -720,7 +720,8 @@ int
>> set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,=20
>> again: if (!prealloc && (mask & __GFP_WAIT)) { prealloc =3D
>> alloc_extent_state(mask); -		BUG_ON(!prealloc); +		if (!prealloc) +
>> return -ENOMEM; }
>>
>> spin_lock(&tree->lock);
>=20
> Hi Sheng-Hui -
>=20
> Do you have a follow-on series to this? With the exception of the
> set_extent_dirty call in end_bio_extent_readpage, every set_extent_bi=
t
> caller uses GFP_NOFS, which includes __GFP_WAIT. If we return a
> failure here, we need to catch the failure in the call sites.
> Otherwise, the failure will just be ignored and we'll end up with an
> inconsistent extent state tree.
>=20
> - -Jeff
>=20

Hi Jeff,

I'll review the code and provide a list of patches later.
Currently we can skip it, I think.

Thanks,
Sheng-Hui

> - --=20
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>=20
> iQIcBAEBAgAGBQJPfEzIAAoJEB57S2MheeWyqcoP/RagYePToMYOdgjjxVz2cwkf
> BLT5B0KWWaJa0KtEOpgQATmldmA4CCq6WmC7R/Omy1q9RD75rheKxaxuQY35NTFe
> czBSfVr3VeMy1A6dIK+wHOiAfheuT90xSgXJJMpdkjHmNjEA1g2nupAFltUE/L70
> +xFxotBuoYuTe8u++QES0JGqnw8YI6FW0z3Z4buyoqRhgiX7TukNfXXgx4c2HI0/
> cOkxyvYpDi2WF9EtESn/ekwf4Rjx9kNUX/9owmDWYgHD4MLjwSQsRbwZ7BrZEM3k
> aBe8yZGpgr3UuL9nGiPbWHsyBeAskvXaL6Y2YIczJSvsoP/DM+9SsHAwnqkVaBHv
> 8qQiQqUhF1mrdl3GBSvKJarGczrSmbWZ5X94oYq4MCKyi3SeTN/bcJS+p5EV1Tvs
> LMRqqj26leHnl+bYKGWIfJqQRuYcfbkzTOADbn54iMYj2aG2raUjI9D53TUIInuV
> Csm2hhKJn+HDwu2+gZX1F99W0ehs1ps86oGfkT4WA/H7fTmugiEYxsM1Dk71Ti7/
> eadns62DYFZyzKk4/jP/8Rjygc4YM/T2F9qb+SX3hWGhIIZiz5qOxjgBZy91i+84
> W+DDUHjZPU+O14nNlKFA3INGS9823ENklRkzpNUhLx7ffrCLOAS73O2rzHcaSmtk
> FSDWO4EqxIAi4t3LoL14
> =3DPxwh
> -----END PGP SIGNATURE-----
