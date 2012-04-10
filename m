From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Snapper packages for Ubuntu
Date: Tue, 10 Apr 2012 17:37:38 +0700
Message-ID: <CAG1y0sdbtPB+9MxmzTuBD3kSe18kaU-fkfutNCg97jXHaQeCjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arvin Schnell <aschnell@suse.de>,
	"Matthias G. Eckermann" <mge@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've created snapper packages for Ubuntu, available on
https://launchpad.net/~snapper/+archive/stable. For those new to
snapper, it's a tool for managing btrfs snapshots
(http://en.opensuse.org/Portal:Snapper). It depends on libblocxx
available from https://launchpad.net/~bjoern-esser-n/+archive/blocxx ,
and currently uses git source up to commit 50dec40. I've done some
limited testing and it seems to to work correctly so far.

There's a small, distro-independent patch needed for it to work
correctly though. I'm sending it as a separate mail.

@Arvin, @MGE, I don't know the correct list for snapper development so
I'm cc-ing you both. If there's a dedicated list for snapper please
let me know and I'll post further updates there.

-- 
Fajar
