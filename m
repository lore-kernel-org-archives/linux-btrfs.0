Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33055 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab3FPRRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Jun 2013 13:17:08 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id C29133A3DAA
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Jun 2013 19:17:03 +0200 (CEST)
Received: from localhost (unknown [222.110.111.200])
	by mail.virtall.com (Postfix) with ESMTPSA id A045C3A1B01
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Jun 2013 19:17:02 +0200 (CEST)
Date: Mon, 17 Jun 2013 02:16:53 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Subject: converting lzo compression to zlib compression?
Message-ID: <20130617021653.4718a5e0@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem mounted with "compress=lzo" now.

I'd like to see how much space would I save by converting it to zlib.


Would it be possible to convert lzo compression to zlib compression
with the following:

- mount the filesystem with "compress=zlib"
- run balance
- when balance finishes, the data would be compressed with zlib

Would this work as above, or do I have to copy the data out and back to
convert from lzo compression to zlib compression?


-- 
Tomasz Chmielewski
http://wpkg.org


