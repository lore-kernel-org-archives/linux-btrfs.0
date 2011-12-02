From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: btrfs and load (sys)
Date: Fri, 2 Dec 2011 05:14:27 +0100
Message-ID: <CAJ1PRS=GGMtAsNaLyvOWL-nuRr6x1e2pj56hDqZWDFo60yNm9Q@mail.gmail.com>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
	<4ECD26F0.501@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECD26F0.501@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

I've upgraded to newest kernel 3.1.2 but problem is not fixed. After
reboot btrfs works fine to maybe few hours but after that system stats
to choke on sys load, system becames unresponsive, and backups to
btrfs becames extremly slow. Anything you want me to check so you can
diagnose the problem - before I will return to ext4?

blue on graph is sys load. It should not be visible at all. Something
is seriously wrong with btrfs
http://img265.imageshack.us/img265/1416/37248826.png

I use snapshots for every important directory (after each backup) so
there quite lot of them but this is a reason why I use btrfs.

# btrfs sub list /backup|wc -l
7651
