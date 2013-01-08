Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outgoing.tormail.org ([82.221.96.22]:39618 "EHLO
	outgoing.tormail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3AHAhp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 19:37:45 -0500
Received: from localhost ([127.0.0.1] helo=internal.tormail.org)
	by outgoing.tormail.org with esmtp (Exim 4.72)
	(envelope-from <junlion@tormail.org>)
	id 1TsNCJ-0004cH-5b
	for linux-btrfs@vger.kernel.org; Tue, 08 Jan 2013 03:37:44 +0300
Received: from junlion by internal.tormail.org with local (Exim 4.63)
	(envelope-from <junlion@tormail.org>)
	id 1TsN9p-000FDf-SX
	for linux-btrfs@vger.kernel.org; Tue, 08 Jan 2013 00:35:12 +0000
Date: Tue, 8 Jan 2013 00:37:11 +0000
From: Jun Lion <junlion@tormail.org>
To: linux-btrfs@vger.kernel.org
Subject: chattr +C  vs.  btrfs subvolume snapshot
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <1TsN9p-000FDf-SX@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What happens if you set an individual file inside a subvolume as nocow
(chattr +C) and then take a snapshot of that subvolume and modify the
file in both?

Will btrfs now ignore the nocow attribute completely or will it do "as
few copies as possible"? (I'd love to know if it's possible to visualize
the fragmentation of a single file.)
