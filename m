Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbcDYPJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 11:09:25 -0400
Date: Mon, 25 Apr 2016 17:09:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, yauhen.kharuzhy@zavadatar.com
Subject: Re: [PATCH] btrfs: fix lock dep warning, move scratch dev out of
 device_list_mutex and uuid_mutex
Message-ID: <20160425150908.GB29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460969483-7500-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460969483-7500-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 04:51:23PM +0800, Anand Jain wrote:
> When the replace target fails, the target device will be taken
> out of fs device list, scratch + update_dev_time and freed. However
> we could do the scratch  + update_dev_time and free part after the
> device has been taken out of device list, so that we don't have to
> hold the device_list_mutex and uuid_mutex locks.
> 
> Reported issue:
[...]
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

Reviewed-by: David Sterba <dsterba@suse.com>
