From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: speeding up slow btrfs filesystem
Date: Tue, 20 Dec 2011 20:46:03 +0100
Message-ID: <2604696.jerqPjI0hT@venice>
References: <201112161851.52011.Martin@lichtvoll.de> <4906354.Rn8tlOeHyD@venice> <CAK-xaQY3ok3+PXBZXGiUWQv=N4zSYq2RYFy6KtMUrD1ggXp2VA@mail.gmail.com>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAK-xaQY3ok3+PXBZXGiUWQv=N4zSYq2RYFy6KtMUrD1ggXp2VA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ciao Andrea,

On Sunday, 18 December, 2011 19:41:49 you wrote:
> 2011/12/16 Goffredo Baroncelli <kreijack@inwind.it>:
> > I found a solution, but requires a bit of setup.
> 
> Did you try:
> echo force-unsafe-io >> /etc/dpkg/dpkg.cfg

stracing an apt-get update, it seems that --force-unsafe-io doesn't stop all 
the sync command.

See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=613428

> You need dpkg 1.16.

# dpkg --version
Debian `dpkg' package management program version 1.16.1.2 (amd64).
This is free software; see the GNU General Public License version 2 or
later for copying conditions. There is NO warranty.



> 
> Ciao,
> Andrea
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
