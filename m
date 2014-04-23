Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40221 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbaDWU6U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 16:58:20 -0400
Date: Wed, 23 Apr 2014 13:58:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Message-ID: <20140423205819.GH26949@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2014 at 10:37:44PM +0300, Пламен Петров wrote:
> > So now, we're kind of guessing. To save us all time, could you capture a serial
> > console boot from the running 3.13 and then the failing 3.14.
> 
> Well, for the details - see for example here:
> https://bugzilla.kernel.org/attachment.cgi?id=133111
> how does a 3.14.1 built the way described earlier fails.
 
Thanks, that helps.
Except, now I'm perplexed.

It indeed shows btrfs loaded and your block device being detected.
However it does not show a btrfs mount error.

I haven't had to debug this in a while, but I'm wondering if you're having a
block device problem.

It may help to look up what error -38 translates into for that mount error.

> And for that matter - see the whole bugzilla bug entry - I went on and bisected this, using the linux-stable git tree, and after that landed me on the commit that introduces some "shiny new btrfs feature" for 3.14 - I decided my git bisection has gone wrong. And because I reported it on April 17-th and since then there has been no activity on the bugzilla entry besides me updating it - I posted my problem here, for more eyes to see.
 
One easier way to debug this would be to create an initrd for 3.13 and 3.14.
Make sure it works with 3.13 first, then boot 3.14 and see what error you
get.
You'll get an error from mount(8) and not the kernel and you'll be dropped
to a shell, giving you more debug options.

> > My guess is that if you diff both you'll likely find what went wrong, but if not
> > you can post here.
> 
> See the result of "diff config-v3.14.1-mix64 config-v3.13.11-mix64" in the attached file.

diff -u is your friend ;)
but diff looks reasonable.

> > As for the btrfs FS format, it has not changed in a way that new kernels
> > wouldn't be able to mount an FS from a year ago or more.
> 
> Good to know! Thanks!

Of course, that doesn't mean you didn't find a bug saying otherwise.

If you try from an initrd, it'll make it easier to debug. You don't have to
build a new kernel or make btrfs a module, just mounting a working initrd
and then trying this again with userland tools will help debug.
(alternatively, rescue boot media with your kernel would work too, but
that's likely more work to build than an initrd)
Actually, you could also use your VM setup to boot another linux image
running ext4 as root with your new kernel, setup your existing drive as sdb,
and try to mount it then.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
