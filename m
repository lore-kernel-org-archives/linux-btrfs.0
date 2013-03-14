Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab3CNW0E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 18:26:04 -0400
Date: Thu, 14 Mar 2013 23:26:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: update .gitignore file
Message-ID: <20130314222601.GX7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363227161-6878-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363227161-6878-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've added the rest of the missing make targets into that commit

@@ -12,15 +12,24 @@ btrfs-show
 btrfs-vol
 btrfsck
 btrfsctl
+calc-size
+ioctl-test
+dir-test
+send-test
+quick-test
 find-root
 mkfs.btrfs
+mkfs.btrfs.static
 repair
 restore
 btrfs-convert
 btrfs-find-root
+btrfs-find-root.static
 btrfs-image
 btrfs-show-super
 btrfs-zero-log
+btrfs-corrupt-block
+btrfs-select-super
 btrfstune
 libbtrfs.a
 libbtrfs.so
