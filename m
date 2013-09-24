Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49868 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756676Ab3IYBOE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 21:14:04 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50927 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VObmc-000Ztx-Hk
	for linux-btrfs@vger.kernel.org; Tue, 24 Sep 2013 17:12:42 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
Date: Tue, 24 Sep 2013 17:12:39 -0600
Message-Id: <6D8341CD-FCAE-4680-A10A-4ED699269058@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com> <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since I can now reproduce this bug on two different computers, one with SSD, the other HDD, and scrub does not fix the csum errors with a scrub, I've filed a bug. It's reproducible with:

kernel-3.11.1-300.fc20.x86_64
btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64

Bug is at:
https://bugzilla.redhat.com/show_bug.cgi?id=1011714



Chris Murphy