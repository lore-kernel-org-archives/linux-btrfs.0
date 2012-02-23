From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 23 Feb 2012 16:54:06 +0700
Message-ID: <CAG1y0sdhm03Pqi+j2Z00MS+p5CMQav=r0c7LahNpjJRv+rEQmw@mail.gmail.com>
References: <4E4B2452.9070407@oracle.com>
	<20110817140433.GA32261@hendrix.borisch.local>
	<4E4BD53A.7080708@pacific.net>
	<20110817173837.GA29509@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Matthias G. Eckermann" <mge@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817173837.GA29509@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 18, 2011 at 12:38 AM, Matthias G. Eckermann <mge@suse.com> =
wrote:
> Ah, sure. Sorry. =A0Packages for "blocxx" for:
> =A0 =A0 =A0 =A0Fedora_14 =A0 =A0 =A0 Fedora_15
> =A0 =A0 =A0 =A0RHEL-5 =A0 =A0 =A0 =A0 =A0RHEL-6
> =A0 =A0 =A0 =A0SLE_11_SP1
> =A0 =A0 =A0 =A0openSUSE_11.4 =A0 openSUSE_Factory
>
> are available in the openSUSE buildservice at:
>
> =A0 =A0 =A0 =A0http://download.opensuse.org/repositories/home:/mge151=
2:/snapper/
>

Hi Matthias,

I'm testing your packages on top of RHEL6 + kernel 3.2.7. A small
suggestion, you should include /etc/sysconfig/snapper in the package
(at least for RHEL6, haven't tested the other ones). Even if it just
contains

SNAPPER_CONFIGS=3D""

Thanks,

=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
