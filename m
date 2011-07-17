From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: corruption. notreelog has no effect? anything else to try?
Date: Sun, 17 Jul 2011 07:26:48 +0700
Message-ID: <CAG1y0scfEzgVCPTwD-tQTp=euWrUJn5wx36VY2cSGSHnZboPbA@mail.gmail.com>
References: <1310763102.3972.31.camel@ubuntu>
	<CAG1y0sc-D1-5zkgsovtZG6emOc78GoZ64gQ1Lhufm=6Z3huEAg@mail.gmail.com>
	<1310862500.6144.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310862500.6144.4.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 17, 2011 at 7:28 AM, Mck <mick@wever.org> wrote:
> Knowing very little about zero-log and select-super should i continue
> using my laptop like normal now?
> Or is this filesystem still considered corrupt and i should backup and
> format it all from scratch?

This is my guess:
- since you clear the log, there might be corruption on files that you
worked on when the crash occured.
- since btrfs uses cow, snapshots created (and not being accessed)
before the crash should be fine
- check syslog for weird logs

If no new error log comes up, and the files you're working on before
are intact, I'd just keep on using it.

-- 
Fajar
