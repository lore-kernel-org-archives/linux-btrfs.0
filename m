Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40973 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KEDyO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 22:54:14 -0500
Received: by mail-pd0-f173.google.com with SMTP id r10so7641392pdi.18
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 19:54:13 -0800 (PST)
Date: Mon, 4 Nov 2013 19:54:11 -0800
From: Kelley Nielsen <kelleynnn@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: opw-kernel@googlegroups.com
Subject: Bootstrap the btrfs_find_item interface
Message-ID: <20131105035411.GA19148@kelleynnn-HP-Compaq-8510w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josh, Zach, and team,

I went ahead and took the comment out, as can be seen in patch 3/3. I
had left it there because my understanding is that this is just a
proposal, and if the team likes the idea, btrfs_find_item() will be
further developed so that it replace more existing functions and not as
yet existing ones. I can imagine, though, that if it's not taken out it
could end up floating around in the tree for no good reason. Is that
correct?

Also, I fixed a rebase conflict before preparing this set, so a) I
hope I did it correctly, and b) assuming I did, I feel confident to 
handle them in the future. They look exactly like merge conflicts. 
I discarded the lines from HEAD (the lines on top) and kept what was 
in the patch (on the bottom).

Thanks,

Kelley (kelleynnn)
