Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:36206 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751160AbdLAReq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 12:34:46 -0500
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <17ead8e4-106e-f568-e996-ab472814a749@techsquare.com>
Date: Fri, 1 Dec 2017 12:34:35 -0500
MIME-Version: 1.0
In-Reply-To: <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: btrfs-transacti hammering the system
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, I'll give space_cache=v2 a shot.

My mount options are: rw,relatime,space_cache,autodefrag,subvolid=5,subvol=/
