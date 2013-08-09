Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:39412 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933343Ab3HIFjp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 01:39:45 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id C7344356178
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2013 07:39:41 +0200 (CEST)
Received: from localhost (cm218-254-66-194.hkcable.com.hk [218.254.66.194])
	by mail.virtall.com (Postfix) with ESMTPSA id D222835616F
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2013 07:39:40 +0200 (CEST)
Date: Fri, 9 Aug 2013 13:39:33 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs qgroup destroy -> ERROR: unable to create quota group: Device
 or resource busy
Message-ID: <20130809133933.2fbfc6e4@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using qgroups and have created a few hundreds of subvolumes in the
past.

It seems that btrfs automatically assigns a qgroup to newly created
snapshot/subvolume, but does not destroy the qgroup when the subvolume
is deleted.

So I've tried to destroy the unused qgroups, with mixed success. I was
able to destroy most of them, but some are still failing, i.e.:

# btrfs qgroup destroy 4494 /mnt/lxc1
ERROR: unable to create quota group: Device or resource busy


Note the negative number here, but I also have qgroups with both
positive numbers, which I'm not able to destroy as well:

# btrfs qgroup show /mnt/lxc1 | grep 4494
0/4494 839516160 -69632


qgroup 4494 is not used by any subvolume:

# btrfs sub list /mnt/lxc1 | grep 4494


I did run "btrfs quota rescan" for this filesystem, hoping it will fix
the problem, but it didn't.


Any advice?


-- 
Tomasz Chmielewski
http://wpkg.org
