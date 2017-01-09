Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937035AbdAIVi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jan 2017 16:38:26 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Omar Sandoval <osandov@osandov.com>, Eric Sandeen <sandeen@redhat.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
 <4d1d233a-1002-169e-ec9b-14df3b1af86c@redhat.com>
 <20170109213405.GB29762@vader.DHCP.thefacebook.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a6acab91-9c87-a579-4070-fb603ef3542d@suse.com>
Date: Mon, 9 Jan 2017 16:38:22 -0500
MIME-Version: 1.0
In-Reply-To: <20170109213405.GB29762@vader.DHCP.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IGvInIuEscQRVIajMTWbl4e1IeULkTo0r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IGvInIuEscQRVIajMTWbl4e1IeULkTo0r
Content-Type: multipart/mixed; boundary="OcPXDQ0Dtu5HuWEhQ9U9JRKrkXHgGochW";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Omar Sandoval <osandov@osandov.com>, Eric Sandeen <sandeen@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues
 <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
Message-ID: <a6acab91-9c87-a579-4070-fb603ef3542d@suse.com>
Subject: Re: [RFC] Converging userspace and kernel code
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
 <4d1d233a-1002-169e-ec9b-14df3b1af86c@redhat.com>
 <20170109213405.GB29762@vader.DHCP.thefacebook.com>
In-Reply-To: <20170109213405.GB29762@vader.DHCP.thefacebook.com>

--OcPXDQ0Dtu5HuWEhQ9U9JRKrkXHgGochW
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/9/17 4:34 PM, Omar Sandoval wrote:
> On Mon, Jan 09, 2017 at 09:31:39AM -0600, Eric Sandeen wrote:
>> On 1/8/17 8:11 PM, Qu Wenruo wrote:
>>>
>>>
>>> At 01/08/2017 09:16 PM, Goldwyn Rodrigues wrote:
>>>>
>>>> 1. Motivation
>>>> While fixing user space tools for btrfs-progs, I found a couple of b=
ugs
>>>> which are already solved in kernel space but were not ported to user=

>>>> space. User space is a little ignored when it comes to fixing bugs i=
n
>>>> the core functionality. XFS developers have already performed this a=
nd
>>>> the userspace and kernel code walks in lockstep for libxfs.
>>>
>>> Personally speaking, I'm not a fan of re-using kernel code in btrfs-p=
rogs.
>>
>> But it already does re-use kernel code, it's just that the re-use is
>> extremely stale, with unfixed bugs in both directions as a result
>> (at least last time I looked.)
>>
>>> In fact, in btrfs-progs, we don't need a lot of kernel facilities,
>>> like page/VFS/lock(btrfs-progs works in single thread under most
>>> case).
>>>
>>> And that should make btrfs-progs easier to maintain.
>>
>> But as Goldwyn already pointed out, many bugs have gone un-fixed
>> in userspace, in code which was forked long ago from kernelspace.
>>
>> For things like locking it's trivial to define that away.
>>
>> xfsprogs does i.e. -
>>
>> /* miscellaneous kernel routines not in user space */
>> #define down_read(a)            ((void) 0)
>> #define up_read(a)              ((void) 0)
>> #define spin_lock_init(a)       ((void) 0)
>> #define spin_lock(a)            ((void) 0)
>> #define spin_unlock(a)          ((void) 0)
>> #define likely(x)               (x)
>> #define unlikely(x)             (x)
>> #define rcu_read_lock()         ((void) 0)
>> #define rcu_read_unlock()       ((void) 0)
>> #define WARN_ON_ONCE(expr)      ((void) 0)
>>
>>
>>> Furthermore, there are cases while kernel is doing things wrong while=

>>> btrfs-progs does it right.
>>
>> All the more reason to sync it up, fixes should always be in both
>> places, right?
>>
>> I had looked at this a few years ago, and started trying to sync thing=
s
>> up, but got daunted and busy and never completed anything.  :(  I sent=

>> a few fixups back in April 2013 to get things /slightly/ closer.
>>
>> The libxfs sync in xfs has borne fruit; I'm of the opinion that simila=
r
>> work would help btrfs too, though it can be a long road.
>>
>> (e2fsprogs has gone the other way, and has a completely separate
>> re-implementation in userspace; it works, I guess, but I have to say
>> that I really like the code commonality in xfs.)
>>
>=20
> Yup, I also think we should be going in the XFS direction. It's a big
> maintenance burden to have to worry about the code in two places. (E.g.=
,
> the biggest reason I haven't gotten around to implementing full free
> space tree support in btrfs-progs is that it's such a pain in the ass t=
o
> port new kernel code to the outdated progs code.)

Another advantage is that we will be able to at least write test cases
for the shared code that can be run entirely in userspace.  That
obviously doesn't address a huge class of potential problems, but it's
better than what we have now.

> As far as I know, the only reason it hasn't happened yet is that no one=

> has agreed to do it, and we're all just hoping someone else will take
> care of it.

Yeah, I think that's exactly it.  Having one shared source base is going
to be easier to maintain for everyone.  The longer we wait to do it, the
more it will diverge.  This is a topic we've been discussing in our
team's weekly call for the past few weeks.  I think Goldwyn is granting
that last wish. :)

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--OcPXDQ0Dtu5HuWEhQ9U9JRKrkXHgGochW--

--IGvInIuEscQRVIajMTWbl4e1IeULkTo0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYdALOAAoJEB57S2MheeWyyMoP/RrMed2Tk+wzElwHzUnwYrMh
r5H0KCrqmunEfjMtCnaIp6J8kE/sqSbnByBRcb32QVOEKzI8q5+Lo3kcmC0bNzxO
6gz7+l46Z3kXUXSPnjWtJZwEl9e0sHyKblu06jlncQcN6V8yP2Lt+ToC5EyyxD+D
tKN7coEcszPI7UGnPxxDphb0tuA8sZY7RZ+7uMqKe9fFFm9XHMO1gxFk9YMTgjiR
mOFycyxMVvacjlDkGDkR5eMk3nHitFP7nr3oTNN7+KcGoxRPGR9wcrvCyIQ1Db3N
urI5UaS40m/GcQB3L2DF67G7GI0Ixn0+vXATLXgZgBh9+ccHkaEGB/74NetUd17J
zc1iAq/YHAACzGcTC0IScP6ceEqdC3q6rbDoBlYorcGXBdyRs5DEL3MNTuSS+62j
b6RRJg3/1G52u9WIwrsvxDDurh2NDYqTaTmDTru9ODjZQj3ktiIUXI3kNF4CnIvC
wKU2CkueJFCOCy433nEZNvQ3AIT8BTvrVMyUGlF0LPenkMXr8INW9cOs4pN/mEGA
56StbYqPXQFTQR9fJEVhEJWZWKhNS/hVrDoyk2IVjj7LSeRbEkysOo501bGsyaGO
SeZAQrQRQCV/HnWk1UYdpOfL82WifiE2AFWWFSkLjfoArJ4iXUSiSCoR+VnwHn/l
qa2MkC2pvekNOBmx8vEC
=pVNw
-----END PGP SIGNATURE-----

--IGvInIuEscQRVIajMTWbl4e1IeULkTo0r--
