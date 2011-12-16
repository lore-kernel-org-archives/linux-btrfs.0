From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: speeding up slow btrfs filesystem
Date: Fri, 16 Dec 2011 19:38:32 +0100
Message-ID: <4906354.Rn8tlOeHyD@venice>
References: <201112161851.52011.Martin@lichtvoll.de> <201112161854.46717.Martin@lichtvoll.de>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112161854.46717.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 16 December, 2011 18:54:46 you wrote:
> Am Freitag, 16. Dezember 2011 schrieb Martin Steigerwald:
> > Its not critical for me to fix these issues (soon), but I am curious
> > whether its possible to get the filesystem speedier by some
> > maintenance.
> 
> Maybe after it is clear why it is so slow in the first place ;).

I had the same experience. apt-get upgrade was a frustrating experience!

IIRC the copy-on-write file-system in order to have good performance have to 
merge the write requests most as possible.

Instead apt-get makes a lot of sync calls which don't allow btrfs to merge the 
write requests. This explains why btrfs is slow in this case.

I found a solution, but requires a bit of setup.

The idea is to avoid do perform sync during the package installation. In order 
to avoid data loss in case of failure, I create a snapshot before the 
upgrading. If something goes wrong (i.e. a power failure) I rebooot the system 
from the snapshot. If the installation finish without problem, I flush all the 
data to the disk and remove the snapshot.

For the detail, see a my old post titled "[RFC] aptitude & BTRFS slow" 
(2011-10-19)

BR
G.Baroncelli




-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
