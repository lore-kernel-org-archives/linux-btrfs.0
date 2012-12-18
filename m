Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45126 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2LROiB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:38:01 -0500
Date: Tue, 18 Dec 2012 14:37:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eugene Crosser <crosser@average.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs in the kernel 2.6.31
Message-ID: <20121218143759.GO19051@carfax.org.uk>
References: <50D079AB.2030805@average.org>
 <20121218143521.GN19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H83aLI5Lttn3Hg7B"
In-Reply-To: <20121218143521.GN19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--H83aLI5Lttn3Hg7B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 18, 2012 at 02:35:21PM +0000, Hugo Mills wrote:
> On Tue, Dec 18, 2012 at 06:11:55PM +0400, Eugene Crosser wrote:
> > I have a board based on PLX7821 aka OX820 ARM SoC. It is not

   Oh, I forgot to mention -- there's some problems with the btrfs
userspace tools on ARM, related to unaligned accesses. You will need
to get hold of the patch (from Arne, in October this year, on this
mailing list, shout if you can't find it) which fixes those issues.
It's not made it to the upstream btrfs-progs repo yet.

   Hugo.

> > supported in the mainline kernel; the vendor supplied the source of
> > the kernel 2.6.31 with necessary updates for this platform, and it
> > works. I understand that there have been no successful attempts to
> > bring support of this platform to newer kernels.
> 
> > I would like to use btrfs on this system, but it is labelled
> > "experimental" in the kernel. My question is: is it "safe" to use
> > btrfs as it is in 2.6.31? In other words, where there "data
> > destroying" bugs found and fixed since then? If the answer is yes,
> > then is it possible (and how difficult) to compile newer btrfs code
> > against this kernel, or backport the fixes?
> 
>    2.6.31 is *insanely* old in btrfs terms, and definitely contains
> serious filesystem-corrupting bugs that have been fixed since. You
> should be looking at running 3.7 (right now) or 3.8-rc1 (when that
> comes out next week), from a btrfs point of view. I really wouldn't
> recommend running the btrfs code from 2.6.31.
> 
>    Backporting current btrfs code to a kernel that old is likely to be
> a difficult proposition, simply because other things (in the VFS and
> block layers) will have changed underneath it. Similarly, if the
> patches for your board haven't been updated as the kernel progressed,
> you're going to have a hard time forward-porting them. Given the
> option of where to put in the work, I'd recommend forward-porting the
> hardware support to a more recent kernel, and getting that pushed to
> mainline, as it's more likely to be useful in the future, and useful
> to more people.
> 
>    Hugo.
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Our so-called leaders speak/with words they try to jail ya/ ---   
        They subjugate the meek/but it's the rhetoric of failure.        
                                                                         

--H83aLI5Lttn3Hg7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNB/x79z9OVl50rAAQK70hAAhT9gXiLTIiAKrkonm/d3VBcOAqRqm/pt
duFIAMKt7gjiQcEC3lk0aHs2qz4bfuOtn7q9gEipYEF0NWlw3ZuogeqHrnrssK7x
dDcpyRtbBfju4pT8bFGG0XcDDge3iGXY6VoQWZ+3ct1zXm950dCuAZB7vY4Lczl+
aPXBbrI3KqhWNLDgY+6WpSR8TeP7rpL1P9nIpLYGCfeG9FwmM9+8QiQzFV2oSuYG
on+8agb46DhSs+Whk5Pt2fS2YG7pwtRg796Wq2ESi4A+35B6evBJJWBefeDFLnXL
2nUvzILTj93T9NK0njPpvwmWk/gwll/IexeyF8bkw4/Lf5zZp7GRuLoyokAGU0Y6
ESgp+PBeJvJnHnDvV9uakxhODYQPkTwR+Q5d8GlKbtoykcc85ZRKuK1Syh9qrSS2
hbnzsa99ILLea0NxaVsfUBrIT5W7mbUS0WDk5uE4Ipf02OzvLevq1QgV2aYUfq+D
Pz4713EZ7EzFMtBkVMiINreliqagfqP3C513KdKk7j26Z2F4m5KiVx3fFHRISxs1
D8k4AXX5lt+nv5zfntgKoDjwpXnqKDh40KdI/NJ0QXGcsw/Vl0ig70ah24DXLyS0
Lf2VkggTLRWLJbsrnS1k8q2aZPk52h3i4rsvBvtSZHAHhtCR93nWRNwhT37sBPnd
o8MqJP1Psbg=
=f4TD
-----END PGP SIGNATURE-----

--H83aLI5Lttn3Hg7B--
