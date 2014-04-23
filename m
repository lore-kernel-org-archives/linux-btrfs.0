Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39272 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWTPr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 15:15:47 -0400
Date: Wed, 23 Apr 2014 12:15:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Message-ID: <20140423191546.GG26949@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2014 at 10:06:12PM +0300, Пламен Петров wrote:
> Just to clarify - I am using a monolithic kernel built from source, and it has all the stuff it needs to support built-in, and then some. And no modules.
> The sources I'm using are the vanilla kernels from Linus and Greg KH downloaded from kernel.org.

Ok.
 
> Check out the attached config I am using - it’s a kernel I'm running on one server and a couple of virtual machines.

That's the working .config.
I suggest you diff that one with the new one you have for 3.14
 
> Until now - copying said config and doing a "make oldconfig" or "make olddefconfig" and compiling-then-booting worked fine.

This should indeed work, this is what I do too.

So now, we're kind of guessing. To save us all time, could you capture a
serial console boot from the running 3.13 and then the failing 3.14.

My guess is that if you diff both you'll likely find what went wrong, but if
not you can post here.

As for the btrfs FS format, it has not changed in a way that new kernels
wouldn't be able to mount an FS from a year ago or more.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
