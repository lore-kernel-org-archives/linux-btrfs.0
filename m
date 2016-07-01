Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36128 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcGASYS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 14:24:18 -0400
Received: by mail-oi0-f42.google.com with SMTP id f189so121751262oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 11:24:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de>
References: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 1 Jul 2016 12:24:17 -0600
Message-ID: <CAJCQCtTeUUj1W+xG4JmQHBH6JGYEr-V3hJmSA3cJzK1XmP-3Pg@mail.gmail.com>
Subject: Re: FYI: *buntu - btrfs kernel error
To: g6094199@freenet.de
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This probably needs two more pieces of information:
1. What's the workload going on at the time? There's stuff being
written and cleaned up.
2. Issue sysrq+w during the hung task event, and then 'journalctl -k
-o short-monotonic > dmesg+sysrqw.log' and see if that'll go as an
attachment to the list.
