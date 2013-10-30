Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48907 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab3J3U2p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 16:28:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VbcNf-0007eE-9f
	for linux-btrfs@vger.kernel.org; Wed, 30 Oct 2013 21:28:43 +0100
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 21:28:43 +0100
Received: from frank by mail.kingswood-consulting.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 21:28:43 +0100
To: linux-btrfs@vger.kernel.org
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: Maybe need a --force option on scrub start?
Date: Wed, 30 Oct 2013 20:28:32 +0000
Message-ID: <52716BF0.7010202@kingswood-consulting.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My filesystem seems to be a bit confused, and I can not start a btrfs 
scrub. Which is necessary, because I have replaced a disk.

Hacking the cmds-scrub.c file I notice that sfr->stats.finished and 
sfr->stats.canceled are both zero in the one record returned.

Returning 0 from that function allows me to start a new scrub.
After cancelling it and retrying the values are finished=0 and 
canceled=1, and I can use the unmodified btrfs scrub command.

Frank

