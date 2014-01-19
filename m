Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:57563 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbaASUTy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 15:19:54 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.113])
	by atl4mhob11.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0JKJqX5024144
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 15:19:52 -0500
Message-ID: <52DC3386.7020502@chinilu.com>
Date: Sun, 19 Jan 2014 12:20:22 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <pan$a84be$d3729bcc$cd2b0fdb$783fe765@cox.net> <1420240.1BEopi7BrR@merkaba>
In-Reply-To: <1420240.1BEopi7BrR@merkaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just my opinion, of course, but I simply cannot imagine how "an 
incorrect checksum could appear correct due to a memory error". Sorry, 
but I just cannot get my brain around that one.  The odds against it 
happening would be beyond comprehension.  I can easily imagine btrfs 
taking a system down due to memory error, but not btrfs causing data 
corruption due to a memory error.
