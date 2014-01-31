Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41336 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251AbaAaGNh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 01:13:37 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <7EDDA59B-B69B-4376-B387-A5FCB3F7263C@colorremedies.com>
Date: Thu, 30 Jan 2014 23:13:36 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <DD290B24-A1DE-477B-8A73-5507A907F901@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com> <pan$3f5b6$fcf027de$d8c8fe27$ce2a7e6f@cox.net> <8FF7CD63-3B07-42CB-88C3-E88D39280892@colorremedies.com> <pan$7d02a$d46a4ede$2832dda8$da2d2ddd@cox.net> <7EDDA59B-B69B-4376-B387-A5FCB3F7263C@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>,
        =?iso-8859-1?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 11:10 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> I'm also seeing many "Error reading 1647012864000, -1" with different block addresses (same -1 though), and also "1659900002304failed to load free space cache for block group" also with different numbers. Maybe hundreds of these. I'm not sure if this is due to the missing device, and it's reporting missing meta data? Or if the working device also has some problem, which depending on the configuration might implicate a single SATA controller.

Sorry I'm being impatient since I'm away snowboarding tomorrow. The above refers to parts of Johan's btrfs check output which hasn't yet made it to the list.

Chris Murphy

