Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60121 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaHGWKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Aug 2014 18:10:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XFVsp-0003bX-Kl
	for linux-btrfs@vger.kernel.org; Fri, 08 Aug 2014 00:10:03 +0200
Received: from 51B64F7D.dsl.pool.telekom.hu ([81.182.79.125])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Aug 2014 00:10:03 +0200
Received: from megabrutal by 51B64F7D.dsl.pool.telekom.hu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Aug 2014 00:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: MegaBrutal <megabrutal@gmail.com>
Subject: Re: Quota reached: can't delete
Date: Thu, 7 Aug 2014 22:04:54 +0000 (UTC)
Message-ID: <loom.20140808T000436-719@post.gmane.org>
References: <CAEgy6-3jQ3nkFqY-eJj86vDSsfZQ2naiA-VoMw-U-TPaBd3Pew@mail.gmail.com> <51014FCF.7080202@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen <sensille <at> gmx.net> writes:

> 
> On 24.01.2013 16:12, Jerome M wrote:
> > Hi,
> > 
> > With the current btrfs quota implementation, when you reach a
> > subvolume quota limit, you can't delete anything without first
> > removing the limit or enlarge it:
> > 
> > rm: cannot remove `testfile.bin': Disk quota exceeded
> > 
> > 
> > Is there any plan to change that?
> 
> Yes, there is. The problem is that even deletion needs space.
> So we need to allow remove to go over quota. The current implementation
> doesn't make this distinction.
> 

I've found a workaround to avoid changing quota: null the file and then
you'll be able to delete it.

echo > testfile.bin
rm testfile.bin

P.S.: Sorry for necromancing this thread, but I couldn't resist to tell. :P

