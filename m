Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:41546 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932862AbeAIQPX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:15:23 -0500
Received: by mail-qk0-f177.google.com with SMTP id a8so19165844qkb.8
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:15:22 -0800 (PST)
Date: Tue, 9 Jan 2018 11:15:21 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: move uuid_mutex closer to exclusivity
Message-ID: <20180109161520.vtv4zzljrxtv7cuw@destiny>
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109144625.28381-6-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:46:25PM +0800, Anand Jain wrote:
> move uuid_mutex with in device_list_add().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

This isn't going to work, there's a bunch of places we return errors so this
just deadlocks the box.  Leave it like it is, it's not hurting anybody leaving
it like this.  Thanks,

Josef
