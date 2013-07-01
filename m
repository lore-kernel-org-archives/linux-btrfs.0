Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:60538 "EHLO
	homiemail-a57.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754614Ab3GAQTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jul 2013 12:19:20 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unclean shutdown and space cache rebuild
Date: Mon, 01 Jul 2013 21:49:16 +0530
Message-ID: <1792894.GCCHX1XfTr@bheem>
In-Reply-To: <pan$d6b02$c375f8e3$e64c63ed$cc12d244@cox.net>
References: <11441914.sRzrmH57Vq@bheem> <2982023.ALTX9LRhaY@bheem> <pan$d6b02$c375f8e3$e64c63ed$cc12d244@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, July 01, 2013 09:10:41 AM Duncan wrote:
> > But in general, how to find out most fragmented files and folders?
> > mouting with autodefrag is a serious degradation..
> 
> It is?  AFAIK, all the autodefrag mount option does is scan files for
> fragmentation as they are written and queue any fragmentation-detected
> files for background defrag by the defrag thread.
> 
> I had expected, particularly on spinning rust, that the benefits of
> autodefrag to far exceed the costs, so your performance drag claim is
> interesting to me indeed.  If my expectation is wrong, which it could be,
> I'd love to know why, and see some numbers.

while I don't have numbers, I enabled autodefrag on all the partitions and 
rebooted(twice, just to confirm) and its slow.. 

everything has a 10 second tail of disk activity and has quite some visible 
latency. Moving mouse, switching windows, starting new programs, everything 
has visible latency thats unusable.

It seems autodefrag is being too aggressive for its own good.. 

I am sticking with defragging folders individually. /var, /home and a 1GB 
squid cache is what I have narrowed down and things are reasonably fast.
-- 
Regards
 Shridhar
