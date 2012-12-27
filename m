Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:59317
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab2L0ThH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 14:37:07 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Another novice question & comment
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50DCA11C.2050501@czarc.net>
Date: Thu, 27 Dec 2012 12:37:07 -0700
Message-Id: <5BAA2347-6336-4C05-B075-BEF93427EF07@colorremedies.com>
References: <50DC5B51.9060506@czarc.net> <20121227150328.GV19051@carfax.org.uk> <50DC7BA0.2080401@petaramesh.org> <95393023-B40D-4331-A429-3D488B9D0576@colorremedies.com> <50DCA11C.2050501@czarc.net>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 27, 2012, at 12:27 PM, Gene Czarcinski <gene@czarc.net> wrote:
> Oh thanks for that little reminder that you can put btrfs on an LV.

I find it's more trouble than it's worth. It doesn't bring much to the table.

> I am trying to see if I can get grub2 and os-prober to handle btrfs.  There are a couple of patches out there but they do little if anything.  The btrfs volumes and subvolumes are "not your father's filesystem" 8-)

grub2-2.00-12 and -13 in F18 do this correctly already, and automatically. GRUB2 depends on /etc/fstab being properly formed, i.e. includes the proper mount option subvol= in order to know how to create the correct core.img, which has the backed in prefix for grub modules, and also how to create the correct grub.cfg. Unfortunately subvolid= does not work with GRUB2 presently. 

> I have a little of what is needed working but, the more I look at things, the more it looks like some real kludgy hack is going to be needed to have something which works with /dev/<whatever> to now use UUID=xxx,subvol=name

Yes, but if you're using Fedora 18, it does this correctly for you.


Chris Murphy