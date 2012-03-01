From: Arvin Schnell <aschnell@suse.de>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 1 Mar 2012 14:48:17 +0100
Message-ID: <20120301134817.GA15719@suse.de>
References: <4E4B2452.9070407@oracle.com> <20110817140433.GA32261@hendrix.borisch.local> <4E4BD53A.7080708@pacific.net> <20110817173837.GA29509@suse.com> <CAG1y0sdhm03Pqi+j2Z00MS+p5CMQav=r0c7LahNpjJRv+rEQmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdhm03Pqi+j2Z00MS+p5CMQav=r0c7LahNpjJRv+rEQmw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 23, 2012 at 04:54:06PM +0700, Fajar A. Nugraha wrote:
> On Thu, Aug 18, 2011 at 12:38 AM, Matthias G. Eckermann <mge@suse.com=
> wrote:

> > are available in the openSUSE buildservice at:
> >
> > =A0 =A0 =A0 =A0http://download.opensuse.org/repositories/home:/mge1=
512:/snapper/
> >
>=20
> Hi Matthias,
>=20
> I'm testing your packages on top of RHEL6 + kernel 3.2.7. A small
> suggestion, you should include /etc/sysconfig/snapper in the package
> (at least for RHEL6, haven't tested the other ones). Even if it just
> contains
>=20
> SNAPPER_CONFIGS=3D""

Hi Fajar,

thanks for reporting that issue, I have fixed it now.

We have now created a project in the openSUSE buildservice were
we provide snapper packages for various distributions, e.g. RHEL6
and Fedora 16. Please find the downloads at:

  http://download.opensuse.org/repositories/filesystems:/snapper/

I'll also add a link from the snapper home page:

  http://en.opensuse.org/Portal:Snapper.

I have tested snapper on Fedora 16 and found no problems.

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
