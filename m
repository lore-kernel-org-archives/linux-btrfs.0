From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH] Btrfs: change how we mount subvolumes
Date: Fri, 4 Dec 2009 19:49:11 +0100
Message-ID: <200912041949.12320.kreijack@alice.it>
References: <20091204173827.GB5962@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091204173827.GB5962@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef

On Friday 04 December 2009, Josef Bacik wrote:
> This work is in preperation for being able to set a different root as the
> default mounting root.
> 
> There is currently a problem with how we mount subvolumes.  We cannot 
currently
> mount a subvolume of a subvolume, you can only mount subvolumes/snapshots of 
the
> default subvolume.  So say you take a snapshot of the default subvolume and 
call
> it snap1, and then take a snapshot of snap1 and call it snap2, so now you 
have
> 
> /
> /snap1
> /snap1/snap2
> 
> as your available volumes.  Currently you can only mount / and /snap1, you
> cannot mount /snap1/snap2.  To fix this problem instead of passing 
subvol=<name>
> you must pass in subvol=<treeid>, where <treeid> is the tree id that gets 
spit
> out via the subvolume listing you get from the subvolume listing patches
> (btrfsctl -l).  This allows us to mount /, /snap1 and /snap1/snap2 as the 
root
> volume.
>

Nice feature.
But only for clarification purpose I have to correct you: the only limit of 
the "subvol=" mount option is that the "volume name" or "snapshot name" have 
to be under the root of the "btrfs" filesystem (or if you prefer under the 
root of the "." volume).
So:
- a subvolume created under / may be mounted using the subvol= mount option
- a subvolume created under a directory *can't* be mounted using the subvol= 
mount option
- a subvolume created under a directory and moved under "/" *may* be mounted 
using the subvol= mount option
- a snapshot of a subvolume created under / may be mounted using the subvol= 
option
And so...

(As side note: a subvol may be renamed/moved with a simple "mv" command.)

In fact the "subvol=" mount option related code, search in the root of the 
btrfs a subvolume/snapshot named as required, then mount it. Doesn't matter if 
it is a snapshot of a subvolume or where it is originally created.

In any case I like your idea.

BR
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
