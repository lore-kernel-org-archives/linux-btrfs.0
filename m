Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaDORlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 13:41:22 -0400
Date: Tue, 15 Apr 2014 10:41:21 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
Message-ID: <20140415174121.GE7901@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com> <20140415172800.GD7901@wotan.suse.de> <CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 06:34:38PM +0100, Filipe David Manana wrote:
> On Tue, Apr 15, 2014 at 6:28 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> > On Tue, Apr 15, 2014 at 05:40:18PM +0100, Filipe David Borba Manana wrote:
> >> This increases the send stream version from version 1 to version 2, adding
> >> 2 new commands:
> >>
> >> 1) total data size - used to tell the receiver how much file data the stream
> >>    will add or update;
> >>
> >> 2) fallocate - used to pre-allocate space for files and to punch holes in files.
> >>
> >> This is preparation work for subsequent changes that implement the new features
> >> (computing total data size and use fallocate for better performance).
> >
> > Are these changes compatible with software using the old stream version? We
> > have snapshotting tools that are using send/recieve and it would be bad to
> > change the ABI in incompatible ways underneath them.
> >         --Mark
> 
> New versions of btrfs-progs (send stream v2 support) will still be
> able to read and process v1 streams. Older btrfs-progs (v1 only) won't
> be able to process the new commands.
> Does this answers your question Mark?

Yes it does thanks. Unfortunately though this is unacceptable behavior -
kernel upgrades are not supposed to break existing userspace interfaces.

In particular what will happen here is that the user will grab a new kernel
and then find out that their fancy snapshotting software won't work any
more.
	--Mark

--
Mark Fasheh
