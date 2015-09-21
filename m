Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59312 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbbIUUgD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 16:36:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Ze7oc-00034B-J3
	for linux-btrfs@vger.kernel.org; Mon, 21 Sep 2015 22:35:58 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 22:35:58 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 22:35:58 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: RAID1 storage server won't boot with one disk missing
Date: Mon, 21 Sep 2015 23:35:39 +0300
Message-ID: <m49fv27cxyc.fsf@coffee.modeemi.fi>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
	<pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
	<CA+WRLO94UekKmT1cy3+t4+pHSCMj=HRoEF4oqtJDimS=EWnbhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye <gareth@cerberos.id.au> writes:

> People tend to be looking at BTRFS for a guarantee that data doesn't
> die when hardware does. Defaults that defeat that shouldn't be used.

However, data is no more in danger at startup than it is at the moment
when btrfs notices a drive dropping, yet it permits IO to proceed. Is
there not a contradiction?

Personally I don't see why system startup should be a special case, in
particular as it can be very stressful situation to recover from when
RAID is there just to avoid the immediate reaction when hardware breaks;
and when in practice you can do the recovery while the system is running
in systems where short service interruptions matter.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

