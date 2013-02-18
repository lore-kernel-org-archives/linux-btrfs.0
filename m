Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37589 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3BRROV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 12:14:21 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so1748564pbc.40
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 09:14:21 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 18 Feb 2013 12:14:20 -0500
Message-ID: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
Subject: Kernel panic when scrub is used
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I experience a kernel panic with "General protection fault" when doing
a scrub on Kernel 3.8-rc7.

Here is a screenshot: http://tinypic.com/r/34r6nad/6

The weird part is that the scrub completes from initramfs, but when
system is fully booted, is kernel panics every time in the low
percentage. (<10%)
