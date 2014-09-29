Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaI2OZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 10:25:34 -0400
Date: Mon, 29 Sep 2014 16:25:32 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs-progs releases
Message-ID: <20140929142532.GA11436@suse.cz>
Reply-To: dsterba@suse.cz
References: <53FC982B.9090608@fb.com>
 <CALOYprVLH2e4Ujp-iN6CTFzTVi1x4VwayRgpvQEkmwNBbNXEWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprVLH2e4Ujp-iN6CTFzTVi1x4VwayRgpvQEkmwNBbNXEWQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 18, 2014 at 10:38:03PM +0100, WorMzy Tykashi wrote:
> I was wondering if you could shed some light on the status of the
> integration branches. Are these going to be discontinued now that you
> are maintaining and tagging the official btrfs-progs releases, or will
> they stick around, serving a similar purpose as before?

The patch flow should stay as is for now, ie. integration branches at
the current repos. The kernel.org repo will serve as release repository
only.
