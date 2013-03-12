Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57958 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab3CLRbG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:06 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 327D19A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:06 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id CMdk5aVcMOXgZjhV (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:04 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Btrfs-progs: Update btrfs restore so it matches all current development
Date: Tue, 12 Mar 2013 13:38:07 -0400
Message-ID: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I noticed today that a bunch of work that had been done to restore last year
wasn't in the normal btrfs-progs restore.  So this work forward ports all of the
patches that were missing, and redoes a bunch of the work that was done to deal
with really broken file systems so that it uses more of the generic helpers that
Chris wrote a while ago.  This is based on the latest integration branch, Dave
if you want to just pull you can do

git://github.com/josefbacik/btrfs-progs.git for-kdave

Thanks,

Josef
