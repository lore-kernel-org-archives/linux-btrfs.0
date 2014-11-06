Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35832 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbaKFD2R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Nov 2014 22:28:17 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56754 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XmDk8-000bVI-Kz
	for linux-btrfs@vger.kernel.org; Wed, 05 Nov 2014 20:28:16 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [bug] btrfs fi show lists wrong (old) devid size after btrfs replace
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <EC620053-6EDC-4122-AAA5-0AC86814B04A@colorremedies.com>
Date: Wed, 5 Nov 2014 20:28:01 -0700
Message-Id: <E709B43E-A4B5-4DEC-940B-BBABE1116409@colorremedies.com>
References: <EC620053-6EDC-4122-AAA5-0AC86814B04A@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filed a bug. The btrfs fi show, and (conventional) df command are the same with kernel-3.18.0-0.rc3.git0.1.fc22.x86_64
https://bugzilla.kernel.org/show_bug.cgi?id=87851

I'm going to guess this is a btrfs-progs bug not resizing the file system to "max"; I'm pretty sure this was working at one time but it's been a while since I've done a replace, maybe not since progs 3.14.


Chris Murphy