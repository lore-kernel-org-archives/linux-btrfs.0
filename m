Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45035 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753346AbdAZKAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 05:00:40 -0500
Date: Thu, 26 Jan 2017 10:00:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs recovery
Message-ID: <20170126100038.GE24076@carfax.org.uk>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
In-Reply-To: <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2017 at 10:36:55AM +0100, Oliver Freyermuth wrote:
> Hi and thanks for the quick reply! 
> 
> Am 26.01.2017 um 10:25 schrieb Hugo Mills:
> >    Can you post the output of "btrfs-debug-tree -b 35028992
> > /dev/sdb1", specifically the 5 or so entries around item 243. It is
> > quite likely that you have bad RAM, and the output will help confirm
> > that.
> > 
> 
> Since I did not find item 243 in the debug output at all, I uploaded the complete output of the debug-tree command here:
> http://pastebin.com/xM8qUnSx

   It's on line 248 of the paste:

246.   key (5547032576 EXTENT_ITEM 204800) block 596426752 (36403) gen 20441
247.   key (5561905152 EXTENT_ITEM 184320) block 596443136 (36404) gen 20441
248.   key (15606380089319694336 UNKNOWN.76 303104) block 596459520 (36405) gen 20441
249.   key (5726711808 EXTENT_ITEM 524288) block 596475904 (36406) gen 20441
250.   key (5820571648 EXTENT_ITEM 524288) block 350322688 (21382) gen 20427

   I was wrong in my assumption: this isn't a simple bitflip. It looks
like a small random write of data over the item key. That's not to say
that bad hardware isn't the culprit -- it's worth checking anyway --
but it could also be a bug in... well, almost anything.

   It's not corruption on the disk, because that would be caught by
the checksum mechanism. This data was corrupted in RAM, before it was
checksummed and written to disk. That could have happened as a result
of some rogue piece of kernel code writing to an incorrect address, or
as a result of some _other_ memory corruption affecting an address
which is then used to write something to.

   Looking at the data, I think this should be manually fixable, with
sufficient effort (and a hex editor).

Looking at the item value:

>>> hex(15606380089319694336)
'0xd89500014da12000'

Compared to the preceding key's value:

>>> hex(5561905152)
'0x14b83f000'

It looks like it's just the top couple of bytes in this field that are
affected, so those (d8, 95) can be zeroed. The second field should
clearly be EXTENT_ITEM, which is 0xa8. The offset field (the third
one) looks OK to me -- the bottom byte is 0.

   We can probably talk you through fixing this by hand with a decent
hex editor. I've done it before...

> >    Check and fix your hardware first. :)
> > 
> >    If it is bad RAM, then the error is likely to be a simple bitflip,
> > and there are patches for btrfs check which will fix those in most
> > cases.
> 
> I'll schedule a memcheck as soon as I can turn off the machine for a while,
> which sadly may be a week or so in the future from now... 

   Bear in mind that if it is unreliable hardware, then continued use
of the FS in read-write operation is likely to cause additional
damage.

   Hugo.

-- 
Hugo Mills             | This: Rock. You throw rock.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                          Graeme Swann on fast bowlers

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYicjGAAoJEFheFHXiqx3kPF4QAJxz8wId8VEdaRR3KEGEOVEB
WX/Xi4z5audMPwntYONOBcxPp2nVAfpdolQKud+/VtaFfLWCJ4Hqu7s1XZm6hwOR
AmCbwVmrgFL7021XfvHkBWesUp84u2VMPz/3Sg64xTJDDNDXxaDqmq7OV1jAwG1+
tjHdIymBV8AaZqEjq74ahlzHLZxf+Gm1JBY78pKVfQJBcX2ayRXrYlW33qABS0Qh
Ym6cYfyhWkH7hiSIlzhId8pLn7dr0lKLS2zmYRGGqFx6a52NtpxCxcRR5lfILu8m
c3DOxZbbC8r6ha1qNwDmpaRhE3HZcqxmXdOsfVznX9WtXNNuqCmc+HEs9UAmuBqz
JNA3dmZaHHc1r0Gxx00fcg2MhC2WxTHG7axtzWbeFDOs0oELll9+z2qRbK2jtDxf
0X7s5GCVzOEn9myufgp+BW3Fwv28MdVRQO566FKn2IG7mT1h2iOl2PaYKbj3veFv
zIZJdu6OAoghG9u7aHD48wLKPasVl04JM6czEUAB5kI31rJejBcXw0AnqBXV0D3o
MmF2kNFvCiyTKUcoH7Bi4iXO2zfp7mNmk2SSTRIjEl5zailStDf+ARpGtPohDtKf
ep6nlAn1l2kJ4KrXgX2Z+XyMpIgnTfMLtpBVOJl7JZGoi7taSirFjI0RaLgSq1FX
JGxUM1+XVk4CleCT2WQD
=i5kE
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
