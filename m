Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40642 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750699AbaEBENG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 00:13:06 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:64553 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wg4qN-000Xea-Uj
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 22:13:05 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unable to rebuild a 3 drive raid1 - blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <0233AD56-FDDF-4B6A-A32B-26F9F8D66FA2@colorremedies.com>
Date: Thu, 1 May 2014 22:13:02 -0600
Message-Id: <1B8537A5-4DBB-4DE5-A797-4C2660312E98@colorremedies.com>
References: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com> <460175EE-093C-44D8-B561-596D1D71FAAF@colorremedies.com> <0233AD56-FDDF-4B6A-A32B-26F9F8D66FA2@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK I do finally get a message indicating a blocked task so I've updated the file, and also decided to just file a kernel bug on it so the file is assured to be somewhere more permanent.

https://bugzilla.kernel.org/show_bug.cgi?id=75271


Chris Murphy