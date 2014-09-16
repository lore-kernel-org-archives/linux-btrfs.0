Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50881 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaIPKVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 06:21:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XTpsq-0005f9-OQ
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 12:21:16 +0200
Received: from pd953ef73.dip0.t-ipconnect.de ([217.83.239.115])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 12:21:16 +0200
Received: from holger.hoffstaette by pd953ef73.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 12:21:16 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 3.14.18 btrfs_set_item_key_safe BUG
Date: Tue, 16 Sep 2014 10:21:04 +0000 (UTC)
Message-ID: <pan.2014.09.16.10.21.04@googlemail.com>
References: <CAMVG2svU-tbpgJ5MqjnS=XGBNZcwfPd0WGMkp1aN4W0M1ewm5A@mail.gmail.com>
	<pan.2014.09.16.07.38.22@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 16 Sep 2014 07:38:22 +0000, Holger Hoffstätte wrote:

> On Tue, 16 Sep 2014 12:33:09 +0800, Daniel J Blueman wrote:
> 
>> kernel BUG at /home/apw/COD/linux/fs/btrfs/ctree.c:3215!
> 
> This matches exactly the description mentioned just recently:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/38340
> 
> (not in that posting, but in the patch description).
> 
> You seem to be running a custom kernel, so try if that patch
> helps. Also try nuking the free space cache when you have it
> applied.

In order to apply that patch you will first need:

"Btrfs: don't insert useless holes when punching beyond the inode's size"
https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=for-linus&id=12870f1c9b2de7d475d22e73fd7db1b418599725

With that it applies cleanly to 3.14.18/19.

-h

