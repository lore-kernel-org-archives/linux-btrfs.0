From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: Problem with latest for-linus branch
Date: Tue, 31 May 2011 20:15:23 +0200
Message-ID: <BANLkTimDg5-RQV1BHiONViZM5ZZWsnFAZg@mail.gmail.com>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
	<1306620858-sup-7865@shiny>
	<BANLkTi=FPw7RwkPW0zpD05YRtt19NrZ-5A@mail.gmail.com>
	<1306751696-sup-7618@shiny>
	<BANLkTimDsRC6yNJ0R5kbBdtTyBAmcf0FfA@mail.gmail.com>
	<1306762449-sup-979@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306762449-sup-979@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/30 Chris Mason <chris.mason@oracle.com>:
> Ok, so I think we're blowing past the end of the page we've kmap'd. =C2=
=A0But
> I don't think that can happen without something like the patch below
> triggering:

Quick update: after rm of ~10 GB of data, I rebooted with Linus' latest
git tree, and it works (after some minutes of btrfs-ino-cache).

Ciao,
Andrea
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
