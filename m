Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3ARVoz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 16:44:55 -0500
Date: Fri, 18 Jan 2013 13:44:53 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Arne Jansen <lists@die-jansens.de>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        ablock84@googlemail.com, aschnell@suse.de, Anand.Jain@oracle.com
Subject: Re: [PATCH 0/4] btrfs-progs: better support for external users of
	send, V2
Message-ID: <20130118214453.GW12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1358375408-25285-1-git-send-email-mfasheh@suse.de> <50F79C81.4050100@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F79C81.4050100@die-jansens.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 17, 2013 at 07:38:57AM +0100, Arne Jansen wrote:
> Splitting out the send/receive-specific parts into a lib is a great idea.
> The original motivation behind our send stream format was to make it readily
> receivable on different filesystems.

Oh ok cool. I didn't actually know that it was meant to be used across
multiple file systems. Seems like a pretty neat feature to me :)


> For this we need a generic receiver which could be based on the lib. But to
> make this possible, all btrfs-specific parts need to be kept out of it, so
> it can readily compile on BSD for example.
> So it might make sense to split out 2 parts, one for the pure receive
> functionality and one with the btrfs-specific parts.
> The former lib could be named libfar, as this is the name we want to give
> the stream format to make it independent from btrfs. FAR stands for
> Filesystem Agnostic Replication. There are senders for other systems (especially
> zfs) in preparation.
> I don't know if this affects your efforts in any way, but it might be easiest
> to do the split right away while you're at it :)

Hmm, splitting into two libs isn't really that hard or anything but the real
work (as you note) would be in making it compile in other places. Honestly,
I think that could be built right on top of these patches but I don't feel
that it's within the scope of my current series.
	--Mark

--
Mark Fasheh
