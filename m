Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57110 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576Ab3EGVUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 17:20:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZpIq-0008Hm-35
	for linux-btrfs@vger.kernel.org; Tue, 07 May 2013 23:20:04 +0200
Received: from dyndsl-178-142-088-157.ewe-ip-backbone.de ([178.142.88.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 23:20:04 +0200
Received: from hurikhan77+btrfs by dyndsl-178-142-088-157.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 23:20:04 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Tue, 07 May 2013 23:17:53 +0200
Message-ID: <qk7o5a-g0b.ln1@hurikhan.ath.cx>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com> <gqgl5a-4s5.ln1@hurikhan.ath.cx> <20130507051741.GB24548@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Torcz <tomek@pipebreaker.pl> schrieb:

>> How will it compare to bcache? I'm currently thinking about buying an SSD
>> but bcache requires some efforts in migrating the storage to use. And
>> after all those hassles I am even not sure if it would work easily with a
>> dracut generated initramfs.
> 
>   On the side note: dm-cache, which is already in-kernel, do not need to
> reformat backing storage.

Oh thanks, good pointer. I haven't looked so much into dm-cache yet because 
it seemed to have come "out of nowhere" while I was tracking news around 
bcache development for a while now.

Regards,
Kai

