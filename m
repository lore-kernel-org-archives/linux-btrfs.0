Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56767 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851Ab2IKLqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 07:46:03 -0400
Date: Tue, 11 Sep 2012 13:45:59 +0200
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: enquiry about defrag
Message-ID: <20120911114559.GV17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <504BDCE0.8020407@gmail.com>
 <504F1CBA.6030201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <504F1CBA.6030201@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2012 at 07:12:58PM +0800, ching wrote:
> > 1. According to btrfs wiki, defragment a COW file will produce two unrelated files.
> >
> >     Does it apply to the "autodefrag" mount option?
> 
> can anybody helps on question 1?

The data blocks associated with the files (that were originally created
by snapshotting and thus shared the same blocks) will become unshared,
so yes it would appear like two unlreated files.

Autodefrag option affects only newly written data. With current
implementation it could unshare some extents if the defragged range
picked by autodefrag logic overlaps with an existing one.

>From my experience, running 'btrfs fi defrag' with autodefrag on
produced better result. Beware that there are some unfixed deadlocks
that may happen with autodefrag enabled.

david
