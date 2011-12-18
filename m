From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: speeding up slow btrfs filesystem
Date: Sun, 18 Dec 2011 19:41:49 +0100
Message-ID: <CAK-xaQY3ok3+PXBZXGiUWQv=N4zSYq2RYFy6KtMUrD1ggXp2VA@mail.gmail.com>
References: <201112161851.52011.Martin@lichtvoll.de> <201112161854.46717.Martin@lichtvoll.de>
 <4906354.Rn8tlOeHyD@venice>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4906354.Rn8tlOeHyD@venice>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/16 Goffredo Baroncelli <kreijack@inwind.it>:
> I found a solution, but requires a bit of setup.

Did you try:
echo force-unsafe-io >> /etc/dpkg/dpkg.cfg

You need dpkg 1.16.

Ciao,
Andrea
