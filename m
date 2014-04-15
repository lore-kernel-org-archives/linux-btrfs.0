Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaDOSER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 14:04:17 -0400
Date: Tue, 15 Apr 2014 11:04:15 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
Message-ID: <20140415180415.GF7901@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com> <20140415172800.GD7901@wotan.suse.de> <CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com> <20140415174121.GE7901@wotan.suse.de> <CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 06:57:17PM +0100, Filipe David Manana wrote:
> >> > Are these changes compatible with software using the old stream version? We
> >> > have snapshotting tools that are using send/recieve and it would be bad to
> >> > change the ABI in incompatible ways underneath them.
> >> >         --Mark
> >>
> >> New versions of btrfs-progs (send stream v2 support) will still be
> >> able to read and process v1 streams. Older btrfs-progs (v1 only) won't
> >> be able to process the new commands.
> >> Does this answers your question Mark?
> >
> > Yes it does thanks. Unfortunately though this is unacceptable behavior -
> > kernel upgrades are not supposed to break existing userspace interfaces.
> >
> > In particular what will happen here is that the user will grab a new kernel
> > and then find out that their fancy snapshotting software won't work any
> > more.
> 
> Good point. I followed this approach based on Josef's comments on a
> previous rfc at http://www.spinics.net/lists/linux-btrfs/msg32999.html

Apparently Josef doesn't get those sorts of bugs in his queue ;)


> The only alternative I can think of right now is to use new send ioctl
> flags instead, so that new clients able to process the new commands
> will pass these flags explicitly, while old clients would continue to
> work without changes (and not bumping the stream version, as
> btrfs-receive refuses versions higher than 1 currently). This seems to
> be similar to what was done here:
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=cb95e7bf7ba481c3d35b238b1cd671b63f54238a

Yeah that works for me - any client that understand the new features just
sends some flag that indicates it can process them. Then we know that old
clients will continue to work unaffected.

Thanks Filipe,
	--Mark

--
Mark Fasheh
