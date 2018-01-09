Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36677 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932862AbeAIQMD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:12:03 -0500
Received: by mail-qt0-f195.google.com with SMTP id a16so18410388qtj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:12:03 -0800 (PST)
Date: Tue, 9 Jan 2018 11:12:01 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: move pr_info into device_list_add
Message-ID: <20180109161201.eufrgdxzkub5ctaz@destiny>
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109144625.28381-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:46:21PM +0800, Anand Jain wrote:
> Commit 60999ca4b403 ("btrfs: make device scan less noisy")
> adds return value 1 to device_list_add(), so that parent function can
> call pr_info only when new device is added. Move the pr_info() part
> into device_list_add() so that this function can be kept simple.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
