Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33792 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbcC2UWI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 16:22:08 -0400
Received: by mail-vk0-f48.google.com with SMTP id e185so34454473vkb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 13:22:08 -0700 (PDT)
MIME-Version: 1.0
From: "Warren, Daniel" <daniel.warren@mcmcllc.com>
Date: Tue, 29 Mar 2016 16:21:28 -0400
Message-ID: <CAHaDNyXRW4FQC+5P2_8apdFan2wtsHnPyzuK5ZPq8dLXW-S9_g@mail.gmail.com>
Subject: attempt to mount after crash during rebalance hard crashes server
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all,

I'm running 4.4.0 from deb sid

My server crashed during a balance after I had added 10 disks to the
original 15, I have not been able to bring the FS up since, it causes
a system crash

btrfs fi sh looks fine, but when I mount , it crashes the server with
a NULL pointer dereference error
Each Disk in the set is LUKS encrypted

btrfs fi sh http://pastebin.com/QLTqSU8L
kernel panic http://pastebin.com/aBF6XmzA

If it's of any use I can run tests before I attempt check --repair

I can let this sit a day or two if any data gathering would be of use.


Daniel Warren
Unix System Admin,Compliance Infrastructure Architect, ITServices
MCMC LLC
