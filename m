Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:51378 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbcFXBtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 21:49:21 -0400
Received: from lamp.crc.id.au (lamp.crc.id.au [IPv6:2407:e400:b000:200::8e8e])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id CF90B3A005C
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 11:49:17 +1000 (AEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 24 Jun 2016 11:49:17 +1000
From: Steven Haigh <netwiz@crc.id.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs 4.6 won't build on CentOS6
Message-ID: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've tried to build the new tools for CentOS 6 / Scientific Linux 6 / 
RHEL 6 etc.

During the build process, I see:
cmds-fi-du.c: In function 'du_calc_file_space':
cmds-fi-du.c:330: error: 'FIEMAP_EXTENT_SHARED' undeclared (first use in 
this function)
cmds-fi-du.c:330: error: (Each undeclared identifier is reported only 
once
cmds-fi-du.c:330: error: for each function it appears in.)
make: *** [cmds-fi-du.o] Error 1

I'm guessing this is probably due to a different GCC version used? I'm 
guessing this is a simple fix for someone with knowhow... :)

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
