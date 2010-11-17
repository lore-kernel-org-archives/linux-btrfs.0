From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: Update to Project_ideas wiki page
Date: Wed, 17 Nov 2010 19:14:47 +0100
Message-ID: <4CE41B97.4070606@gmail.com>
References: <m3hbfg3acu.fsf@pullcord.laptop.org> <20101117143103.GA2401@selene> <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com> <20101117175657.GB2401@selene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Bart Noordervliet <bart@noordervliet.net>,
	Chris Ball <cjb@laptop.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101117175657.GB2401@selene>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 17.11.2010 18:56, Hugo Mills wrote:
> On Wed, Nov 17, 2010 at 04:12:29PM +0100, Bart Noordervliet wrote:
>> Can I suggest we combine this new RAID level management with a
>> modernisation of the terminology for storage redundancy, as has been
>> discussed previously in the "Raid1 with 3 drives" thread of March this
>> year? I.e. abandon the burdened raid* terminology in favour of
>> something that makes more sense for a filesystem.
>
> Well, our current RAID modes are:
>
> * 1 Copy ("SINGLE")
> * 2 Copies ("DUP")
> * 2 Copies, different spindles ("RAID1")
> * 1 Copy, 2 Stripes ("RAID0")
> * 2 Copies, 2 Stripes [each] ("RAID10")
>
> The forthcoming RAID5/6 code will expand on that, with
>
> * 1 Copy, n Stripes + 1 Parity ("RAID5")
> * 1 Copy, n Stripes + 2 Parity ("RAID6")
>
> (I'm not certain how "n" will be selected -- it could be a config
> option, or simply selected on the basis of the number of
> spindles/devices currently in the FS).
Just one question on "small n": If one has N = 3*k >= 6 spindles, then
RAID5 with n = N/2-1 results in something like RAID50? So having an
option for "small n" might realize RAID50 given the right choice for n.
>
> We could further postulate a RAID50/RAID60 mode, which would be
>
> * 2 Copies, n Stripes + 1 Parity
> * 2 Copies, n Stripes + 2 Parity
Isn't this RAID51/RAID61 (or 15/16 unsure on how to put) and would
RAID50/RAID60 correspond to

* 2 Stripes, n Stripes + 1 Parity
* 2 Stripes, n Stripes + 2 Parity
>
> For brevity, we could collapse these names down to: 1C, 2C, 2CR,
> 1C2S, 2C2S, 1CnS1P, 1CnS2P, 2CnS1P, 2CnS2P. However, that's probably a
> bit too condensed for useful readability. I'd support some set of
> terms based on this taxonomy, though, as it's fairly extensible, and
> tells you the details of the duplication strategy in question.
>
>> Mostly this would involve a discussion about what terms would make
>> most sense, though some changes in the behaviour of btrfs redundancy
>> modes may be warranted if they make things more intuitive.
>
> Consider the above a first suggestion. :)
>
>> I could help you make these changes in your patches, or write my own
>> patches against yours, though I'm also completely new to kernel
>> development.
>
> Probably best to keep the kernel internals unchanged for this
> particular issue, as they don't make much difference to the naming,
> but patches to the userspace side of things (mkfs.btrfs and btrfs fi
> df specifically) should be fairly straightforward.
>
> Hugo.
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJM5BuWAAoJEJIcBJ3+XkgiJVkP/i1YrexX3lxH6A02IWHfRIP/
+8qIDLfw5l6wuX0UV3B/ROngsI2HHvWmybFR5+rrcAkntG/EJn0amhYMrKZMDh7n
WrpWuBWjBiLI6tAkiE/ur9D3AGQhBW69okeGq2MCGYSIZNVUjVfWtEmF/OKj8soz
1Wk6Ymk0aNYBme7FMZwM/fRQnoRoV3qk5IrztzaZTClmcpM6ut+puPO42r5IEqmV
d441f7ta6vXfmXCaBA5otAdMsa3yQedkUd+wAS4xPZgN+CopeuSUUFeD4FH3b1wX
pyA9WtS8bb10cdnf0YOkbUVTgWhmsPzABqhZlmcA/8xMCMCx7Fg6eKAjGaBTcnP0
+rxWRmoyLRRS015IDat4bb31yeA8GQxteOOhpF9gLd9I0bF8QYTBSGOG9dVadEJU
PJ1aCA+5rePwadOh4wp6V0vH6BRCs7JcDc12K/gfCCFoHTyfk23j73+jJ2/dzH/E
aTDrprQIWdJE5Fk33XA1oLIcT2xNj/6PKv8DKTTj8n4SxfhViQkrNu1RrzVd5Ln1
BYbVnUbcDuAUR7AAFqRaMBVMIULJgvkaqeaQohFfONei4CgTm+A14ONcN/c0I3fV
ef9hBG2YV9X82yozLvZ0888q+eCb86AnOaVxWtnHNgvPKxnOu8Iu7NhSO53yYaro
i8aAoui00NJueGGKXzLt
=Wj4a
-----END PGP SIGNATURE-----

