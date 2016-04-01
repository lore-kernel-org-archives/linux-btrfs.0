Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbcDAIoz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 04:44:55 -0400
Date: Fri, 1 Apr 2016 10:44:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
Message-ID: <20160401084418.GI6230@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz>
 <56FDC0A2.1030909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56FDC0A2.1030909@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 08:28:18AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2016/03/31 18:30 +0200:
> > On Thu, Mar 31, 2016 at 10:19:34AM +0800, Qu Wenruo wrote:
> >> At least 2 user from mail list reported btrfsck reported false alert of
> >> "bad metadata [XXXX,YYYY) crossing stripe boundary".
> >>
> >> While the reported number are all inside the same 64K boundary.
> >> After some check, all the false alert have the same bytenr feature,
> >> which can be divided by stripe size (64K).
> >>
> >> The result seems to be initial 'max_size' can be 0, causing 'start' +
> >> 'max_size' - 1, to cross the stripe boundary.
> >>
> >> Fix it by always update extent_record->cross_stripe when the
> >> extent_record is updated, to avoid temporary false alert to be reported.
> >>
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >
> > Applied, thanks.
> >
> > Do you have a test image for that?
> >
> >
> Unfortunately, no.
> 
> Although I figured out the cause the the false alert, I still didn't 
> find a image/method to reproduce it, except the images of reporters.
> 
> I can dig a little further trying to make a image.

After another look, why don't we use nodesize directly? Or stripesize
where applies. With max_size == 0 the test does not make sense, we ought
to know the alignment.
