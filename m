Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbbDBQsN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 12:48:13 -0400
Date: Thu, 2 Apr 2015 18:48:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Petr Bena <benapetr@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: SSD mode on HDD
Message-ID: <20150402164811.GR6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+4EQ5dko+dSy6aFtx3cyUUXNR493aCHDE1A=MGb9FjnWQjwWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+4EQ5dko+dSy6aFtx3cyUUXNR493aCHDE1A=MGb9FjnWQjwWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 02, 2015 at 05:49:04PM +0200, Petr Bena wrote:
> Hey,
> 
> I figured out that for some reason on both ubuntu and debian, SSD mode
> seems to be turned on even on HDD's (hard disk drives - eg. those with
> rotating disk). I figured out now, but it's been like this for at
> least a year or more and I didn't really had any problems with this.
> 
> Is it OK to have SSD mode enabled on HDDs?

Yeah, it's safe. It will slightly change the behaviour of allocator
and triggers some actions earlier (that are otherwise offloaded to other
threads).

There's one case where it might make a difference: the metadata
defragmentaion is skipped if SSD is enabled. I'm going to send a patch
that'll make the behaviour consistent.
