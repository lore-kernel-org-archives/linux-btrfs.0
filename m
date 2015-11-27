Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44866 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbbK0FO7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 00:14:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 5AFF8204C5
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:14:58 -0500 (EST)
Message-Id: <1448601297.4093478.451242913.1CEE0D6D@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: How to detect / notify when a raid drive fails?
Date: Thu, 26 Nov 2015 21:14:57 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd like to run "mail" when a btrfs raid drive fails, but I don't
know how to detect that a drive has failed. It don't see it in
any docs. Otherwise I assume I would never know until enough
drives fail that the filesystem stops working, and I'd like to
know before that.

- Ian Kelling
