Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54502 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab3GTWsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jul 2013 18:48:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V0fwY-00089n-Li
	for linux-btrfs@vger.kernel.org; Sun, 21 Jul 2013 00:48:02 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jul 2013 00:48:02 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jul 2013 00:48:02 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Lots of harddrive chatter on after booting with btrfs on root
 (slow boot)
Date: Sat, 20 Jul 2013 22:47:46 +0000 (UTC)
Message-ID: <ksf42h$suu$1@ger.gmane.org>
References: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 20 Jul 2013 17:15:50 +0200, Jason Russell wrote:
> Ive also noted that this excessive hdd chatter does not occur
> immediately after a fresh format with arch on btrfs root.
> 
> Ive made some deductions/assumptions:
> This only seems to occur with btrfs roots.
> This only happens after some number of reboots OR after the partition
> fills up a little bit.
> Im pretty sure of ruled out everything except for the filesystem.

In my experience (as of 3.8 or so), Btrfs performance degrades on a
filled-up filesystem, even a comparatively new one.  Various
background workers start to eat io according to atop.

> I have just done two clean installs to more thoroughly compare ext4
> and btrfs roots. So far no excessive hdd chatter from btrfs.
> 
> I have also seen what I have described on two other computers
> (different hardware entirely) where there is lots of hdd chatter from
> btrfs root, and nothing from ext4.
> 
> Here are two threads:
> https://bbs.archlinux.org/viewtopic.php?pid=1117932
> https://bbs.archlinux.org/viewtopic.php?pid=1301684

