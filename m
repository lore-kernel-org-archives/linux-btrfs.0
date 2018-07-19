Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36650 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730470AbeGSMo6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:44:58 -0400
Date: Thu, 19 Jul 2018 14:01:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/7] btrfs: use the assigned fs_devices instead of the
 dereference
Message-ID: <20180719120158.GJ26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-5-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716145812.20836-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 10:58:09PM +0800, Anand Jain wrote:
> We have assigned the %fs_info->fs_devices in %fs_devices as its not
> modified just use it for the mutex_lock().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, as it's independent of the rest.
