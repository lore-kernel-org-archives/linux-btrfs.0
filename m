Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52500 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbaEUXFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 19:05:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WnFZu-0003ZN-VD
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 01:05:42 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 01:05:42 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 01:05:42 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: ditto blocks on ZFS
Date: Thu, 22 May 2014 00:05:26 +0100
Message-ID: <lljbfo$6vm$1@ger.gmane.org>
References: <2308735.51F3c4eZQ7@xev> <4483661.BdmCOR8JR5@xev> <57f050e2a37907d810b40c5e115b28ff.squirrel@webmail.wanet.net> <1795587.Ol58oREtZ7@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <1795587.Ol58oREtZ7@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Very good comment from Ashford.


Sorry, but I see no advantages from Russell's replies other than for a
"feel-good" factor or a dangerous false sense of security. At best,
there is a weak justification that "for metadata, again going from 2% to
4% isn't going to be a great problem" (storage is cheap and fast).

I thought an important idea behind btrfs was that we avoid by design in
the first place the very long and vulnerable RAID rebuild scenarios
suffered for block-level RAID...


On 21/05/14 03:51, Russell Coker wrote:
> Absolutely. Hopefully this discussion will inspire the developers to
> consider this an interesting technical challenge and a feature that
> is needed to beat ZFS.

Sorry, but I think that is completely the wrong reasoning. ...Unless
that is you are some proprietary sales droid hyping features and big
numbers! :-P


Personally I'm not convinced we gain anything beyond what btrfs will
eventually offer in any case for the n-way raid or the raid-n Cauchy stuff.

Also note that usually, data is wanted to be 100% reliable and
retrievable. Or if that fails, you go to your backups instead. Gambling
"proportions" and "importance" rather than *ensuring* fault/error
tolerance is a very human thing... ;-)


Sorry:

Interesting idea but not convinced there's any advantage for disk/SSD
storage.


Regards,
Martin




