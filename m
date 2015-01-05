Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52453 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbbAETfD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 14:35:03 -0500
Date: Mon, 5 Jan 2015 19:35:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS_IOC_TREE_SEARCH ioctl
Message-ID: <20150105193501.GF32182@carfax.org.uk>
References: <20150105171512.GA19126@gardel-login>
 <20150105182238.GE32182@carfax.org.uk>
 <20150105191156.GA19373@gardel-login>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2qXFWqzzG3v1+95a"
In-Reply-To: <20150105191156.GA19373@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2qXFWqzzG3v1+95a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 08:11:56PM +0100, Lennart Poettering wrote:
> On Mon, 05.01.15 18:22, Hugo Mills (hugo@carfax.org.uk) wrote:
> 
> > On Mon, Jan 05, 2015 at 06:15:12PM +0100, Lennart Poettering wrote:
> > > Heya,
> > > 
> > > I recently added some btrfs magic to systemd's machinectl/nspawn
> > > tool. More specifically it can now show the disk usage of a container
> > > that is stored in a btrfs subvolume. For that I made use of the btrfs
> > > quota logic. To read the current disk usage of a subvolume I took
> > > inspiration from btrfs-progs, most specifically the
> > > BTRFS_IOC_TREE_SEARCH ioctl(). Unfortunately, documentation for the
> > > ioctl seems to to be lacking, but there are some things about it I
> > > fail to grok:
> > > 
> > > What precisely are the semantics of the ioctl, regarding the search
> > > key min/max values (the fields of "struct btrfs_ioctl_search_key")? I
> > > kinda assumed that setting them would result in in only objects to be
> > > returned that are within the min/max ranges. However, that appears not
> > > to be the case. At least the min_offset/max_offset setting appears to
> > > be ignored?
> > 
> >    This is an old argument. :)
> > 
> >    Keys have three parts, so it's plausible (but, in this case, wrong)
> > to consider the space you're searching to be a 3-dimensional space of
> > (object, type, offset), which seems to be what you're expecting. A
> > min, max pair would then define an oblong subset of the keyspace from
> > which to retrieve keys.
> >
> >    However, that's not actually what's happening. Keys are indexed
> > within their tree(s) by a concatenation of the items in the key. A
> > key, therefore, should be thought of as a single 136-bit integer, and
> > the keys are lexically ordered, (object||type||offset), where "||" is
> > the concatenation operator. You get every key _lexically ordered_
> > between the min and max values. This is a superset of the
> > 3-dimensional results above.
> 
> Ah, I see. Makes sense.
> 
> I figure the comments in btrfs.h next to "struct
> btrfs_ioctl_search_key" could use some updating in this regard. They
> pretty explicitly suggest that the 3 axis were independent and each
> eleent individually would be between the respective min/max when
> returning...
> 
> Ideally the structure would just have two fields called "max", and
> "min" or so, of type btrfs_disk_key, right? In that case I figure the
> behaviour would have been clear. It's particular confusing that the
> disk key fields appear in a different order than otherwise used and
> with the min_transid+max_transid in the middle...

   Yes, it's not exactly the most obvious structure.

> Which brings me to my question: how does {min|max}_transid affect the
> search result? Is this axis orthogonal or is it neither?

   Hmm. Good question. I don't know the answer to that one, I'm
afraid. I _think_ it's orthogonal (since it's not indexed in the same
B-tree structures).

   Hugo.

-- 
Hugo Mills             | What do you give the man who has everything?
hugo@... carfax.org.uk | Penicillin is a good start...
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--2qXFWqzzG3v1+95a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUqudkAAoJEFheFHXiqx3kSvoQAIsXfqmBysj6Dg03SADaG0Oe
SZfRuvHao6mU7UCYYh5EWzhwzNN4gBmOM8aBsiV+pJHT9KhJASHhnO+kz6nxN/h8
70f6QIGnfT9+hX0nqWj7dmVfpYOkEPhzV1SQm43FOMCFWgE/7MINafCbdQ6RIaS8
k6nT2e2S1ztNjzfgoOAHwkPNN/jeiCQldHkOnDul2RDjUl6Z6zd1TFFkEXHVq2lN
D0xxIdwbE2FXXS75dgU3J23zNhWxTkSsLNAk3hEMwNLojZdh00ILt5DtL46iZnpf
4GHRUM8ouyFitN4HJcqLCL5ZIC98roOCDjb8f3Xa4HHmxGlfukxUJgUrxj2t9ZiY
FHo3+xGYu/pkYWIeZegnF3E7mJNf4Phldk25fe0QLhw/2pXDF++rErrCrWb5g5RD
vMINoBqPtuZNxtC00zaMC9IyV2xpZLKy3GMIQYHByziSUCLgx6TltdHp6WnjS9aR
2Xiq/HSTL7Ob4IAwP5YMXKiWR/x2gWmpnhs/j4M+lugOXTSuCm6alTWsNnp8UOVM
sL0qqfxTm2cxfMTrSQssBZk4hZgWO4idxM2TkbXoQrSvDuK8koUsVvFGhwjRaTkv
QqqS5pUjtckQKXljlIHABcatpZNuq0MFfvmkZx18giBEoc2OxRQaHi/wPwsNSeR5
HhCogZXLNllKM2N5/NN+
=17Iv
-----END PGP SIGNATURE-----

--2qXFWqzzG3v1+95a--
