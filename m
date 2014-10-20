Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaJTWN6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 18:13:58 -0400
Date: Tue, 21 Oct 2014 06:12:52 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Filipe Manana <fdmanana@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs for stable (mostly 3.17)
Message-ID: <20141020221252.GA2101@kroah.com>
References: <54438BEC.4090708@fb.com>
 <20141019195511.GB1191@kroah.com>
 <20141019231315.GA9846@kroah.com>
 <5444FE7E.8000608@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5444FE7E.8000608@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 20, 2014 at 01:22:22PM +0100, Filipe Manana wrote:
> 
> 
> On 10/20/2014 12:13 AM, Greg KH wrote:
> > On Sun, Oct 19, 2014 at 09:55:11PM +0200, Greg KH wrote:
> >> On Sun, Oct 19, 2014 at 06:01:16AM -0400, Chris Mason wrote:
> >>> Hi everyone,
> >>>
> >>> I've pulled out some of the btrfs commits from the merge window that
> >>> we'd like to see in stable.  The full list of sha's from Linus is below,
> >>> you can see 4 of them are only needed on 3.17
> >>>
> >>> 2fad4e83e12591eb3bd213875b9edc2d18e93383
> >>> 0b4699dcb65c2cff793210b07f40b98c2d423a43 # v3.17
> >>> 12b894cb288d57292b01cf158177b6d5c89a6272
> >>> 78a017a2c92df9b571db0a55a016280f9019c65e
> >>> 4d1a40c66bed0b3fa43b9da5fbd5cbe332e4eccf
> >>> e6c4efd87ab04e5ead363f24e6ac35ed3506d401 # v3.17
> >>> f6acfd50110b335c7af636cf1fc8e55319cae5fc
> >>> 1d52c78afbbf80b58299e076a159617d6b42fe3c
> >>> 75bfb9aff45e44625260f52a5fd581b92ace3e62
> >>> bbe9051441effce51c9a533d2c56440df64db2d7
> >>> 32be3a1ac6d09576c57063c6c350ca36eaebdbd3 # v3.17
> >>> 42383020beb1cfb05f5d330cc311931bc4917a97
> >>> d37973082b453ba6b89ec07eb7b84305895d35e1 # v3.17
> >>
> >> I'm confused, the others not marked with a "# v3.17" need to go on older
> >> kernels as well?
> > 
> > I've picked up the ones that apply and build for the older stable
> > kernels I maintain now, thanks for the list.
> 
> May I suggest porting the following commit to 3.14 too?
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=766b5e5ae78dd04a93a275690a49e23d7dcb1f39
> 
> It fixes a data corruption issue for an incremental send. Particularly
> important, IMHO, as the corruption happens silently (no errors returned
> to user space nor any sort of warnings/errors in syslog, etc). It
> affects only 3.14, and the change applies cleanly on 3.14.22.

Chris, any objection for me taking this?

thanks,

greg k-h
