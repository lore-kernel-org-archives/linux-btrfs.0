Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752701AbdDCQrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 12:47:14 -0400
Date: Mon, 3 Apr 2017 18:46:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Brauner <christian.brauner@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix btrfs send & receive with -e flag
Message-ID: <20170403164629.GY4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170324150057.1752-1-christian.brauner@ubuntu.com>
 <20170403160748.cv6ugtmqpsce5uaz@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170403160748.cv6ugtmqpsce5uaz@mailbox.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 06:07:48PM +0200, Christian Brauner wrote:
> Hi guys,
> 
> Friendly ping. Just checking in on this patch since I haven't heard back so far
> and this is a blocker in some scenarios where we're using btrfs.

the test misc/018-recv-end-of-stream fails after your patch, so this
would need to be updated, other the patch looks good.
