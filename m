Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:33479 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbcLMMxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 07:53:47 -0500
Message-ID: <1481633610.584fef4a61dff@webmail.adria.it>
Date: Tue, 13 Dec 2016 13:53:30 +0100
From: bepi@adria.it
To: linux-btrfs@vger.kernel.org
Cc: twalberg@comcast.net
Subject: btrfs check --repair question
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.


I had two cases of 'ref mismatch on extents .... ..', like you.

Any attempt at recovery has much worsened the problem.

I suggest you save importanto data and delete and recreate the partition.

I always have a partition for re-install from scratch, so that I can recover
data from damaged file system, without being forced to try to repair it.


Gdb

----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it

