From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH] Btrfs-progs: avoid to scan cdrom and floppy
Date: 11 Nov 2010 20:32:00 +0100
Message-ID: <B$fLyT0D1uB@helmut.hullen.de>
References: <201011112027.55875.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011112027.55875.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 11.11.10 zum Thema [PATCH] Btrfs-progs: avoid to scan cdrom and floppy:

> My patch changes the behaviour of these commands. The list of the
> devices are extracted from /proc/partitions, and on the basis of the
> file /etc/btrfs.devices some devices may be skipped.

> The file /etc/btrfs.devices contains a list of devices which have to
> be skipped (if the line starts with '!') or to be evaluated. Shell
> wildcard may be used.

Nice, very nice! Thank you!

Viele Gruesse!
Helmut
