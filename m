From: "Matthias G. Eckermann" <mge@suse.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 19:38:37 +0200
Message-ID: <20110817173837.GA29509@suse.com>
References: <4E4B2452.9070407@oracle.com>
 <20110817140433.GA32261@hendrix.borisch.local>
 <4E4BD53A.7080708@pacific.net>
Reply-To: "Matthias G. Eckermann" <mge@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Ken A <ka@pacific.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4BD53A.7080708@pacific.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-08-17 T 09:50 -0500 Ken A wrote:

> and much easier

but less powerful:-)

> than trying to get snapper to compile on fedora libblocxx
> ?  :-)

Ah, sure. Sorry.  Packages for "blocxx" for:
	Fedora_14 	Fedora_15 =09
	RHEL-5		RHEL-6 =09
	SLE_11_SP1 =09
	openSUSE_11.4	openSUSE_Factory

are available in the openSUSE buildservice at:

	http://download.opensuse.org/repositories/home:/mge1512:/snapper/

See also the build project at:

	https://build.opensuse.org/project/show?project=3Dhome%3Amge1512%3Asna=
pper

If someone sends the packaging files for Debian/Ubuntu,
I can also add those.

so long -
	MgE

P.S.:	I also added "snapper" itself there. I am not sure though,
	if it will build out of the box. ... Stay tuned.

--=20
Matthias G. Eckermann     Senior Product Manager   SUSE=C2=AE Linux Ent=
erprise
SUSE LINUX Products GmbH  Maxfeldstra=C3=9Fe 5          90409 N=C3=BCrn=
berg Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer, HRB 16746 (AG N=C3=
=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
