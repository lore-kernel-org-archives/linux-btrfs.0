Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:43634 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965826AbeAJPvc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:51:32 -0500
Received: by mail-qk0-f169.google.com with SMTP id j137so23442651qke.10
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 07:51:32 -0800 (PST)
Date: Wed, 10 Jan 2018 10:51:30 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs: rename btrfs_free_stale_devices() arg to
 skip_dev
Message-ID: <20180110155129.vhlzujpy3wior3yk@destiny>
References: <20180110051523.3681-1-anand.jain@oracle.com>
 <20180110051523.3681-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180110051523.3681-6-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:15:22PM +0800, Anand Jain wrote:
> No functional changes.
> Rename btrfs_free_stale_devices() arg to skip_dev, so that it
> reflects what that arg for.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
