Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57399 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbcBJHgu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 02:36:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 1E36421A57
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 02:36:50 -0500 (EST)
Message-Id: <1455089809.3460336.517032378.36A389A7@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: How to show current profile?
Date: Tue, 09 Feb 2016 23:36:49 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I searched the man pages, can't seem to find it. 
btrfs-balance can change profiles, but not show
the current profile... seems odd.
