Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:65407 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752411Ab3GQVtn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 17:49:43 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54244 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1UzZbS-001O1G-UB
	for linux-btrfs@vger.kernel.org; Wed, 17 Jul 2013 15:49:43 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Questions about multi-device behavior
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1860433.azE0Vf7tMy@horus>
Date: Wed, 17 Jul 2013 15:49:41 -0600
Message-Id: <456C85D9-B747-47E3-8A47-0282163362FA@colorremedies.com>
References: <1860433.azE0Vf7tMy@horus>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 17, 2013, at 3:24 PM, Florian Lindner <mailinglists@xgm.de> wrote:
> 
> a) If one disk fails, is there any chance of data recovery? 

Slim to none it seems so far. Maybe with more specialized tools.


> b) If not, is there any advantage over a raid0 configuration.

raid0 allocates equal chunks, so in order to maximize usable space the devices need to be the same size or space is wasted (not used). single allocated chunks based on availability so it's possible to maximally use all space on all devices even if they're significantly different in size.

Chris