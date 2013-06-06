Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41721 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab3FFVCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Jun 2013 17:02:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UkhKB-0007Cc-UV
	for linux-btrfs@vger.kernel.org; Thu, 06 Jun 2013 23:02:23 +0200
Received: from host-091-097-231-016.ewe-ip-backbone.de ([91.97.231.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jun 2013 23:02:23 +0200
Received: from hurikhan77+btrfs by host-091-097-231-016.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jun 2013 23:02:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible solution to the "open_ctree" boot bug ...
Date: Thu, 06 Jun 2013 22:58:10 +0200
Message-ID: <vn978a-io2.ln1@hurikhan.ath.cx>
References: <51AB5A76.9060203@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Mitchell <george@chinilu.com> schrieb:

> I am seeing a huge improvement in boot performance since doing a system
> wide file by file defragementation of metadata.  In fact in the four
> sequential boots since completing this process, I have not seen one
> open_ctree failure so far.  This leads me to suspect that the open_ctree
> boot failures that have been plaguing me since install have been related
> to metadata fragmentation.  So I would advise anyone else experiencing
> open_ctree boot problems to defragment their metatdata and see if that
> helps.  It certainly seems to have helped me in that regard.

I suspect this observation comes from btrfs being able to faster initialize 
itself during kernel detection since you defragmented it. Try to add 
root_delay=2 to your kernel command line and see if it improves on this 
particular problem.

I had this myself and root_delay=1 fixed it for me. Before, in about 90% of 
all boots it came up with the ctree error. After, it never happened again.

Regards,
Kai

