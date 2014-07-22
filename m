Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaGVOP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 10:15:28 -0400
Date: Tue, 22 Jul 2014 16:15:26 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Unstable v3.15-rc tags
Message-ID: <20140722141526.GZ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALOYprVQDbA1jGgaMmJrM7tOJKRSpfgbHF88=ccaKLRzsNs7vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprVQDbA1jGgaMmJrM7tOJKRSpfgbHF88=ccaKLRzsNs7vQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 05, 2014 at 03:10:17PM +0100, WorMzy Tykashi wrote:
> The v3.15-rc{2,3,4} tags seem to have disappeared from the unstable
> repo in the last day or so. Please could you re-push the tags, or were
> they removed for a reason?

The tags were meant to mark the points in time where different groups of
patches were added to the to-be-v3.15, but then I noticed that one of
the patches had my note in the subject and Qu sent an updated version
anyway. So I had rebased the branch and all the tags became stale. I did
not bother to move them as they did not work as expected.

The patch flux is the good and bad habit of the integration repository.
