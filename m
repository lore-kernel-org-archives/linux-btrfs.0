Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52232 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbbAESWk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 13:22:40 -0500
Date: Mon, 5 Jan 2015 18:22:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS_IOC_TREE_SEARCH ioctl
Message-ID: <20150105182238.GE32182@carfax.org.uk>
References: <20150105171512.GA19126@gardel-login>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
In-Reply-To: <20150105171512.GA19126@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 06:15:12PM +0100, Lennart Poettering wrote:
> Heya,
> 
> I recently added some btrfs magic to systemd's machinectl/nspawn
> tool. More specifically it can now show the disk usage of a container
> that is stored in a btrfs subvolume. For that I made use of the btrfs
> quota logic. To read the current disk usage of a subvolume I took
> inspiration from btrfs-progs, most specifically the
> BTRFS_IOC_TREE_SEARCH ioctl(). Unfortunately, documentation for the
> ioctl seems to to be lacking, but there are some things about it I
> fail to grok:
> 
> What precisely are the semantics of the ioctl, regarding the search
> key min/max values (the fields of "struct btrfs_ioctl_search_key")? I
> kinda assumed that setting them would result in in only objects to be
> returned that are within the min/max ranges. However, that appears not
> to be the case. At least the min_offset/max_offset setting appears to
> be ignored?

   This is an old argument. :)

   Keys have three parts, so it's plausible (but, in this case, wrong)
to consider the space you're searching to be a 3-dimensional space of
(object, type, offset), which seems to be what you're expecting. A
min, max pair would then define an oblong subset of the keyspace from
which to retrieve keys.

   However, that's not actually what's happening. Keys are indexed
within their tree(s) by a concatenation of the items in the key. A
key, therefore, should be thought of as a single 136-bit integer, and
the keys are lexically ordered, (object||type||offset), where "||" is
the concatenation operator. You get every key _lexically ordered_
between the min and max values. This is a superset of the
3-dimensional results above.

   About 3-4 years ago, we see-sawed through several messy patches in
userspace (and at least one in the kernel) before this distinction and
difference in semantics was understood.

> The code I hacked up is this one:
> 
> http://cgit.freedesktop.org/systemd/systemd/tree/src/shared/btrfs-util.c#n427
> 
> I try to read the BTRFS_QGROUP_STATUS_KEY and BTRFS_QGROUP_LIMIT_KEY
> objects for the subvolume I care about. Hence I initialize .min_type
> and .max_type to the two types (in the right order), and then
> .min_offset and .max_offset to subvolume id. However, the search ioctl
> will still give me entries back with offsets != the subvolume id...
> 
> Is this intended behaviour of the search ioctl? If so, what's the
> rationale?

   Yes, it is. The rationale is that it's simply walking through the
key values in the tree linearly until the max value is found.

> My code currently invokes the search ioctl in a loop to work around
> the fact that .min_offset/.max_offset don't work as I wish they
> did... I wish I could get rid of this loop and filtering out of the
> entries I get back that aren't in th range I specified...

   You'd have to do this in kernel space if you wanted the 3D
semantics instead of the concatenated semantics. There's no free lunch
here. It might be a good idea for "libbtrfs" (such as it is) to
implement this, as it's a (moderately rare) repeat request.

   Hugo.

-- 
Hugo Mills             | Klytus, I'm bored. What plaything can you offer me
hugo@... carfax.org.uk | today?
http://carfax.org.uk/  |
PGP: 65E74AC0          |                      Ming the Merciless, Flash Gordon

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUqtZuAAoJEFheFHXiqx3krGQP/0sty94BxYQp0eaTnOT1Ve1k
jQTrHZMtZajEY6qtYRlU0Voh2QY0KKNfqfXzuSmDZN9TnAZJRExDoSgTOaNVkuCZ
pKtpjy+VxDeVugt0r5O3jL54dp3lNxV/FCw+sr2a3ii/jSRI+d8nk+VKM5jTVnhf
q50lEUjYy35pauA7BOnGy9QnXqSuyMWy1zkYdN+Ei2NA4F3qI/92oiRYiLWRQCTB
AJTTl1hwEyqgxEqt3df+doy7rJiupkKiG/urnxZ+CO+02Snjj7l5tU6wOGY3j9s7
gmx/67hQPPhNv3IM/mNmLlOX/Mq8HLvL11YhaubgnyW/4XXgYyZg/z2PfVeYcDzJ
AF5Tw7AkLoq8+UHF8uMw2MQFqwQwm/X1PXCq8+4Pr1wPX77BwFNLtlIoPPMOL4Zt
wnQUNbinspgmf2Gshf1SXP+MN/D6327TIPUudKuqMl1GUTcJiXLEgiVuKooL2cOG
QVVRhwvBTfOvAnxBQKc8/0LyRQkvIAf5XBO7E55IDphG8BwP8jOyGnZfptHeCGpw
/VU4ZcyCCKGRuhlAeHK5F+e3tZ59U1U6zHs9reJhSyrFjPONBkPsUcNuEbwAZOa1
jjM+PTnEha/+OUFIJ2gcsWSQ4TZvvx7EZmRrU00U3acYaHhMdva4j3XHV7JPIneF
u5o/dduKEv/sK6mxuyQs
=ifGN
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
