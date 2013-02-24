Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36557 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392Ab3BXAZj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 19:25:39 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so2199140wib.7
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Feb 2013 16:25:38 -0800 (PST)
Message-ID: <51295DFF.5020403@gmail.com>
Date: Sun, 24 Feb 2013 00:25:35 +0000
From: Tom Kusmierz <tom.kusmierz@gmail.com>
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
