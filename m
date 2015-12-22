Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:38396 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbbLVXyf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 18:54:35 -0500
Received: from ccs.covici.com (localhost [127.0.0.1])
	by ccs.covici.com (8.14.9/8.14.8) with ESMTP id tBMNsXWT029681
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 18:54:33 -0500
From: covici@ccs.covici.com
To: linux-btrfs@vger.kernel.org
Subject: notify not being triggered in btrfs directory
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 22 Dec 2015 18:54:33 -0500
Message-ID: <29680.1450828473@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.  I am having a problem where I am watching some directories in a
btrfs file system, but inotify is not being triggered -- is this a known
issue?  I am using kernel 4.1.12-gentoo and programs 4.3.1.

Thanks in advance for any suggestions.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
