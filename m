Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:32780 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966336AbbDWQrc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:47:32 -0400
Received: by qkx62 with SMTP id 62so14256244qkx.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 09:47:31 -0700 (PDT)
Message-ID: <55392221.6090502@gmail.com>
Date: Thu, 23 Apr 2015 12:47:29 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] btrfs-progs: restore symlinks
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hopefully this is sufficiently paranoid, tested with PATH_MAX length
symlinks, existing files, insufficient permissions, dangling symlinks.
I think I got the coding style correct this time, I'll fix and resend if
not.

Includes a trivial fix from my metadata patch, the documentation got
lost in the merge.

