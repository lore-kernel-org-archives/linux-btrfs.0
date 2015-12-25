Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:57423 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbLYKDM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 05:03:12 -0500
Received: from ccs.covici.com (localhost [127.0.0.1])
	by ccs.covici.com (8.14.9/8.14.8) with ESMTP id tBPA3AD0016108
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 05:03:10 -0500
From: covici@ccs.covici.com
To: linux-btrfs@vger.kernel.org
Subject: btrfs problems on new file system
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 25 Dec 2015 05:03:10 -0500
Message-ID: <16107.1451037790@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.  I created a file system using 4.3.1 version of btrfsprogs and have
been using it for some three days.  I have gotten the following errors
in the log this morning:
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981
Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
transid verify failed on 51776421888 wanted 4983 found 4981

The file system was then made read only.  I unmounted, did a check
without repair which said it was fine, and remounted successfully in
read/write mode, but am I in trouble?  This was on a solid state drive
using lvm.

Thanks in advance for any suggestions.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
