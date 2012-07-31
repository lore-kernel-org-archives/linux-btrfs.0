Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55090 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2GaSAR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 14:00:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SwGjs-0006UU-LL
	for linux-btrfs@vger.kernel.org; Tue, 31 Jul 2012 20:00:12 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 20:00:12 +0200
Received: from eternaleye+usenet by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 20:00:12 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye+usenet@gmail.com>
Subject: Re: filesystem finder / fixer
Date: Tue, 31 Jul 2012 10:56:05 -0700
Message-ID: <jv967k$6nr$2@dough.gmane.org>
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com> <20120731113247.11aab72a@natsu> <jv9618$6nr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alex Elsayed wrote:
> offset 0x10040 (64K + 64 bytes) there's the string BHRfS (hex 5F 42 48 52
> 66 53 5f). That matches the documentation (the first superblock should be

Ugh, and resending it stripped the underscores. _BHRfS_ is at 0x10040, not 
BHRfS (which would be at 0x10041)

