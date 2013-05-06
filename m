Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41842 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab3EFHzJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 03:55:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZGGF-0005x4-Oj
	for linux-btrfs@vger.kernel.org; Mon, 06 May 2013 09:55:03 +0200
Received: from host-091-097-225-022.ewe-ip-backbone.de ([91.97.225.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 09:55:03 +0200
Received: from hurikhan77+btrfs by host-091-097-225-022.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 09:55:03 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
Date: Mon, 06 May 2013 09:47:03 +0200
Message-ID: <ro3k5a-6dh.ln1@hurikhan.ath.cx>
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <20130506003953.GH12414@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fusionio.com> schrieb:

>> I've upgraded to 3.9.0 mainly for the snapshot-aware defragging patches.
>> I'm running bedup[1] on a regular basis and it is now the third time that
>> I got back to my PC just to find it hard-frozen and I needed to use the
>> reset button.
>> 
>> It looks like this happens only while running bedup on my two btrfs
>> filesystems but I'm not sure if it happens for any of the filesystems or
>> only one. This is my setup:

[snip]

> Can you please file a bug for this issue on bugzilla.kernel.org so I can
> make
> sure we don't lose track of it?  Make sure the component is set to Btrfs.

Meanwhile I found out: It does not only happen during dedup with bedup but 
also when creating my rsync backup. I will file all the details to bugzilla 
this evening.

Thanks,
Kai

