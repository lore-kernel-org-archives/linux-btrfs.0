Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:46223 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbbIYNko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:40:44 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by mail.sjomar.eu (Postfix) with ESMTPSA id 6D154320F1
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 15:40:41 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: raw devices or partitions?
Date: Fri, 25 Sep 2015 15:40:39 +0200
Message-ID: <2432089.CrOTrZyfAm@hoefnix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it better to use raw devices for a RAID setup or make one partition on the 
drive and then create your RAID from there?
Right now if have one setup that uses raw, but get messages "unknown partition 
table" all the time in my logs. 
I am planning to create a RAID 5 setup (seems to be stable these days?), but 
wondering  to deal with  raw drives or partitions (4 at the moment).
In the wiki they're referring to raw devices in the examples, but that could 
be outdated?


Cheers,
Sjoerd

