Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3H0TX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 15:23:27 -0400
Message-ID: <521CFCA5.6000007@suse.com>
Date: Tue, 27 Aug 2013 15:23:17 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <20130826215326.GH26818@lenny.home.zabbo.net> <20130827134736.GJ29654@localhost.localdomain>
In-Reply-To: <20130827134736.GJ29654@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HflB52OQB1ufH2gcWKIASuxNcwtqKHvW1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HflB52OQB1ufH2gcWKIASuxNcwtqKHvW1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/27/13 9:47 AM, Josef Bacik wrote:
> On Mon, Aug 26, 2013 at 02:53:26PM -0700, Zach Brown wrote:
>>> With this we can
>>> go through and convert any BUG_ON()'s that we have to catch actual pr=
ogramming
>>> mistakes to the new ASSERT() and then fix everybody else to return er=
rors.
>>
>> I like the sound of that!
>>
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -3814,6 +3814,22 @@ void btrfs_printk(const struct btrfs_fs_info *=
fs_info, const char *fmt, ...)
>>>  #define btrfs_debug(fs_info, fmt, args...) \
>>>  	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
>>> =20
>>> +#ifdef BTRFS_ASSERT
>>> +
>>> +static inline void assfail(char *expr, char *file, int lin)
>>> +{
>>> +	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
>>> +	       expr, file, line);
>>> +	BUG();
>>> +}
>>
>> I'm not sure why this is needed.
>>
>>> +#define ASSERT(expr)	\
>>> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>>
>> (Passing the assertion is unlikely()?  I know, this is from xfs...
>> still.)
>>
>=20
> Yeah I copy+pasted and then thought about it after I sent it.  I will f=
ix it up.
> =20
>>> +#else
>>> +#define ASSERT(expr)	((void)0)
>>> +#endif
>>
>> Anyway, if you're going to do it this way, why not:
>>
>> 	#ifdef BTRFS_ASSERT
>> 	#define btrfs_assert(cond)  BUG_ON(!(cond))
>> 	#else
>> 	#define btrfs_assert(cond)  do { if (cond) ; } while (0)
>> 	#endif
>>
>=20
> I like the verbosity, especially with random kernel versions and such, =
it will
> help me figure out where we BUG_ON()'ed without having to checkout a pa=
rticular
> version and go hunting.  Thanks,

Agreed. One of the positives of the obnoxious reiserfs warning IDs is
that it uniquely identifies a call site across kernel versions. You can
tell at a glance that it's the same failure you may have been chasing
for a while. Anything to make the ID-at-a-glance easy is worth it.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--HflB52OQB1ufH2gcWKIASuxNcwtqKHvW1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSHPyoAAoJEB57S2MheeWy1A4P/2mwMX98SMLfMaNPXSn5DWlw
uDvGrTcuN72zsr6x2Umew9tZGZviPyvetV02NtnU3jFKsJqfHKlofYBohDdmbTuX
3NdAbtQqQkbJBHujqWWhrT5qsPq1NT+f70Roq/2kTatrD2rhYWvvfrX9CimIIjwY
9TCGvrjMvVnn13KjYkP1zY+3cuDGgjivaMN5R8mVyKjPTpBsxZv1aHjMhh9BJjWU
YleFlnErVUx/pN6KZlcYC4qBJkZdr1Gu6rNBX8iyqa+hU9IYWcXq3AGn6irBCsnX
jB5pWzkOcoycCQWVsTK/EnayGnMBC+mZPwpNlk3HI8l6VUyP8XLbYADg+8vk7GEo
wjEPhCIPnC6+NjejEb6PZpOLsGsjKeQSLe1/m7ZgRm+pxaUGBpaFbx12X5PhMtqn
pNxRktzskARXpdWk0DLe58lqB6TkPkoTzBPnnwBWh3VxPkGCr5vbEjIGkOok6aHR
yZUAJJU+HrqBuerGNK8pHSp+v57P0QGWyJLasQnfW/MPrp3LogmqviL4QeedKs9O
jbRwKiI65eW28yHkVoaM9HUHhFhJwp2xomDwezABxAO1tVJHm4tPmMrjrdmcLNrj
fTL7QiZgSClo276M+QufkLFluyggbd+Yp8mRyCrCGg63SLfAtiIlbby5cYFpUL5s
XMut8e00VJ8WEP8H/BHo
=2lM1
-----END PGP SIGNATURE-----

--HflB52OQB1ufH2gcWKIASuxNcwtqKHvW1--
