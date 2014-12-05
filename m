Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:36418 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbaLEWIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 17:08:47 -0500
Message-ID: <54822CEE.5070603@pobox.com>
Date: Fri, 05 Dec 2014 14:08:46 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: General Question: ctime, mtime, and xattrs
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I was reading the wiki on the internal layout. The INODE description 
says "st_ctime. Also updated when xattrs change."

Why isn't changing the xattrs a modification (st_mtime) event?

It just seems odd to me...
