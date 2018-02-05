Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tragedy.dreamhost.com ([66.33.205.236]:50064 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752961AbeBEOfZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Feb 2018 09:35:25 -0500
Date: Mon, 5 Feb 2018 14:27:46 +0000 (UTC)
From: Sage Weil <sage@newdream.net>
To: David Sterba <dsterba@suse.cz>
cc: Wang Shilong <wangshilong1991@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] btrfs: Remove userspace transaction ioctls
In-Reply-To: <20180205133049.GD18553@suse.cz>
Message-ID: <alpine.DEB.2.11.1802051427120.24931@piezo.novalocal>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com> <1517820076-13613-1-git-send-email-nborisov@suse.com> <A5DE21A1-B937-4D8F-A327-1296EDAF00F3@gmail.com> <20180205133049.GD18553@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 5 Feb 2018, David Sterba wrote:
> On Mon, Feb 05, 2018 at 05:52:52PM +0900, Wang Shilong wrote:
> >    These ioctl are originally introduced by Sage Weil for Ceph use?
> > Not sure whether it still useful, Cc Sage just in case.
> 
> We have checked that the ioctl is not used in ceph, the reasons why we
> think it's ok to remove the ioctl were in the cover letter of v1.

Yeah, +1 on removal.

Acked-by: Sage Weil <sage@redhat.com>

sage
