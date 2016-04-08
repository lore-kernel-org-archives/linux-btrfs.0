Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758474AbcDHTS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Apr 2016 15:18:57 -0400
Date: Fri, 8 Apr 2016 12:18:55 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Filipe David Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: WARN_ON in record_root_in_trans() when deleting freshly renamed
 subvolume
Message-ID: <20160408191855.GK2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <57068E64.7000408@googlemail.com>
 <CAL3q7H6U8hDK7+BOqP-u3ogrJaKxED3U839kmT_PU6kbq9U1AA@mail.gmail.com>
 <57079B4D.8080304@googlemail.com>
 <5707ADCB.9090207@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5707ADCB.9090207@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 08, 2016 at 03:10:35PM +0200, Holger Hoffstätte wrote:
> [cc: Mark and Qu]
> 
> On 04/08/16 13:51, Holger Hoffstätte wrote:
> > On 04/08/16 13:14, Filipe Manana wrote:
> >> Using Chris' for-linus-4.6 branch, which is 4.5-rc6 + all 4.6 btrfs
> >> patches, it didn't reproduce here:
> > 
> > Great, that's good to know (sort of :). Thanks also to Liu Bo.
> > 
> >> Are you sure that you are not using some patches not in 4.6?
> 
> We have a bingo!
> 
> Reverting "qgroup: Fix qgroup accounting when creating snapshot"
> from last Wednesday immediately fixes the problem.

Not surprising, I had some issues testing it out too. I'm pretty sure this
patch is corrupting memory, I just haven't found where yet though my
educated guess is that the transaction is being reused improperly.
	--Mark

--
Mark Fasheh
