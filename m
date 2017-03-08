Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve1eur01on0068.outbound.protection.outlook.com ([104.47.1.68]:41376
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753711AbdCHSJQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 13:09:16 -0500
From: Luca Citi <lciti@essex.ac.uk>
Subject: Re: btrfs throws ENOSPC even on almost empty filesystem when using
 "cfq" scheduler
To: <linux-btrfs@vger.kernel.org>
References: <7d2d26be-302d-6f88-4107-aa1414dcc233@essex.ac.uk>
Message-ID: <293390d4-9b1a-9b31-d908-c26ee8477b0d@essex.ac.uk>
Date: Wed, 8 Mar 2017 17:52:25 +0000
MIME-Version: 1.0
In-Reply-To: <7d2d26be-302d-6f88-4107-aa1414dcc233@essex.ac.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

More information in case it may be useful.

I also ran the tests with different mainline kernels.

I have downloaded kernels from:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.8.2/
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.8.3/

The problem does not seem to affect 4.8.2 but it does affect 4.8.3.

In both cases I am using version 4.4 of the btrfs-tools.

