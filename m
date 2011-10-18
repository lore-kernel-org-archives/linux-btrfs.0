From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 1/2][BTRFS-PROGS] add the "--force" switch to the mkfs.btrfs command
Date: Tue, 18 Oct 2011 18:56:23 +0200
Message-ID: <1414589.dmrVp4WbBA@venice>
References: <CAKcLGm8nBmFZOgs4cxAz7qBfyWZne-VX7rhSxA6c0yd4eDTERA@mail.gmail.com> <7496499.QeRia36pgE@venice>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7496499.QeRia36pgE@venice>
List-ID: <linux-btrfs.vger.kernel.org>

I forgot to mention that you can pull these changes from the following 
repository:

	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

branch

	force-mkfs

Of course these patches are re-based on the latest Hugo's integration 
(integration-20111012)


BR

On Tuesday, 18 October, 2011 18:45:13 Goffredo Baroncelli wrote:
> As requested by Mitch, I resend the patch related to the "--force" option
> for the mkfs.btrfs command.
> 
> This patch allow to bypass the check which ensure that you are formatting a
> not mounted partition/disk.
> Sometime (eg in a chrooted environment where the /proc filesystem is not
> mounted ) you don't have all the information, and the check fails even if
> the device is not mounted.
> 
> Passing the --force|-f flag to the mkfs.btrfs command you bypass this check.
> 
> This patch update the mkfs.c program.
> 
> On Monday, 17 October, 2011 15:11:15 you wrote:
> > Goffredo:
> > 
> > I was wanting to see if your mkfs.btrfs --force patches could get
> > picked up in the Btrfs-progs testing tree that Hugo Mills is trying to
> > maintain.
> > 
> > He was OK with the patches, but was hoping for a 'signed-off-by' and
> > more description in the commit comment.
> > 
> > Could you resend your patches to the list with a 'signed-off-by' and
> > some additional description?
> > 
> > Some suggested text for the comment:
> > 
> > Certain operating environments (such as a chroot environment) can lead
> > to mkfs.btrfs failure while checking devices (particularly when all
> > devices are not fully described in /dev).
> > 
> > The --force option skips device checking, and forces formating on the
> > specified target.
> > 
> > Thanks.
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
