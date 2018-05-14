Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41105 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbeENLNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F706AD97
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:39 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/9] Overhaul btrfs-corrupt-block 
Date: Mon, 14 May 2018 14:13:25 +0300
Message-Id: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-corrupt-block is a very useful tool albeit very neglected. This series 
aims to give it much needed attention. There is a mix of code-improvements and 
bug fixes. Code improvement mainly consists of factoring our duplicated code 
(Patch 1,3,6) and improving the interface of some options (4,5,8,9). The
recurring topic here is that instead of having to pass 

btrfs-corrupt-block -K <key> -f <field> -<SOME OPTION WHICH CORRUPTS AN ITEM, 
POINTED TO BY K> 

make each corrupting option to take the key as an argument to it. Say we want
to corrupt an item field (-I options) we now do: 
 
 btrfs-corrupt-block -I <key> -r <root> /dev/blah 

 instead of 

 btrfs-corrupt-block -I -K <key> -r <root> /dev/blah 

Some patches also incorporate fixes for bugs (patch 2,7 and 9) I found during 
my testing. Those usability improvements are needed to enable me to produce 
tests for the pending free space tree support in userspace. 


Nikolay Borisov (9):
  btrfs-progs: btrfs-corrupt-block: Factor out specific-root code
  btrfs-progs: btrfs-corrupt-block: Correctly handle -r when passing -I
  btrfs-progs: btrfs-corrupt-block: Factor out key parsing function
  btrfs-progs: btrfs-corrupt-block: Change -I flag parameter format
  btrfs-progs: btrfs-corrupt-block: Convert -K flag argument handling to
    common function
  btrfs-progs: btrfs-corrupt-block: Factor out common "-r" handling code
  btrfs-progs: btrfs-corrupt-block: Add support for handling specific
    root when using -K option
  btrfs-progs: btrfs-corrupt-block: Change format of -d option
  btrfs-progs: btrfs-corrupt-block: Fix -D option

 btrfs-corrupt-block.c | 94 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 37 deletions(-)

-- 
2.7.4

