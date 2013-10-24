Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33590 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JXOyW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:54:22 -0400
Date: Thu, 24 Oct 2013 15:54:14 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
Message-ID: <20131024145414.GB31029@carfax.org.uk>
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
 <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
 <20131022143303.GU1032@twin.jikos.cz>
 <52672F90.8060804@oracle.com>
 <20131024145100.GC28149@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
In-Reply-To: <20131024145100.GC28149@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 24, 2013 at 04:51:00PM +0200, David Sterba wrote:
> On Wed, Oct 23, 2013 at 10:08:16AM +0800, Anand Jain wrote:
> > On 10/22/13 10:33 PM, David Sterba wrote:
> > >On Tue, Oct 22, 2013 at 01:53:22PM +0800, Anand Jain wrote:
> > >>@@ -386,7 +395,7 @@ static int btrfs_scan_kernel(void *search)
> > >>  static const char * const cmd_show_usage[] = {
> > >>-	"btrfs filesystem show [options] [<path>|<uuid>]",
> > >>+	"btrfs filesystem show [options|<path>|<uuid>]",
> > >
> > >Options should stay separate from the path/uuid, you're extending the
> > >syntax to accept a device:
> > >
> > >	"btrfs filesystem show [options] [<path>|<uuid>|<device>]",
> > >
> > >I'm fixing it locally, let me know if this doesn't match what you've
> > >intended.
> > 
> >  I am confused, on how the options should be represented,
> >  but the internal design is as below.
> 
> Hm right, it is a bit confusing, I think because of the syntax that
> allows either options or the path/uuid/device specifier, not both, which
> is not so common.

   Typically, that ends up written as something like:

btrfs filesystem show [options]
btrfs filesystem show [<path>|<uuid>|<device>]

or just as

btrfs filesystem show [options] [<path>|<uuid>|<device>]

with a comment in the man page that the second parameter can't be
supplied with any of the options (if that's the case). Of the two, I
prefer the former, but with the acknowledgement that when the command
grows some options that can be used with the p/u/d, you'll end up
having to change the help text.

   Hugo.

> I still prefer to keep them separate, because it's something that can be
> clarified in the help text or documentation.
> 
> Besides, that we may want to add more options that affect
> path/uuid/device output, the argument description looks consistent with
> other commands and if some combination is not allowed, then an error
> message will say why. I really don't expect an average user to think too
> hard about it.
> 
> david

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUmk0llheFHXiqx3kAQKdaQ//UOqlmqsYr0g1HNqBLZDN8oGSEny32Xkz
6tH6a7UkODej81FT/XNjrqzWlY6bEZHvCTxeNHk6FCMsL5bN65+wCqeOXFh0IOFQ
90OKWpDkIIzSQfvJTCLC0x6vS31DOsgmcyCV8xhO5ZjzWKd2fCQR7heF9WrICg3g
hfyTU+5UiNb3A5MmOpD1M8kMak1obaVFeOGW3D7qOkmpa7cGIQoJCfD/r2WuWuWT
RYjwPsKib1lL210AiCh/1UZ2DLhSVcIulKToGDsVXdA6vX+PeRUHD3JljETqgZl8
v4zmpIULLAhfnicQvH9cQ+AaMNIJ3Ln+D55kXFkOdmPOml8tKmgTY+Vc0UCaQ257
JZdFT/NXV+DnPec6fM6E1gtBuKSWAWcIcjgQMEcd30aBiDqjUiMRLK6ScS+38AzN
93SUWLCU/wFV4Tnat/JNQIjGMITMYuGMtcMmtTj8gomeaFbUfwXDv8KINx9ocM9i
S76FdSUFUXSd8XbqBf6dbw1nfdeyo7grE5XYa2iOc7ML3M0RiwnaPn3O/FWo9LcX
U3NJ1AjKViXIFyJJ6IURFw8J2Gj6yt/yb2K5AgxirxrHaJMn8ISu8pckWVt34G4p
YOJ+qI8O0wsY1K0x3I1krwBag6CAItBvsauoSbLVsKQgExctmkN5/f5W9Vecxg1+
q1zcFO9m6Zc=
=tORp
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
