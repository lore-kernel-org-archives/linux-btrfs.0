From: Chris Mason <chris.mason@oracle.com>
Subject: Re: lots of kernel threads
Date: Wed, 25 Feb 2009 12:51:03 -0500
Message-ID: <1235584263.32346.10.camel@think.oraclecorp.com>
References: <7a329d910902242009k6ae3fff7t8711ebc1a8bafea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7a329d910902242009k6ae3fff7t8711ebc1a8bafea8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-24 at 20:09 -0800, Wil Reichert wrote:
> I'm a Gentoo user and figured mounting /usr/portage & /var/portage
> (distfiles, packages, persistent stuff normally in /usr/portage) and
> /tmp moiunted as btrfs.  I figured it would be a decent test & its
> nothing I cann't replace readily.  After about 6 hours of uptime and a
> couple package merges, I checked ps aux & am getting the following:
> 

Btrfs has a number of thread pools per mounted filesystem.  It makes
sense to switch the thread pools to be more global, but for right now
these threads are not unusual.

Kernel threads are lightweight enough that the only major downside to
these is making ps output ugly ;)

-chris


