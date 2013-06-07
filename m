Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob12.myregisteredsite.com ([209.17.115.107]:33412 "EHLO
	atl4mhob12.myregisteredsite.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857Ab3FGCvY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Jun 2013 22:51:24 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob12.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r572pMad026154
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Jun 2013 22:51:22 -0400
Message-ID: <51B14AB0.4040906@chinilu.com>
Date: Thu, 06 Jun 2013 19:51:28 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How do I safely terminate COW on pre-existing files?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I want to eliminate the COW feature on all of my OS files.  It is a nice 
feature for user files, but I don't see a clear benefit for the actual 
OS files.  And I suspect that COW induced fragmentation is causing or 
aggravating problems with my system including the boot open_ctree 
problem.  I had planned to recursively chattr these files to "nodatacow" 
status but then I ran into this cryptic warning on the chattr man page:

(Note: For btrfs, the 'C' flag should be set on new or empty files. If 
it is set on a file which already has data blocks, it is undefined when 
the blocks assigned to the file will be fully stable.  If the  'C'  
flag  is set on a directory, it will have no effect on the directory, 
but new files created in that directory will the No_COW attribute.)

So what exactly does that mean?  Does it mean that it is unsafe?  Or 
does it mean that it is simply unreliable?  If I run a btrfs balance 
first will that clear out the COW snapshots and enable me to perform the 
recursive chattrs?  What is the best way to approach this?

Thanks for any tips,  George
