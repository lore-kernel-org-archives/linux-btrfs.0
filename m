Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbaGVOmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 10:42:01 -0400
Date: Tue, 22 Jul 2014 16:41:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi df'
 command
Message-ID: <20140722144159.GB1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com>
 <20140704135226.GO1553@twin.jikos.cz>
 <53B9ED88.8020201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B9ED88.8020201@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 07, 2014 at 08:44:56AM +0800, Qu Wenruo wrote:
> >The 'fi usage' is supposed to give the user-friendly overview, but the
> >patchset is stuck because I found the numbers wrong or misleading under
> >some circumstances.
> Although these patchset may not be merged,  I'm curious about the wrong
> numbers.
> Would you please provide some leads or hints?

The calculations led to bogus numbers in some cases for the minimum
free due to rounding errors using the calculated factor 'K' and a small
negative number appeared as 16E. I have patches that calculate the
numbers a bit differently.
