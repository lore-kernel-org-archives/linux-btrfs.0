Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54055 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832Ab3EZCX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 22:23:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UgQcI-0004gv-AL
	for linux-btrfs@vger.kernel.org; Sun, 26 May 2013 04:23:26 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 04:23:26 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 04:23:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: compression on external hard drive?
Date: Sun, 26 May 2013 02:23:09 +0000 (UTC)
Message-ID: <pan$a1b3e$c3ed264b$c0ac127c$7262bed0@cox.net>
References: <51A1372B.6060402@gnata.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xavier Gnata posted on Sun, 26 May 2013 00:11:55 +0200 as excerpted:

> Nowdays, external hard drives are mounted automagically by kde, gnome or
> whatever else.
> How is it suppose to work with external hard drives using btrfs with
> compression?
> If a btrfs filesystem lzo-compressed is mounted without the
> |compress=|xxx option then all the newly created files are uncompressed,
> aren't then?
> Would it be possible to detect if a file system is compressed  and to
> mount it *automatically* and accordingly (except otherwise explicitly
> stated by the user) with/without the lzo/gzip option?

There's a proposal to do something like ext3/4's default options as set 
by tune2fs, at some point, presumably before btrfs loses the "unstable 
disk format" and under heavy development warnings.  However, there's 
nothing like that yet, AFAIK, so most options must be set per-mount.

There's a lot you can do with udev events, however, and strongly suspect 
either compression-detection, or match-against-a-list-and-compress (or 
don't compress if the default is compression otherwise) if the UUID/LABEL 
is listed.

Alternatively, at least kde can be set not to automount specific UUIDs/
LABELs, and then there's always the traditional fstab option, and I think 
either fstab entered drives are ignored by the automount system or 
they're automounted with options from fstab (I have that kde subsystem 
entirely disabled here so it doesn't automount anything, so I'm not sure 
which it actually does).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

