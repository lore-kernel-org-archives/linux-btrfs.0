Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:41135 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3FBOpF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 10:45:05 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob11.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r52Ej4da032692
	for <linux-btrfs@vger.kernel.org>; Sun, 2 Jun 2013 10:45:04 -0400
Message-ID: <51AB5A76.9060203@chinilu.com>
Date: Sun, 02 Jun 2013 07:45:10 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Possible solution to the "open_ctree" boot bug ...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am seeing a huge improvement in boot performance since doing a system 
wide file by file defragementation of metadata.  In fact in the four 
sequential boots since completing this process, I have not seen one 
open_ctree failure so far.  This leads me to suspect that the open_ctree 
boot failures that have been plaguing me since install have been related 
to metadata fragmentation.  So I would advise anyone else experiencing 
open_ctree boot problems to defragment their metatdata and see if that 
helps.  It certainly seems to have helped me in that regard.
