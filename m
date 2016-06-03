Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35934 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcFCJtK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 05:49:10 -0400
Received: by mail-oi0-f67.google.com with SMTP id x130so16043556oia.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 02:49:10 -0700 (PDT)
MIME-Version: 1.0
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 3 Jun 2016 11:49:09 +0200
Message-ID: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
Subject: Recommended why to use btrfs for production?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

We would like to use urBackup to make laptop backups, and they mention
btrfs as an option.

https://www.urbackup.org/administration_manual.html#x1-8400010.6

So if we go with btrfs and we need 100TB usable space in raid6, and to
have it replicated each night to another btrfs server for "backup" of
the backup, how should we then install btrfs?

E.g. Should we use the latest Fedora, CentOS, Ubuntu, Ubuntu LTS, or
should we compile the kernel our self?

And a bonus question: How stable is raid6 and detecting and replacing
failed drives?

-RC
