Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52070 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3EEQIZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 12:08:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZ1U6-00082I-G9
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 18:08:22 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 18:08:22 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 18:08:22 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Creating recursive snapshots for all filesystems
Date: Sun, 05 May 2013 18:03:38 +0200
Message-ID: <pfci5a-c0p.ln1@hurikhan.ath.cx>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Skwar <alexanders.mailinglists+nospam@gmail.com> schrieb:

> So I guess I'd still need to mount the root volume temporarily
> somewhere to do the translation.

That brings in the idea how bedup seems to handle this. Maybe you want to 
take one or the other idea from there as it also has to enumerate all btrfs 
filesystems and snapshots:

https://github.com/g2p/bedup

Regards,
Kai

