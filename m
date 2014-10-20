Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:49405 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJTQFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 12:05:46 -0400
Received: from webmail.sonic.net (webmail.a.apps.sonic.net [64.142.109.105])
	(authenticated bits=0)
	by d.mail.sonic.net (8.14.9/8.14.9) with ESMTP id s9KG5fnE010546
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 09:05:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 20 Oct 2014 09:05:41 -0700
From: Suman Chakravartula <suman@rockstor.com>
To: linux-btrfs@vger.kernel.org
Subject: Compressed size of a filesystem
Message-ID: <911267269ecc4056ebe114fe78a52b0a@sonic.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'd like to calculate the compressed size of a btrfs filesystem. I read 
the wiki and understand the backward compatibility issues mentioned. 
Also, the "df before and after" method doesn't work for me and I have no 
control over when end users are writing to the filesystem.

Wiki says there's a patch which is not merged. Is that refering to this 
discussion:

http://comments.gmane.org/gmane.comp.file-systems.btrfs/14942

Why was the patch not merged?

-- 
Suman Chakravartula
Rockstor, Inc.
