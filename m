Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:55359 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3JYNLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 09:11:49 -0400
Received: from kipc2.localdomain (unknown [3.249.69.203])
	by mail-rly-prd-02.am.health.ge.com (Postfix) with ESMTP id DADB94EB93
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 13:11:41 +0000 (GMT)
Date: Fri, 25 Oct 2013 15:12:16 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive do not keep inode ctimes
Message-ID: <20131025131216.GA14134@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello insiders

is there low level support to change inode ctimes somehow?
(on ext[234] it can be done using debugfs)

It would be nice to make received snapshots as similar as
possible to their send source. (I am not talking about
uuids and such, just ls -lc output)

creative ideas are welcome,

Karl

