Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932254AbcIBO0o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 10:26:44 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
Date: Fri, 2 Sep 2016 10:26:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gSpQfkU7sfumSi9MS4w9XpqD1Ctm2t85L"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gSpQfkU7sfumSi9MS4w9XpqD1Ctm2t85L
Content-Type: multipart/mixed; boundary="XufrWlNxWr97FSFg4nWQPFm7nOeKmx7Li";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
In-Reply-To: <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>

--XufrWlNxWr97FSFg4nWQPFm7nOeKmx7Li
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/1/16 8:12 PM, Chris Murphy wrote:
> On Thu, Sep 1, 2016 at 12:47 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>=20
>=20
>> 2. Snapper's default snapshot creation configuration is absolutely
>> pathological in nature, generating insane amounts of background resour=
ce
>> usage and taking up huge amounts of space.  If this were changed, you =
would
>> be a lot less dependent on being able to free up snapshots based on sp=
ace
>> usage.
>=20
> That's diplomatic.
>=20
> They know all of this already though, but instead of toning down
> snapper defaults, they're amping up the voluming by enabling quotas
> instead.
>=20
> There is only one logical reason for this that I can thing of. They're
> trying to increase problem reports, presumably in order to smooth out
> noisy data, maybe even by getting better bug reports like Ronan's. But
> I think this is a specious policy.

There's no conspiracy to leverage the openSUSE user base to generate bug
reports any more than enabling any other feature in Tumbleweed before
SLES is.  We've enabled qgroups by default so that snapper can make sane
decisions based on space usage.  That's it.

>> It's poor choices like this that fall into the category of 'Ooh, this =
looks
>> cool, let's do it!' made by major distros that are most of the reason =
that
>> BTRFS has such a bad reputation right now.
>=20
> Over on Factory list, they're trying to have this two ways. First
> they're saying quotas are stable as they've implemented them in the
> Leap 4.4 kernel. And they consider the btrfs-progs man page warning
> that quotas aren't yet stable even in 4.7, and aren't recommended
> unless the user will use them, is a bug that should be removed from
> their copy of the man page.

Yep.  That's a bug in the man page.  We do consider them stable.  I see
every btrfs bug that gets reported against SLE12 SP2, upon which the
Leap kernel is based.  Have there been qgroups bugs over the development
cycle?  You bet.  There's a reason if you look at the commit log for
qgroups over the past year, you'll see a bunch of fixes from SUSE
developers.

I explained what I think Ronan's issue is in another part of the thread
just now.  I don't think that's a severe issue at all.  Annoying?  Sure,
but I'm more concerned with the underlying ENOSPC issue.  Without more
info, I don't know what the cause of it is and when it was introduced.

We, like every other group of file system developers, run xfstests
pretty religiously.  Since qgroups are becoming a bigger part of the
btrfs experience for our products, we test them specifically.  Yes,
there are xfstests /just/ for qgroups, but we also make it a point to
run the entire xfstests suite with and without qgroups enabled.  Since
the requirement for snapper was to have accurate space tracking, that's
what we've focused on.

I obviously can't open up the SLES bugzilla to the world, so you're
going to have to take my word on this.  For our 4.4-based kernel there
are currently 3 qgroup related bugs.  The first is a report about how
annoying it is to see old qgroup items for removed subvolumes.  The
second is an accounting bug that is old and the developer just hasn't
gotten around to closing it yet.  The third is a real issue, where users
can hit the qgroup limit and are then stuck, similar to how it used to
be when you'd hit ENOSPC and couldn't remove files or subvolumes.  My
gut feeling is that it's the same kind of problem:  Removing files
involves allocating blocks to CoW the metadata and when you've hit your
quota limit, you can't allocate the blocks.  I expect the solution will
be similar to the ENOSPC issue except that rather than keeping a pool
around, we can just CoW knowing full well the intention is to release
space.  My team is working on that today and I expect a fix shortly.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--XufrWlNxWr97FSFg4nWQPFm7nOeKmx7Li--

--gSpQfkU7sfumSi9MS4w9XpqD1Ctm2t85L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyYwdAAoJEB57S2MheeWy1N4P/idwFuzfQXwpti6rJTYKN6SX
TbBydP4N2Cziws42URTQeK4nSIBGpXVLjSPT6rkl8P3GEgKJgJPApPX/rle8yAHB
lG4Isdix8cZK8B7vgcC6iENbNe3He1M1CQOqTNf8ieKhQ9vINWCfDYSg5Cfco+Le
UlaAH2uvlu7GL22Spv0P1oygcrTi/9ZORycBXvhy4hSPUdDSbua/lJJks3gXBgbO
yq00N/YnEKz9zDe0XOOTuQ+PbiuEc5GBPIH8wNBTUkG/czmKIg4Vt8XWtQz/16Li
lRtqVC7LXKm6UEbzaq89VFGEQ7Tfk6ZsC/siZqlIHU0dsvEcg3QRzY0kd2pJboj6
pj23toBqnUOj+Eav8HhsTB22KPOBdw9/J5jPy2r5kO8Bqo9XDeaIMEBQk7d98b4a
3sp9K5uERx3DkycEfg6w71VyeY5xU3p+0qHuXarxD3aQ+Zj+8ocM3GniNIOmj1Xn
4Pk1EGqmMRVTbt+fltgtCb6LcWmvXzbH8xKG2R3qR3X3FY6RxzcQgX4K+kfiMOns
e+83npxCP/YIYy/+7tDZK8nXM+JqpKQM9WCrllm+w3NOfoS0URb//SU4IoyZ3BPm
R9/CN67uzmXQuYvoXgNOhTPPS4W6pcF6eOxuu48GQx0E8+XNfRwsD13BWTqIU7P7
dBqO/WQI9YYVbsgJyCxO
=kdSF
-----END PGP SIGNATURE-----

--gSpQfkU7sfumSi9MS4w9XpqD1Ctm2t85L--
