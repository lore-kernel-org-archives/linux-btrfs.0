Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:60941 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750977AbdLAPmy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 10:42:54 -0500
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <3c69a20f-f133-ff2b-0ae7-773cdcdf7758@techsquare.com>
Date: Fri, 1 Dec 2017 10:42:46 -0500
MIME-Version: 1.0
In-Reply-To: <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: btrfs-transacti hammering the system
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These seem to come up most often:

[<ffffffffc084ba73>] transaction_kthread+0x133/0x1c0 [btrfs]
[<ffffffffaa09b839>] kthread+0x109/0x140
[<ffffffffaa8459f5>] ret_from_fork+0x25/0x30


