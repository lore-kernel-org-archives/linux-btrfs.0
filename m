Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52360 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab3HVS34 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 14:29:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCZdo-00054O-OF
	for linux-btrfs@vger.kernel.org; Thu, 22 Aug 2013 20:29:52 +0200
Received: from dyndsl-085-016-234-095.ewe-ip-backbone.de ([85.16.234.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 20:29:52 +0200
Received: from hurikhan77+btrfs by dyndsl-085-016-234-095.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 20:29:52 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Date: Thu, 22 Aug 2013 20:29:26 +0200
Message-ID: <6t1iea-qg7.ln1@hurikhan77.spdns.de>
References: <loom.20130822T115349-248@post.gmane.org> <20130822140752.GO3990@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fusionio.com> schrieb:

> Not sure what strict allocate = yes does, but I assume it probably does
> fallocate() in which case yeah we aren't going to compress, we'll just
> write
> into the preallocated space.  We don't support compressed writes into
> preallocated space ATM, and I'm not sure we ever will.  Thanks,

Good to know, this renders btrfs as efficient storage backend for Windows 
file shares pretty useless. Does this also happen with compress-force?

As a work-around one could write a cronjob that regularly defrags all files 
changed since the last run with -c option...

Thanks,
Kai

