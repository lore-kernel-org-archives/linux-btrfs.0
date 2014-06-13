Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34764 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMO64 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 10:58:56 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so2867428wgh.7
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jun 2014 07:58:55 -0700 (PDT)
Received: from linuxpc.localnet (193-81-61-240.adsl.highway.telekom.at. [193.81.61.240])
        by mx.google.com with ESMTPSA id j44sm12331535eeg.30.2014.06.13.07.58.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 13 Jun 2014 07:58:54 -0700 (PDT)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS partition has no UUID
Date: Fri, 13 Jun 2014 18:58:53 +0200
Message-ID: <1627089.QpTCty9cFV@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I discovered a bug in the ubuntu installer, you can find here: 
https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1329794

To summarize the issue: Ubuntu installer creates a /boot partition that simply 
has no UUID for some reason.
Do you guys have any idea what could lead to such a behavior? Normally when I 
create a btrfs partition in gparted blkid shows me an UUID. How is it possible 
that a btrfs partition is created that does not show up in blkid?

Thanks in advance,

GEO
