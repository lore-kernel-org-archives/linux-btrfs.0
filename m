Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54925 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaLUSFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 13:05:43 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so8771225wib.3
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 10:05:42 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [BTRFS-PROGS][PATCH][CLEANUP] Remove some gotos
Date: Sun, 21 Dec 2014 19:07:17 +0100
Message-Id: <1419185238-4254-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

before sending this patch I thought twice if it is really worth.
I know the coding style is really a hot topic. But the world
is already too ugly, to allow even that. And it is Merry Christmas, 
so let me to make me a gift: a small clean up.

The culprit are some goto found in 'cmds-filesystem.c' inside the
function 'cmd_show()'. These are used instead of an 'if' statement.

I wish you all a Happy Christmas and a successful start to 2015.



