Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752603AbeBENdE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 08:33:04 -0500
Date: Mon, 5 Feb 2018 14:30:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, sage@redhat.com
Subject: Re: [PATCH v2 1/4] btrfs: Remove userspace transaction ioctls
Message-ID: <20180205133049.GD18553@suse.cz>
Reply-To: dsterba@suse.cz
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1517820076-13613-1-git-send-email-nborisov@suse.com>
 <A5DE21A1-B937-4D8F-A327-1296EDAF00F3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <A5DE21A1-B937-4D8F-A327-1296EDAF00F3@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 05, 2018 at 05:52:52PM +0900, Wang Shilong wrote:
>    These ioctl are originally introduced by Sage Weil for Ceph use?
> Not sure whether it still useful, Cc Sage just in case.

We have checked that the ioctl is not used in ceph, the reasons why we
think it's ok to remove the ioctl were in the cover letter of v1.
