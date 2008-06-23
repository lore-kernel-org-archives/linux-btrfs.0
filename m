From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: kernel BUG at volumes.c:1705
Date: Mon, 23 Jun 2008 08:49:58 -0600
Message-ID: <485FB816.1020801@gentoo.org>
References: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>	 <1213320815.10187.336.camel@think.oraclecorp.com>	 <3d08dbff0806140222w677896e3s4835524e3d796794@mail.gmail.com>	 <1213618813.10187.387.camel@think.oraclecorp.com>	 <3d08dbff0806180158o6718d3acy34ae5c48a23ad9f8@mail.gmail.com>	 <1213792851.10187.420.camel@think.oraclecorp.com>	 <485CCB69.8050500@gmail.com> <1214231921.10187.553.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Thomas Lindroth <thomas.lindroth@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1214231921.10187.553.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Something in your config is much less stable than my test boxes here.
> Focusing on the dd test, it looks like random corruption in the FS
> metadata.  I see you've got gentoo i386 and a 2.6.24 kernel, are there
> any other patches in that kernel?

I have used Gentoo's 2.4.26 with btrfs (0.15) for a while now - no
issues.  Are you using the official ebuilds?  Note that the latest
contains the 0.15 hotfix.

					-Joe
