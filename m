From: Arvin Schnell <aschnell@suse.de>
Subject: Re: Snapper packages for Ubuntu
Date: Tue, 10 Apr 2012 15:36:59 +0200
Message-ID: <20120410133659.GA14935@suse.de>
References: <CAG1y0sdbtPB+9MxmzTuBD3kSe18kaU-fkfutNCg97jXHaQeCjQ@mail.gmail.com> <20120410115022.GB24057@suse.de> <CAG1y0scsfBjVBAL8EQFKJGoR=Dm2K11E8MJLcmqq=gckb0kG2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scsfBjVBAL8EQFKJGoR=Dm2K11E8MJLcmqq=gckb0kG2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 08:08:15PM +0700, Fajar A. Nugraha wrote:
> On Tue, Apr 10, 2012 at 6:50 PM, Arvin Schnell <aschnell@suse.de> wro=
te:

> > libblocxx is not required for snapper anymore since about a
> > month. It's checked during configure.
>=20
> You're right. I just tested it, and not having libblocxx during
> compilation results in less dependencies (namely libblocxx itself,
> plus libssl, libcrypto, and libpcre).
>=20
> What functionality, if any, is not available when not using libblocxx=
?
> Since it's still used when present during configure, I assume it's
> good for something.

It's just used for logging. With blocxx an application linking
libsnapper can use blocxx functions to control and redirect
logging.

Regards,
  Arvin

--=20
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 16746 (AG N=FCrnberg)
Maxfeldstra=DFe 5
90409 N=FCrnberg
Germany
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
