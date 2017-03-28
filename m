Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbdC1Pjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 11:39:32 -0400
Date: Tue, 28 Mar 2017 17:38:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH 2/4] btrfs: Communicate back ENOMEM when it occurs
Message-ID: <20170328153842.GA4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313074214.24123-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:42:12PM +0800, Anand Jain wrote:
> The only error that write dev flush (send) will fail is due
> to the ENOMEM then, as its not a device specific error and
> rather a system wide issue, we should rather stop further
> iterations and perpetuate the -ENOMEM error to the caller.

I think we should try harder, as flushing is a critical operation and a
simple yet unlikely memory allocation failure should not stop it.

The device::flush_bio is being allocated each time we start flush and
freed afterwards. This seems unnecessary. The proper fix IMO is to
preallocate the bio at the time the device is added to the list. The bio
lifetime is same as the device'.
