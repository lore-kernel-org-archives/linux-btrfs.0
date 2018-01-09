Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35344 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758882AbeAIQVq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:21:46 -0500
Received: by mail-qk0-f180.google.com with SMTP id w1so2603557qka.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:21:46 -0800 (PST)
Date: Tue, 9 Jan 2018 11:21:45 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs: make btrfs_free_stale_device() to iterate all
 stales
Message-ID: <20180109162144.v7kh523df4p7gbh5@destiny>
References: <20180109141314.23795-1-anand.jain@oracle.com>
 <20180109141314.23795-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109141314.23795-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:13:11PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Let the list iterator iterate further and find other stale
> devices and delete it. This is in preparation to add support
> for user land request-able stale devices cleanup.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

If we're going to do this then please change the function name to
btrfs_free_stale_devices() so it's clear what its intentions are.  Thanks,

Josef
