Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:48204 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756470AbcHYJi3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 05:38:29 -0400
Received: from tux.wizards.de (p579D0EDA.dip0.t-ipconnect.de [87.157.14.218])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 02A7C4160153
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 11:38:27 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 7485811C01E2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 11:38:26 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Please disable balance auto-resume for 4.9 (or even 4.8)
Message-ID: <57BEBC92.2040404@applied-asynchrony.com>
Date: Thu, 25 Aug 2016 11:38:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Automatically resuming an interrupted balance has repeatedly caused all
sorts of problems because it creates a possible failure mode when a user
can least use it: after a crash/power loss/sudden reboot (which, like it
or not, is the de facto "fix random problems" approach for many people).

The idea behind the automnatic resume is good and important for cases
like automation and unattended operation, but nevertheless right now
it creates more problems than it fixes.

As far as I can see it should be easy enough to simply disable calling
btrfs_resume_balance_async() at least on mount (in open_ctree()) and
possibly on remount as well. The skip_balance flag could then simply
be ignored or removed.

I can't say how much work it would be to completely remove the persistent
balance state or whether it is useful to be kept around for resume, but at
least not continuing would stop filesystems from eating themselves further
on mount.

Holger
