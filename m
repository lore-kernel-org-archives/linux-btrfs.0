Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 80-46-26-45.static.dsl.as9105.com ([80.46.26.45]:36175 "EHLO
	wally-tm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759220Ab3BWPpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 10:45:06 -0500
Received: from [192.168.0.2] ([192.168.0.2])
	(authenticated user wally_tm@wally-tm.com)
	by wally-tm.com
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for linux-btrfs@vger.kernel.org;
	Sat, 23 Feb 2013 15:14:56 +0000
Message-ID: <5128DCF0.4040209@wally-tm.com>
Date: Sat, 23 Feb 2013 15:14:56 +0000
From: Tomasz Kusmierz <wally_tm@wally-tm.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Changing node & leaf size on live partition.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Question is pretty simple:

"How to change node size and leaf size on previously created partition?"

Now, I know what most people will say: "you should've be smarter while 
typing mkfs.btrfs". Well, I'm intending to convert in place ext4 
partition but there seems to be no option for leaf and node size in this 
tool. If it's not possible I guess I'll have to create "/" from scratch 
and copy all my content there.



BTW. To Chris and other who were involved - after fixing this "static 
electricity from printer" issue I've been running rock solid raid10 
since then! Great job guys, really appreciate.


Cheers, Tom.

