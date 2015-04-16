Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55135 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbDPU6p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 16:58:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yiqrz-0003xP-Fj
	for linux-btrfs@vger.kernel.org; Thu, 16 Apr 2015 22:58:43 +0200
Received: from cpc69663-belf10-2-0-cust255.2-1.cable.virginm.net ([82.18.11.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 22:58:43 +0200
Received: from miguel.negrao-lists by cpc69663-belf10-2-0-cust255.2-1.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 22:58:43 +0200
To: linux-btrfs@vger.kernel.org
From: Miguel =?utf-8?b?TmVncsOjbw==?=
	<miguel.negrao-lists@friendlyvirus.org>
Subject: Re: corruption in USB harddrive - backup via send/receive - question
Date: Thu, 16 Apr 2015 20:58:36 +0000 (UTC)
Message-ID: <loom.20150416T225715-417@post.gmane.org>
References: <loom.20150416T202016-456@post.gmane.org> <20150416200613.GN5610@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc <at> merlins.org> writes:

> 
> On Thu, Apr 16, 2015 at 06:48:43PM +0000, Miguel NegrÃ£o wrote:
> > Hello,
> > 
> > I'm running a laptop, macbook pro 8,2, with ubuntu, on kernel
> > 3.13.0-49-lowlatency. I have a USB enclosure containing two harddrives
> 
> Btrfs send/receive is not known to work well enough until 3.14.x, and
> several corruption bugs have been fixed between 3.13 and 3.19.
> 
> You should definitely upgrade to a much more recent kernel.
> 
> Marc

Hi Marc,

But in  my case the corruption is happening in the disk from where data is
being sent. Do you mean that btrfs send cand cause corruption on the sending
disk prior to 3.19 ? 

Thank you,
Miguelÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
