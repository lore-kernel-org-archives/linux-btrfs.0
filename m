Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60793 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3HWM6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 08:58:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Xavier Bassery <xavier@bartica.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: default mount options 3.10
Date: Fri, 23 Aug 2013 14:58:07 +0200
Message-ID: <4901822.EYC3h3vBSD@merkaba>
In-Reply-To: <20130823122942.18548b21@xavier-ThinkPad-T60p.lan>
References: <52172DB0.1000701@gmail.com> <20130823122942.18548b21@xavier-ThinkPad-T60p.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 23. August 2013, 12:29:42 schrieb Xavier Bassery:
> On Fri, 23 Aug 2013 11:38:56 +0200
> 
> David Kofler <dkofler92@googlemail.com> wrote:
> > Hi,
> > can someone tell me which mount options are included in "defaults"
> > mount option? Couldn't find this in BTRFS Wiki. I'm using Debian
> > Wheezy 7.1 and Linux kernel 3.10.6.
> > Thanks in advance.
> 
> Hi,
> you've looked at the wrong place.
> From mount man page:
> 
> FILESYSTEM INDEPENDENT MOUNT OPTIONS
> defaults : Use default options: rw, suid, dev, exec, auto, nouser, async
> 
> You can also have a look here [1].

That are just VFS options, no BTRFS specific ones.

A good way is to look at output of "mount" and "cat /proc/mounts". It can 
differ from situation as well, for example SSD or not.

But some hints at BTRFS default options are also on (search for "default"):

https://btrfs.wiki.kernel.org/index.php/Mount_options

I don´t know wether there is a complete documentation on the defaults.

> [1] https://wiki.debian.org/fstab#Field_definitions
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
