Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33429 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbbCFKks (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Mar 2015 05:40:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YTpfy-0001P1-TU
	for linux-btrfs@vger.kernel.org; Fri, 06 Mar 2015 11:40:14 +0100
Received: from p4ff5809d.dip0.t-ipconnect.de ([79.245.128.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 11:40:14 +0100
Received: from holger.hoffstaette by p4ff5809d.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 11:40:14 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Status: converting raid levels
Date: Fri, 6 Mar 2015 10:39:56 +0000 (UTC)
Message-ID: <pan.2015.03.06.10.39.56@googlemail.com>
References: <CADurGxyF6g5Z+HNMry+q=b_oCKv1a6StDvp6pL20z=twK0BMHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 06 Mar 2015 11:22:09 +0100, Marcel Ritter wrote:

> please, can someone comment on the current status of raid level migration?
> (kernel 4.0.0-rc2, btrfs-progs 3.19-rc2)
> 
> I just started testing this feature, and it doesn't seem to work:

You're very likely looking at something I found previously, see:
http://www.spinics.net/lists/linux-btrfs/msg42084.html & followups.

So far I haven't seen any fix appear anywhere; if you're daring
enough you can try to revert/undo the mentioned patch and see
what happens when you try to convert between RAID levels.

-h

