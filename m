Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:59956 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbbLXK4Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 05:56:24 -0500
Received: from ccs.covici.com (localhost [127.0.0.1])
	by ccs.covici.com (8.14.9/8.14.8) with ESMTP id tBOAuM8A004029
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 05:56:22 -0500
From: covici@ccs.covici.com
To: linux-btrfs@vger.kernel.org
Subject: ssd  not detected on ssd drive
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 24 Dec 2015 05:56:22 -0500
Message-ID: <4028.1450954582@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.  I was making a few file systems on my ssd drives (using lvm on top)
and noticed that the ssd was not detected.  The only thing that happened
is that the metadata is duplicated.  Is this a problem, or a waste of
space?  If I wanted to remake the file systems -- which I don't want to
do unless necessary -- how would I prevent this?

Thanks in advance for any suggestions.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
