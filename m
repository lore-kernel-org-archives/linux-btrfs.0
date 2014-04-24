Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:54148 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757473AbaDXRo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 13:44:26 -0400
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org>
In-Reply-To: <20140424173317.GI7884@merlins.org>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Thu, 24 Apr 2014 20:44:06 +0300
Message-ID: <000a01cf5fe4$ca59aad0$5f0d0070$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Marc MERLIN [mailto:marc@merlins.org]
> Sent: Thursday, April 24, 2014 8:33 PM
> To: Пламен Петров
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
> newer?
> 
> On Thu, Apr 24, 2014 at 08:19:21PM +0300, Пламен Петров wrote:
> > I just realized that the l gave no way for identifying the particular bugzilla
> entry. Here it is:
> > https://bugzilla.kernel.org/show_bug.cgi?id=74261
> 
> Thanks.
> 
> But to save us a lot more speculation, can you please try booting a linux
> system (either initrd, or another one with a non btrfs root), and then trying
> to mount that filesystem from the command line?

Using 3.14.1 perhaps?

I will try to do that now, but if I can't manage to do it today - expect the results tomorrow.

One more detail I managed to rule out today is that my problematic filesystems used subvol-other-than-root as default, made like so:

$ mount /dev/sda2 /sda2 -o relatime,compress=zlib,subvol=system-main-fs 
$ btrfs subvolume set-default system-main-fs /sda2

Only using different name for the subvolume.
Anyway - its irrelevant.
I formatted a fresh root as BTRFS, skipped the above, and tried booting 3.14.1 - result was kernel panic. So different default subvolume or not - its not the problem.
---------------------------------
Plamen Petrov

