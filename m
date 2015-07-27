Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbG0OfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 10:35:21 -0400
Date: Mon, 27 Jul 2015 16:35:09 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] btrfs-progs: qgroup related enhance.
Message-ID: <20150727143509.GF6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150323233803.GP20767@twin.jikos.cz>
 <5510B191.1010402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5510B191.1010402@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 08:36:33AM +0800, Qu Wenruo wrote:
> > All of the above merged.
> >
> >>    btrfs-progs: Schedule quota rescan if qgroup assign caused
> >>      inconsistence.
> >
> > The rescan can be a long running operation and touches a lot of
> > metadata, so I'd rather avoid starting the rescan automatically. Right
> > now the user may start rescan manually, or please add an commandline
> > option (eg. --rescan) to do the rescan in one go with the 'assign'
> > command. Thanks.
> >
> Makes sense, I'll update the last patch soon.

I've merged your patch without changes and implemented the --rescan
option myself.
