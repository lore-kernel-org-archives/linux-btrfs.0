Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaKGUUg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 15:20:36 -0500
Date: Fri, 7 Nov 2014 12:20:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Cyril Scetbon <cyril.scetbon@free.fr>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Quota question
Message-ID: <20141107202034.GA8013@infradead.org>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr>
 <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr>
 <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
 <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr>
 <7A4F7864-B01A-4B69-B2DE-3140DA6216D8@colorremedies.com>
 <4E5FAFF3-DB6F-4695-87E7-8AA9B64B34F1@free.fr>
 <8F387133-3535-40A0-BCEC-C624760B1E92@colorremedies.com>
 <EC156DAA-1971-41CD-B978-5E368E245E82@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EC156DAA-1971-41CD-B978-5E368E245E82@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 05, 2014 at 09:52:18PM +0100, Cyril Scetbon wrote:
> oh cool to know !
> 
> It's weird that the man page says "limits are never enforced on the superuser (nor are they enforced for group and project ID zero)"
> 
> http://manpages.ubuntu.com/manpages/trusty/en/man8/xfs_quota.8.html

This means it's never enforced for (uid|gid|prij) zero.  If you can come
up with a better wording were happy to update the man page.

