Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:58952 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JYGQW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 02:16:22 -0400
Received: by mail-pa0-f66.google.com with SMTP id kx10so244299pab.9
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 23:16:22 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 Oct 2013 14:16:22 +0800
Message-ID: <CAC+R54AEU271wvcgoEF0OSVUTZL7YnZXj=Mjn6ZW+0573vBAxg@mail.gmail.com>
Subject: btrfs flush data cache
From: lilofile <lilofile82@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

       transaction_kthread can periodically commit data and metedata
to disk,similarly btrfs_writepages can write data page to disk, in
which situation btrfs_writepages function is called? and i cannot find
btrfs_writepages is called in btrfs code? who can tell me?
