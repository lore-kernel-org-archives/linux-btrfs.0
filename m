From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [RFC][BTRFS-PROG] Avoid to scan cdrom and floppy
Date: 16 Jun 2011 17:09:00 +0200
Message-ID: <Bn+os9hi1uB@helmut.hullen.de>
References: <4DFA1A91.5020406@redhat.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFA1A91.5020406@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Josef,

Du meintest am 16.06.11:

>>> Who the hell doesn't use udev?

>> Me - p.e.
>> "udev" may be interesting for desktop users, for multimedia
>> computers. It's not necessary for a simple server, for a machine
>> where the administrator wants to rule instead of "udev".

> You don't need udev to use btrfs, I've just not seen a distro that
> allows you to not run with udev, so my question is more curiosity
> than anything.

But the developers seem to use only machines where "udev" runs.

p.e. when testing the disks (I've told this bug about 1 year ago), p.e.  
with "/dev/btrfs-control".

"btrfs-control" has to exist before btrfs is started, and there is  
neither a hint in the documentation nor a check.

Viele Gruesse!
Helmut
