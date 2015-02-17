Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:56221 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbbBQHMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 02:12:24 -0500
Received: by mail-yk0-f178.google.com with SMTP id 19so15097942ykq.9
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 23:12:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E2C0FC.8030300@richtercloud.de>
References: <54E05DCD.3050508@richtercloud.de>
	<CAJCQCtSSeSbb9r=f830k=5UjKkw=3huE6H_o3oqNWYg2UFJTwg@mail.gmail.com>
	<54E1AD61.7010007@cn.fujitsu.com>
	<CAEr6y+VaV_d6rg3mobkKRQbm5oV0LjUu+Xv-14sx6Rg3fDVLLg@mail.gmail.com>
	<54E1D25C.4090900@richtercloud.de>
	<54E2C0FC.8030300@richtercloud.de>
Date: Tue, 17 Feb 2015 00:12:23 -0700
Message-ID: <CAJCQCtSqpNNTctmkZE+0hqKkNtT=WmMGj7QbBhH8F6DoofTdQw@mail.gmail.com>
Subject: Re: btrfs check --init-csum-tree removes csums again
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

re: Karl-Philipp's attached log, I had pretty much identical messages
as well, just no crash like he did.

So now I'm suspicious this corruption was instigated by btrfs-progs
3.12's --init-csum-tree on a new btrfs volume. After updating to
btrfs-progs 3.18.2, it showed many similar complaints as KP's log, but
did not fix the csum tree using --repair --init-csum-tree. I then
tried --repair by itself which appeared to fix the backref/extents
problems. Then --repair --init-csum-tree did rebuild csum tree.

As for the crash, I would say to try the Fedora btrfs-progs 3.18.2
package on this CentOS 7 system, maybe the crash is a bad compile.

Chris Murphy
