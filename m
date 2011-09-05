From: =?ISO-8859-1?Q?Bj=F6rn_Kalkbrenner?= <terminar@cyberphoria.org>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 05 Sep 2011 14:20:04 +0200
Message-ID: <4E64BE74.7040000@cyberphoria.org>
References: <4E64A0C5.2060409@cyberphoria.org> <20110905103033.GL9907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905103033.GL9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Thank you Hugo for your answers, but i have an update.

"It's dead Jim."

When i tried to mount subvolid=3D0 to a temporary folder i got a kernel
segfault and a BUG line in btrfs kernel code somewhere (reproducable),
after a reboot all volumes are broken, can't be mounted anymore...
btrfsfsck gave me inode errors on subvol 256 (my home).
mount does nothing but sleep/hang...

Now i am trying to restore my system and home from a backup to a new
harddrive, without btrfs at the moment...

I think my question 6 is now answered: it's completely broken.

Bye
Bj=F6rn

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
