Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60935 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbcJLMQG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 08:16:06 -0400
Date: Wed, 12 Oct 2016 14:16:03 +0200
From: David Sterba <dsterba@suse.cz>
To: =?utf-8?Q?Grdykopl=C4=85s?= Namorzyn <ssuukk2@gmail.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: Btrfs unmountable - claims it is missing a volume
Message-ID: <20161012121603.GP11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAN3EzUeH0uFW1fD0vkmeoz01ha1fAabTVmupsaG_ejR4hR1WKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAN3EzUeH0uFW1fD0vkmeoz01ha1fAabTVmupsaG_ejR4hR1WKQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Sep 10, 2016 at 08:59:21AM +0200, Grdykopląs Namorzyn wrote:
> Hello,
> 
> While my btrfs mounts ok on several instances of my home OpenElec, but
> on ArchLinux it fails with:
> 
> [174828.954975] BTRFS error (device sdc): super_num_devices 3 mismatch
> with num_devices 2 found here

I got another report of the same problem (2 devices expected but really
there was just 1). The refused mount is caused by additional checks [1]
that are in 4.7 but were not in previous versions. The fix was to set
the superblock::num_devices to the right number (after some
verification).  I'll add the repair capability to checker, let me know
if you'd use the one-time fixup utility. Otherwise, the cause why device
numbers are off is unknown.

[1] https://git.kernel.org/linus/99e3ecfcb9f4ca35192d20a5bea158b81f600062
