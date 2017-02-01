Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alt13.smtp-out.videotron.ca ([135.19.0.26]:23598 "EHLO
        alt12.smtp-out.videotron.ca" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750937AbdBADGv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 22:06:51 -0500
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
 <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
 <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
From: Hans Deragon <hans@deragon.biz>
Message-ID: <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
Date: Tue, 31 Jan 2017 21:51:22 -0500
MIME-Version: 1.0
In-Reply-To: <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Dj1X28XR2EjjjTcfmBg3dmi4iaMq2KJ4o"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Dj1X28XR2EjjjTcfmBg3dmi4iaMq2KJ4o
Content-Type: multipart/mixed; boundary="jRs9XwF8wko6OpG9Jxid0gUBbbq5twW4T";
 protected-headers="v1"
From: Hans Deragon <hans@deragon.biz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
 Adam Borowski <kilobyte@angband.pl>
Message-ID: <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
 <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
 <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
In-Reply-To: <YAvBcoM9EImXYYAvCcegSf@videotron.ca>

--jRs9XwF8wko6OpG9Jxid0gUBbbq5twW4T
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2017-01-30 07:18, Austin S. Hemmelgarn wrote:
> On 2017-01-28 04:17, Andrei Borzenkov wrote:
>> 27.01.2017 23:03, Austin S. Hemmelgarn =D0=BF=D0=B8=D1=88=D0=B5=D1=82:=

>>> On 2017-01-27 11:47, Hans Deragon wrote:
>>>> On 2017-01-24 14:48, Adam Borowski wrote:
>>>>
>>>>> On Tue, Jan 24, 2017 at 01:57:24PM -0500, Hans Deragon wrote:
>>>>>
>>>>>> If I remove 'ro' from the option, I cannot get the filesystem moun=
ted
>>>>>> because of the following error: BTRFS: missing devices(1) exceeds =
the
>>>>>> limit(0), writeable mount is not allowed So I am stuck. I can only=

>>>>>> mount the filesystem as read-only, which prevents me to add a disk=
=2E
>>>>>
>>>>> A known problem: you get only one shot at fixing the filesystem, bu=
t
>>>>> that's
>>>>> not because of some damage but because the check whether the fs is
>>>>> in a
>>>>> shape is good enough to mount is oversimplistic.
>>>>>
>>>>> Here's a patch, if you apply it and recompile, you'll be able to mo=
unt
>>>>> degraded rw.
>>>>>
>>>>> Note that it removes a safety harness: here, the harness got tangle=
d
>>>>> up and
>>>>> keeps you from recovering when it shouldn't, but it _has_ valid use=
s
>>>>> that.
>>>>>
>>>>> Meow!
>>>>
>>>> Greetings,
>>>>
>>>> Ok, that solution will solve my problem in the short run, i.e. getti=
ng
>>>> my raid1 up again.
>>>>
>>>> However, as a user, I am seeking for an easy, no maintenance raid
>>>> solution.  I wish that if a drive fails, the btrfs filesystem still
>>>> mounts rw and leaves the OS running, but warns the user of the faili=
ng
>>>> disk and easily allow the addition of a new drive to reintroduce
>>>> redundancy.  Are there any plans within the btrfs community to
>>>> implement
>>>> such a feature?  In a year from now, when the other drive will fail,=

>>>> will I hit again this problem, i.e. my OS failing to start, booting
>>>> into
>>>> a terminal, and cannot reintroduce a new drive without recompiling t=
he
>>>> kernel?
>>> Before I make any suggestions regarding this, I should point out that=

>>> mounting read-write when a device is missing is what caused this issu=
e
>>> in the first place.
>>
>>
>> How do you replace device when filesystem is mounted read-only?
>>
> I'm saying that the use case you're asking to have supported is the
> reason stuff like this happens.  If you're mounting read-write degraded=

> and fixing the filesystem _immediately_ then it's not an issue, that's
> exactly what read-write degraded mounts are for.  If you're mounting
> read-write degraded and then having the system run as if nothing was
> wrong, then I have zero sympathy because that's _dangerous_, even with
> LVM, MD-RAID, or even hardware RAID (actually, especially with hardware=

> RAID, LVM and MD are smart enough to automatically re-sync, most
> hardware RAID controllers aren't).
>=20
> That said, as I mentioned further down in my initial reply, you
> absolutely should be monitoring the filesystem and not letting things
> get this bad if at all possible.  It's actually very rare that a storag=
e
> device fails catastrophically with no warning (at least, on the scale
> that most end users are operating).  At a minimum, even if you're using=

> ext4 on top of LVM, you should be monitoring SMART attributes on the
> storage devices (or whatever the SCSI equivalent is if you use
> SCSI/SAS/FC devices).  While not 100% reliable (they are getting better=

> though), they're generally a pretty good way to tell if a disk is likel=
y
> to fail in the near future.

Greetings,

I totally understand your concerns.  However, anybody using raid is a
grown up and though for them if they do not understand this.  But the
current scenario makes it difficult for me to put redundancy back into
service!  How much time did I waited until I find the mailing list,
subscribe to it, post my email and get an answer?  Wouldn't it be better
if the user could actually add the disk at anytime, mostly ASAP?

And to fix this, I have to learn how to patch and compile the kernel.  I
have not done this since the beginning of the century.  More delays,
more risk added to the system (what if I compile the kernel with the
wrong parameters?).  Fortunately, my raid1 system is for my home system
and I do not need that data available right now.  The data is safe, but
I have no time to fiddle with this issue and put the raid1 in service by
compiling a new kernel.  I do have the extra drive sitting on my desk,
useless for the moment.

Which market is btrfs raid targeted for?  In the enterprise world, all
the proprietary raid solutions I know of alerts admins when a disk is a
problem, but allows continuous, uninterrupted read-write service.  If
you have hundreds of employees depending upon a NAS, you do not want
them to turn their thumbs until the new drive is put in place.  In SOHO,
the admin is often outsourced, maybe attending someone's else problem
when the drive failure occurs.  What should then the business do?  Tell
everybody to go home?

Is this the same problem with raid6?  If one drive dies, system goes
down even if redundancy still remains?

Best regards,
Hans Deragon


--jRs9XwF8wko6OpG9Jxid0gUBbbq5twW4T--

--Dj1X28XR2EjjjTcfmBg3dmi4iaMq2KJ4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAliRTSoACgkQkn1Tn1exbkgHxwCgihwNHibDZEXgKPc/nXaegeFS
PpYAn36usAjYxez8ggszJnvX9YsQafgV
=eTPC
-----END PGP SIGNATURE-----

--Dj1X28XR2EjjjTcfmBg3dmi4iaMq2KJ4o--
