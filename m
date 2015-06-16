Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57398 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbbFPNNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 09:13:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z4qgU-00039O-Tx
	for linux-btrfs@vger.kernel.org; Tue, 16 Jun 2015 15:13:46 +0200
Received: from p4ff58081.dip0.t-ipconnect.de ([79.245.128.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 15:13:46 +0200
Received: from holger.hoffstaette by p4ff58081.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 15:13:46 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Automatic balance after mkfs?
Date: Tue, 16 Jun 2015 13:13:40 +0000 (UTC)
Message-ID: <pan.2015.06.16.13.13.40@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Forking from the other thread..

On Tue, 16 Jun 2015 12:25:45 +0000, Hugo Mills wrote:

>    Yes. It's an artefact of the way that mkfs works. If you run a
> balance on those chunks, they'll go away. (btrfs balance start
> -dusage=0 -musage=0 /mountpoint)

Since I had to explain this very same thing to a new btrfs-using friend
just yesterday I wondered if it might not make sense for mkfs to issue
a general balance after creating the fs? It should be simple enough
(just issue the balance ioctl?) and not have any negative side effects.

Just doing such a post-mkfs cleanup automatically would certainly
reduce the number of times we have to explain the this. :)

Any reasons why we couldn't/shouldn't do this?

-h


