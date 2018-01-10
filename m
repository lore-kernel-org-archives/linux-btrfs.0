Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:44668 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965291AbeAJPuE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:50:04 -0500
Received: by mail-qk0-f172.google.com with SMTP id u76so4626305qku.11
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 07:50:04 -0800 (PST)
Date: Wed, 10 Jan 2018 10:50:02 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument
 optional
Message-ID: <20180110155002.iwyzd7ad76wje3mf@destiny>
References: <20180110051523.3681-1-anand.jain@oracle.com>
 <20180110051523.3681-5-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180110051523.3681-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:15:21PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This updates btrfs_free_stale_device() helper function to delete all
> unmouted devices, when arg is NULL.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
