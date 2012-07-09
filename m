Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34954 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GIR1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 13:27:51 -0400
Received: by lbbgm6 with SMTP id gm6so20473059lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 10:27:49 -0700 (PDT)
From: Pierre Carrier <pierre@spotify.com>
To: linux-btrfs@vger.kernel.org
Cc: Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 0/2] Support for small units in display
Date: Mon,  9 Jul 2012 17:27:41 +0000
Message-Id: <1341854861-14450-1-git-send-email-pierre@spotify.com>
In-Reply-To: <1341853347-11788-1-git-send-email-pierre@spotify.com>
References: <1341853347-11788-1-git-send-email-pierre@spotify.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I didn't test the initial patches enough.
A second round is coming.

This time it works fine:
devid    1 size 66746609664.00 used 66746580992.00 path /dev/sda5
devid    1 size 65182236.00KB used 65182208.00KB path /dev/sda5
devid    1 size 63654.53MB used 63654.50MB path /dev/sda5
devid    1 size 62.16GB used 62.16GB path /dev/sda5
devid    1 size 62.16GB used 62.16GB path /dev/sda5


Pierre Carrier (2):
  utils.c: fix sizes in B & malloc in pretty_sizes
  utils.c: offer to limit divisions in pretty_sizes

 utils.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

-- 
1.7.11.1

