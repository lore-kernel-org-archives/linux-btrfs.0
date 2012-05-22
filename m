Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:23163 "EHLO
	sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab2EVV7Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 17:59:16 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
	by sed198n136.sedsystems.ca  with ESMTP id q4MLj4Bm027843
	(version=TLSv1/SSLv3 cipher=DHE-DSS-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 15:45:04 -0600 (CST)
Received: from [198.169.180.30] (sed198n30.SEDSystems.ca [198.169.180.30])
	by barney.sedsystems.ca (8.13.1/8.13.1) with ESMTP id q4MLj4XF022866
	for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 15:45:04 -0600
Message-ID: <4FBC082D.9020707@sedsystems.ca>
Date: Tue, 22 May 2012 15:42:05 -0600
From: Henry Bakker <bakker@sedsystems.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Could btrfs-restore be extended to also restore file dates?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any possibility of getting btrfs-restore to also restore the files
timestamp?

I'm doing a restore right now as I had one btrfs partition blow up and
I'm noting that the timestamps are marking all the restored files as
new. It would be nice to be able to do a quick compare of file dates to
determine any changed files that may be newer on the restore vs the
backup. (I can save full file compares for when the server is not being
actively used.)

I do realize it is possible that there could be other issues, but for
quickly determining potential issues this could be useful.

I do realize that there may be technical reasons for the current
behavior, so at the very least this is suggestion for future
functionality even if it doesn't help me.
