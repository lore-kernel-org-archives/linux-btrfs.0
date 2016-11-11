Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933519AbcKKPL7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 10:11:59 -0500
Date: Fri, 11 Nov 2016 16:11:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, yauhen.kharuzhy@zavadatar.com
Subject: Re: [PATCH 12/13] btrfs: check device for critical errors and mark
 failed
Message-ID: <20161111151155.GI12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
 <1462889372-5274-14-git-send-email-anand.jain@oracle.com>
 <a8d004c7-2690-3851-c419-6d2df140b6e0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a8d004c7-2690-3851-c419-6d2df140b6e0@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 08:18:13PM +0800, Anand Jain wrote:
> 
>   This patch is independent of the hot-space as such.

Independent patches, not to say important fixes, would get the right
attention if they come outside of a large series that introduces a new
feature. Features need time to review so they do not get the priority,
unlike fixes. Even if you send a ping mail to the thread with the
series, it's likely to get lost.

The mail traffic does not decrease over time but we still have the same
time to process it. Making things visible "the right way" really helps,
on both sides.
