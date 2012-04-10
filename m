From: Arvin Schnell <aschnell@suse.de>
Subject: Re: Snapper packages for Ubuntu
Date: Tue, 10 Apr 2012 13:50:22 +0200
Message-ID: <20120410115022.GB24057@suse.de>
References: <CAG1y0sdbtPB+9MxmzTuBD3kSe18kaU-fkfutNCg97jXHaQeCjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Matthias G. Eckermann" <mge@suse.com>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdbtPB+9MxmzTuBD3kSe18kaU-fkfutNCg97jXHaQeCjQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 05:37:38PM +0700, Fajar A. Nugraha wrote:
> Hi,
>=20
> I've created snapper packages for Ubuntu, available on
> https://launchpad.net/~snapper/+archive/stable. For those new to
> snapper, it's a tool for managing btrfs snapshots
> (http://en.opensuse.org/Portal:Snapper). It depends on libblocxx
> available from https://launchpad.net/~bjoern-esser-n/+archive/blocxx =
,
> and currently uses git source up to commit 50dec40. I've done some
> limited testing and it seems to to work correctly so far.

libblocxx is not required for snapper anymore since about a
month. It's checked during configure.

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
