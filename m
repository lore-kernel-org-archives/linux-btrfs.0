Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaJVGYW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 02:24:22 -0400
Date: Wed, 22 Oct 2014 14:23:14 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Mason <clm@fb.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs for stable (mostly 3.17)
Message-ID: <20141022062314.GA11748@kroah.com>
References: <20141020221252.GA2101@kroah.com>
 <1413919149.13632.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413919149.13632.0@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 21, 2014 at 03:19:09PM -0400, Chris Mason wrote:
> 
> 
> On Mon, Oct 20, 2014 at 6:12 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >On Mon, Oct 20, 2014 at 01:22:22PM +0100, Filipe Manana wrote:
> >
> >> May I suggest porting the following commit to 3.14 too?
> >>
> >>https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id%3D766b5e5ae78dd04a93a275690a49e23d7dcb1f39&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=4HB2GrskctbPsSOzamEf9hTilGJUhvqoPLn0LWCzaTI%3D%0A&s=c55d2716c1968c22c220de980059a704c31aa637a7036e25909da9cc960bd0f4
> >>
> >> It fixes a data corruption issue for an incremental send. Particularly
> >> important, IMHO, as the corruption happens silently (no errors returned
> >> to user space nor any sort of warnings/errors in syslog, etc). It
> >> affects only 3.14, and the change applies cleanly on 3.14.22.
> >
> >Chris, any objection for me taking this?
> 
> On vacation, sorry for the lag.  Please do take this one too.  Thanks
> Filipe.

Great, now applied.

greg k-h
