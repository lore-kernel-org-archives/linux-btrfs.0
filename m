Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:51643 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2FTTiW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 15:38:22 -0400
Date: 20 Jun 2012 21:15:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CBFXBeteCXB@helmut.hullen.de>
In-Reply-To: <4FE21134.9090501@libero.it>
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 20.06.12:

[...]

> Am not saying that we *should* move the kernel away from /boot. I am
> only saying that having the kernel near /lib/modules *has* some
> advantages.

> Few year ago there are some gains to have a separate /boot (ah, the
> time when the bios were unable to address the bigger disk), where
> there are the minimum things to bootstrap the system.

> Now we have the possibility to move the kernel near the modules, and
> this could lead some interesting possibility: think about different
> linux installations, with an own kernel version and an own modules
> version; what are the reasons to put together under /boot different
> kernel which potential conflicting names ?

Where is the big problem?
I use separate subdirectories for different kernels, p.e. "/boot/ 
2.6.38.4" or "/boot/3.3.4" or "/boot/3.3.4-big". And these subdirs  
contain (p.e.) ".config", "vmlinuz", "initrd", "System.map".

It's a very clear design. No incredibly long filenames.

Viele Gruesse!
Helmut
