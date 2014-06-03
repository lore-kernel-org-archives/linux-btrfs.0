Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:34947 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaFCMCe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 08:02:34 -0400
Date: Tue, 3 Jun 2014 13:55:52 +0200
From: Christian Hesse <mail@eworm.de>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        clm@fb.com
Subject: Re: [PATCH 1/1] btrfs-progs: fix build, manpage compression command
Message-ID: <20140603135552.7a25af73@leda.localdomain>
In-Reply-To: <20140603091407.GG22324@twin.jikos.cz>
References: <1401775765-16646-1-git-send-email-mail@eworm.de>
	<20140603091407.GG22324@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/R5=M4c9u.gAi4qmVrYdqT/."; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/R5=M4c9u.gAi4qmVrYdqT/.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

David Sterba <dsterba@suse.cz> on Tue, 2014/06/03 11:14:
> On Tue, Jun 03, 2014 at 08:09:25AM +0200, Christian Hesse wrote:
> > man pages for btrfs-progs are compressed by gzip by default. In Makefile
> > the variable GZIP is use, this evaluates to 'gzip gzip' on my system.
> > >From man gzip:
> >=20
> > > The environment variable GZIP can hold a set of default options for
> > > gzip. These options are interpreted first and can be overwritten by
> > > explicit command line parameters.
> >=20
> > So using any other variable name fixes this.
>=20
> Thanks, I can see that you've fixed this bug for the second time.  The
> GZIP variable name got reverted during the asciidoc update and slipped
> through, sorry for that.

No problem, it is not a big deal.

> > --- a/Documentation/Makefile
> > +++ b/Documentation/Makefile
> > @@ -56,7 +56,7 @@ ifneq ($(findstring $(MAKEFLAGS),s),s)
> >  ifndef V
> >  	QUIET_ASCIIDOC	=3D @echo '   ' ASCIIDOC $@;
> >  	QUIET_XMLTO	=3D @echo '   ' XMLTO $@;
> > -	QUIET_GZIP	=3D @echo '   ' GZIP $@;
> > +	QUIET_GZIP	=3D @echo '   ' GZIPCMD $@;
>=20
> JFYI, I've removed this change so the output stays the same.
>=20
> I've assembled a branch containing doc-only fixes, including this one,
> and asked Chris do do a 3.14.3 release.

Thanks.
Though I would be fine if this just goes into the next regular release.
--=20
Schoene Gruesse
Chris
                         O< ascii ribbon campaign
                   stop html mail - www.asciiribbon.org

--Sig_/R5=M4c9u.gAi4qmVrYdqT/.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjbfLAAoJEFTtyRYJvJGDK3sQAIiFi7ZiP0YsNtc+sLbrwsSx
4YRCYZkPhlqNBrUTDWYH32Yi7S+g5BydG1TeZ0EBXxUsrcRPoAjtz8ubug+BFido
k+GhoNMRxrAHpxusCjGmLkjOl+YoS4AAxorlgkJQTQBpjs9CQePHDaEU0ejzRy4y
JMSXkYGvBwrgx19wWkwJvn7CR1IFS6IV4g/oYX3cfT1Bi+qlGhw+Y1BrgrHVxxe3
FO7gwuZ9CzoyzKfHmK1Dy3fqQTC4E3yf6kg1fuo79VXCTB/hd+jlHVpp0fmMq4/6
ke2xOSdyEAk1f9Hp7pzvEl1RjK2bcCybB+ADZq66mfAGFn8peVTIkF0X/47mnfGb
C2hLL+4U+zIEunfiDHfe5u3CZWxhjti+izT98atbqM2CAGboPU6KKbxzW2wseovz
8TJsd1EfaLwn9QB7WeuZ0zYPZZkhXwm5sZzj3OwirQqZnxpXSlOdHdEft1z3lRq2
JcedB6pvss2Ub4mUcPtYx7RqDLgid7j99OSOJHFFRKVbOHpw8tdRe/Wn6U0jvxBc
fiz1x64irKEL7dLq+ephTwb13WdCHYfyS/EQtpR6lxxSpxsf1oD73MA2Pgsz7BOE
nzxxzR+lKj64ndxCeCqb9XwYOIIjBZ3LzgrbbpIscrTi0md75O2HJTbK6PULMjPO
FAWBxHp/Tb2iWcvIuN6h
=d2tD
-----END PGP SIGNATURE-----

--Sig_/R5=M4c9u.gAi4qmVrYdqT/.--
