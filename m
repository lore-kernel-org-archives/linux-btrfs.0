Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39776 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaACCHp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 21:07:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VyuAp-0001fB-8B
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 03:07:43 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 03:07:43 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 03:07:43 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Fri, 03 Jan 2014 02:24:01 +0100
Message-ID: <h2ghpa-u74.ln1@hurikhan77.spdns.de>
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net> <loom.20140101T204832-543@post.gmane.org> <pan$d8c7$6644fca2$fe85bee2$cc84b5d0@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> But because a full balance rewrites everything anyway, it'll effectively
> defrag too.

Is that really true? I thought it just rewrites each distinct extent and 
shuffels chunks around... This would mean it does not merge extents 
together.

Regards,
Kai

