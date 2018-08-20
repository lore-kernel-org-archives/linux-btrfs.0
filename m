Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34658 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726391AbeHTQnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:43:47 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD99AAD4A
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 13:28:07 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] btrfstune fs_info cleanups
Date: Mon, 20 Aug 2018 16:28:03 +0300
Message-Id: <1534771685-4924-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While inspecting btrfstune source code I came across 2 functions which needlessly
take fs_info argument. This small series rectifies this. No functional changes. 

Nikolay Borisov (2):
  btrfstune: Remove fs_info arg from change_device_uuid
  btrfstune: Rename change_header_uuid to change_buffer_header_uuid

 btrfstune.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.7.4
