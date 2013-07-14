Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48123 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3GNOui (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 10:50:38 -0400
Received: by mail-ea0-f176.google.com with SMTP id z15so7253901ead.35
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 07:50:37 -0700 (PDT)
Received: from [192.168.3.130] ([194.9.67.191])
        by mx.google.com with ESMTPSA id m1sm95140660eex.17.2013.07.14.07.50.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 14 Jul 2013 07:50:36 -0700 (PDT)
Message-ID: <51E2BABB.3060506@statystyka.net>
Date: Sun, 14 Jul 2013 16:50:35 +0200
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Can btrfs handle different RAID levels for different subvolumes?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can one btrfs filesystem handle different RAID levels e.g. for different 
subvolumes? If so, how does deduplication with bedup 
(https://github.com/g2p/bedup) across them work?

(It has been asked already on the Net 
(http://unix.stackexchange.com/questions/82869/can-btrfs-handle-different-raid-levels-for-different-subvolumes) 
but the question didn't get the answer. I guess answering it should be 
straightforward for you, guys :-) )

Adam Ryczkowski


