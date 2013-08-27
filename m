Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab3H0Viy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 17:38:54 -0400
Message-ID: <521D1C64.9060205@suse.com>
Date: Tue, 27 Aug 2013 17:38:44 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <521CFDD8.6030205@suse.com> <20130827205637.GM29654@localhost.localdomain> <521D14FF.9090604@suse.com> <521D184F.5060407@redhat.com> <521D1955.8000908@suse.com> <521D19FA.4050805@redhat.com>
In-Reply-To: <521D19FA.4050805@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8wSu6IDPxE1WBg5LlvKReV1vg5rpdgQtx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8wSu6IDPxE1WBg5LlvKReV1vg5rpdgQtx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/27/13 5:28 PM, Eric Sandeen wrote:
> On 8/27/13 4:25 PM, Jeff Mahoney wrote:
>> On 8/27/13 5:21 PM, Eric Sandeen wrote:
>>> On 8/27/13 4:07 PM, Jeff Mahoney wrote:
>>>> On 8/27/13 4:56 PM, Josef Bacik wrote:
>>>>> On Tue, Aug 27, 2013 at 03:28:24PM -0400, Jeff Mahoney wrote:
>>>>>> On 8/26/13 4:56 PM, Josef Bacik wrote:
>>>>>>> One of the complaints we get a lot is how many BUG_ON()'s we have=
=2E  So to help
>>>>>>> with this I'm introducing a kconfig option to enable/disable a ne=
w ASSERT()
>>>>>>> mechanism much like what XFS does.  This will allow us developers=
 to still get
>>>>>>> our nice panics but allow users/distros to compile them out.  Wit=
h this we can
>>>>>>> go through and convert any BUG_ON()'s that we have to catch actua=
l programming
>>>>>>> mistakes to the new ASSERT() and then fix everybody else to retur=
n errors.  This
>>>>>>> will also allow developers to leave sanity checks in their new co=
de to make sure
>>>>>>> we don't trip over problems while testing stuff and vetting new f=
eatures.
>>>>>>> Thanks,
>>>>>>
>>>>>> I don't think the complaint is so much about the number of BUG_ONs=
, but
>>>>>> that there's no distinction between something that is supposed to =
be
>>>>>> impossible and something that is improbable. The BUG_ONs to keep c=
ode
>>>>>> correctness are good and are littered all over the kernel with pos=
itive
>>>>>> results. The BUG_ONs that are there in place of real error handlin=
g
>>>>>> served their purpose and need to be replaced.
>>>>>>
>>>>>> So, I don't know if it's a net win to compile the "good" BUG_ONs o=
ut of
>>>>>> the code. Especially if a user runs into something strange yet fam=
iliar
>>>>>> and the first response is "oh, huh, can you rebuild with asserts e=
nabled?"
>>>>>>
>>>>>
>>>>> Either I provide an option for it or distros do it themselves, this=
 cuts out the
>>>>> middle man.  I'd really rather they just be on all the time since t=
hey aren't
>>>>> things we should hit anyway, but at least this way people have a ch=
oice.
>>>
>>>> Ok. With my distro hat on, I can tell you I'll be leaving them on. :=
)
>>>
>>>> -Jeff
>>>
>>> XFS also has XFS_WARN as a config option, which keeps all the asserti=
ons
>>> in place, but printk's & backtraces w/o the icky BUG().  That might b=
e
>>> good to add as well, and perhaps best for a shipping distro (vs. a de=
veloper
>>> debugging who might want to drop a core file when the assert trips).
>=20
>> Isn't that the distinction between BUG_ON and WARN_ON? If it's worth a=

>> BUG_ON, things should be bad enough (or could result in being bad
>> enough) that we want to bail out.
>=20
>> -Jeff
>=20
> Maybe; just FWIW here was Dave's rationale for xfs.  Right now btrfs
> doesn't have the behavior-changing side effect (no BTRFS_DEBUG config)
> though, so maybe the distinction is less important...

Yeah, I'd agree with the distinction not being there in btrfs (yet).
ReiserFS has a similar mode where there are a ton of checks that are
optionally enabled and does invasive things that can slow things down.
It's disabled pretty much universally AFAIK. One of the things (low) on
my TODO list is to go through all of those and move them into regular
checks since some of them are the types of things fsfuzzer likes to trip
over.

-Jeff

>     xfs: introduce CONFIG_XFS_WARN
>    =20
>     Running a CONFIG_XFS_DEBUG kernel in production environments is not=

>     the best idea as it introduces significant overhead, can change
>     the behaviour of algorithms (such as allocation) to improve test
>     coverage, and (most importantly) panic the machine on non-fatal
>     errors.
>    =20
>     There are many cases where all we want to do is run a
>     kernel with more bounds checking enabled, such as is provided by th=
e
>     ASSERT() statements throughout the code, but without all the
>     potential overhead and drawbacks.
>    =20
>     This patch converts all the ASSERT statements to evaluate as
>     WARN_ON(1) statements and hence if they fail dump a warning and a
>     stack trace to the log. This has minimal overhead and does not
>     change any algorithms, and will allow us to find strange "out of
>     bounds" problems more easily on production machines.
>    =20
>     There are a few places where assert statements contain debug only
>     code. These are converted to be debug-or-warn only code so that we
>     still get all the assert checks in the code.
>    =20
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>=20
>=20
>=20

--=20
Jeff Mahoney
SUSE Labs


--8wSu6IDPxE1WBg5LlvKReV1vg5rpdgQtx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSHRxnAAoJEB57S2MheeWykL0QAJy4mBy7iEZCTnhk6JSHmwmi
atJ71qB2m3h2aTdrInMATfXaUfzSoMaRpVA7TyQ5SJA2ePoypBdpHmdlq7ivoEal
lPjWC3+OO0NO0Qm4XuTCSB5r+2zTmfb+HdZyOg17g/cs2RLGcU1UZsW3H/sjoKQ3
YKCv6k8jsWpeBbYkcuKSpbyHv6pH+orngelryUpa1hH1+GgdyMS1S4TMjHn+Qkou
oAxC0hqQDT7z4P0LMm68Vz+csbtqU/fTNMTUr5ZOxCar6AV6RJ5KffVwMtqyTmVz
veNypM1CDBbmhsXs/C61jlJRAXIV5iVDXu5II7jx4G+RCgU+vNQPVOkRGz5/wN0t
Z7TP+7mtEvkVHQNb/9R5a+0qSgxSY5+D2MNhaOQyZcZVeh5RyDOQdH6+9qcDEyaV
wN6avFpvHD0zrtdhYyiIEFlCfPoH+uqBKLeg1y7DHbW2XYTOWK8KXCSU1YaJHoUW
6aoglMSvnLl2s3oQLqR7Y36OSoWJN+Vyz3FQ8TQFXQ2mfDGZF3KySx0k6bPoElLU
sdsOdcEAPENKd+vTqWV/sNeCEoZEu5O5bT3kFi0Gggi7Y8swoK5NxXL9mQ0kNW4M
blZVW+ad2jFocD1g7Qhwsg7IWzd4A0KsTAMhaLNWn3im96s4YSQkMBFdu8j+QFgC
M6nUdCXGBFi1EEEwawKF
=VRFx
-----END PGP SIGNATURE-----

--8wSu6IDPxE1WBg5LlvKReV1vg5rpdgQtx--
