Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbbFWPYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 11:24:55 -0400
Date: Tue, 23 Jun 2015 17:24:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Robbie Ko <robbieko@synology.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] Revert "Btrfs: incremental send, remove dead code"
Message-ID: <20150623152450.GJ6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
 <1435055991-10109-2-git-send-email-robbieko@synology.com>
 <CAL3q7H6wUxUkDY5kq+GKPtY3qmFADQ-yEvHp=gQFUNnzTBmSig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6wUxUkDY5kq+GKPtY3qmFADQ-yEvHp=gQFUNnzTBmSig@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 04:09:07PM +0100, Filipe David Manana wrote:
> On Tue, Jun 23, 2015 at 11:39 AM, Robbie Ko <robbieko@synology.com> wrote:
> > This reverts commit 5f806c3ae2ff6263a10a6901f97abb74dac03d36.
> >
> > This is a necessary patch for a subsequent patch in the series (patch 3).
> 
> Still confused.
> Reverting that commit (5f806c3ae2ff6263a10a6901f97abb74dac03d36) alone
> will fix any issue?
> Reading the part below gives that understanding, but it's basically a
> trimmed down version of the scenario/problem mentioned in patch 3, so
> it doesn't seem, nor it's clear, that this revert alone fixes any
> problem.

If it's only to re-introduce the path_loop helper alone, then the revert
is indeed confusing.
