Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64073 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2KRVEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Nov 2012 16:04:33 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so765710eek.19
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2012 13:04:32 -0800 (PST)
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Content-Type: text/plain; charset=us-ascii
Subject: Sparsify / hole punching tool
Message-Id: <97B8CC50-0F4A-42BE-959F-26C86A2C3FAD@yerf-it.nl>
Date: Sun, 18 Nov 2012 22:04:29 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wrote a little tool you can use to scan a file and punch holes, so make it sparse.

Confirmed to work on 3.7.0-rc6
Feel free to use it in any way you like, and of course improve it. 

http://pastebin.com/8SjEsBLD

Remco Hosman