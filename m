From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: btrfs and load (sys)
Date: Wed, 23 Nov 2011 16:17:08 +0100
Message-ID: <CAJ1PRS=McLBAqwkgJe10uF3706a-YncrpwOaUZ6+KQjOSCACCA@mail.gmail.com>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
	<20111123205616.73b4d0a7@natsu>
	<CAJ1PRSk4cker8WbSL5t9sKYde=f4XRAkQGQVYVC=8wnJKT8EwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSk4cker8WbSL5t9sKYde=f4XRAkQGQVYVC=8wnJKT8EwQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I see that this high sys load and loadavg did not appear gradualy. It
appeared first time about 7 days ago and were present every backup,
every night since then.

During backup top shows higher cpu load on

 4216 root      20   0     0    0    0 R 20.3  0.0 284:25.83 btrfs-delayed-m
 4222 root      20   0     0    0    0 D 19.6  0.0 203:23.89 btrfs-transacti

however one cannot really debug sys load so it does not tell much.
Scenario here is quite simple (rsync to working dir and then snapshot,
next night rsync (in place) to working dir and again snapshot). Rsync
is killed at 08:00.
I will try rebooting server this night but I doubt it will change
anything on those high loads during backup to btrfs partition.
