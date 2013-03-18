Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59329 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3CRUfM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 16:35:12 -0400
Date: Mon, 18 Mar 2013 20:35:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jan Beranek <jan233321@gmail.com>
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs in multiple different disc -d sigle -m raid1 one drive
 failure...
Message-ID: <20130318203508.GD19395@carfax.org.uk>
References: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
 <CAE5mzvi5nsTDw9ZX72hXt2EMsmxJUef3WmvArxxKhqJFJU-CLg@mail.gmail.com>
 <CABzOi+c0e4Oq8=Y2gdRsh5=X=P6kVQubGS2qXE+vbodnzfeoMw@mail.gmail.com>
 <CABzOi+ea8fchPK82Xzm95BfS76cWvZ6pAR5m5txkFcjUZN9oJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
In-Reply-To: <CABzOi+ea8fchPK82Xzm95BfS76cWvZ6pAR5m5txkFcjUZN9oJg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 18, 2013 at 09:04:16PM +0100, Jan Beranek wrote:
> Thank you for the test.
> 
> I will do some tests also (later as now I do not have a space for it)
> - when you disconnected one disc (or deleted a file) did you try btrfs
> fi balance? I wonder if missing files simply "disappears" or not,
> because in the fact they are present as metadata information only. if
> not, then would be necessary to  write a small script which will check
> all the files and report missing/broken ones (or use aufs on top).

   You'll still see the file, because the metadata has two copies, so
it'll still be there. You'll only get problems when you try to read it.

> When I use "-d single" option, then preffered way is fill the disc
> completelly and then continue with another disc. And you are right,
> there is no guarantee that some files wil not be spread over all three
> (or more) disc. (as I understand it from docs).

   Correct. The solution to this, as discussed on this list several
times over the last year, is to use alternative chunk and extent
allocators which try to fill disks sequentially and keep extents of
the same files on the same device.

   We don't have those yet, and I'm not aware of anyone planning on
implementing them.

   Hugo.

> On Mon, Mar 18, 2013 at 9:03 PM, Jan Beranek <jan233321@gmail.com> wrote:
> > Thank you for your test.
> >
> > I will do some tests also (later as now I do not have a space for it) - when
> > you disconnected one disc (or deleted a file) did you try btrfs fi balance?
> > I wonder if missing files simply "disappears" or not, because in the fact
> > they are present as metadata information only. if not, then would be
> > necessary to  write a small script which will check all the files and report
> > missing/broken ones (or use aufs on top).
> >
> > When I use "-d single" option, then preffered way is fill the disc
> > completelly and then continue with another disc. And you are right, there is
> > no guarantee that some files wil not be spread over all three (or more)
> > disc. (as I understand it from docs).
> >
> >
> > On Mon, Mar 18, 2013 at 8:24 PM, cwillu <cwillu@cwillu.com> wrote:
> >>
> >> On Mon, Mar 18, 2013 at 12:32 PM, Jan Beranek <jan233321@gmail.com> wrote:
> >> > Hi all,
> >> > I'm preparing a strorage pool for large data with quite low importance
> >> > - there will be at least 3 hdd in "-d single" and "-m raid1"
> >> > configuration.
> >> >
> >> > mkfs.btrfs -d single -m raid1 /dev/sda /dev/sdb /dec/sdc
> >> >
> >> > What happen if one hdd fails? Do I lost everything from all three
> >> > discs or only data from one disc? (if from only one disc, then is it
> >> > acceptable otherwise not...)
> >>
> >> I just finished doing some testing to check:  It will work, kinda sorta.
> >>
> >> You'll be forced to mount read-only, and any reads of file extents
> >> that existed on the missing disk will return an io error.  As I
> >> understand it, single doesn't force files to be on a single disk,
> >> instead it _doesn't_ force them to be _several_ disks; the implication
> >> being that a large file (say, a 4gb movie) may still end up with
> >> pieces on each disk.
> >
> >
> >
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- w.w.w.  : England's batting scorecard ---              

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUUd6fL9z9OVl50rAAQIrYw/+OMkd3jTYY3UxpC3JCxwQ8iSH8uDzmeOI
F46ywyZrWj1uxxb/KI9wIIzkRtMfvjov6CXbZkRJCda+c3T7zzH+lWHWi5vEuRzO
A/bmxodhyrTNuGmsFxDXYYkAgImR691/wsWo1kNaNmIJbLkeg0umdw3KfAPT45yi
CUApT/CCK3gHiKK7mqlXjrQ+SgAZQOTkjIgzpuGvkY7ZoJT98mlMXg88OSNlWESB
UO+uAVRb0lenQOaTVOU/wrRI06s3XtTbYxt2zzs4tAim/1IQhThUwnA2sDzZIujG
h0oZam7YB7aVrcZyRjDU2VwSOalDnnuPvPe/Cbw+BEttN8flaW8dGA/DOexKNrO8
+LOuFwlZc88WDGsC217E9NqgteW9LIdMV5qLHJua0lt1aVsQ35hJerfdA+LUOi8f
4S3d2IppDoe6lkWyIkTnULn588zntVVw/o6Zt99+C1wWjRXov8NTAEOSH/6DhWdf
jevg6zhyiELkz64GcYaNGUsH29nzmp4TYbthrvldWtdlIif4GCblEC0H6XM12DQM
vh5V0yAjFkCFqF/r2L2I7cwa6UvVRk3ExrTza8eujONiVFTwX7CQ1MskIFDfgFZm
9CdvGtbG6bNxZoivF+0MQohr1B6TB5BKJ2GuQgokoSu8zQ8iIxY0XXa3QM3QAndb
q8cqhBmNzok=
=L6Ob
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
