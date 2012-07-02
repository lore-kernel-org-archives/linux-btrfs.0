Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58060 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2GBWlY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 18:41:24 -0400
Received: by wgbdr13 with SMTP id dr13so5668491wgb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 15:41:23 -0700 (PDT)
Date: Tue, 3 Jul 2012 01:41:12 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: no dev_stats entry found / OK on first mount after mkfs
Message-ID: <20120702224112.GA9555@zambezi.lan>
References: <alpine.DEB.2.01.1207021441450.5568@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.01.1207021441450.5568@trent.utfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 02:46:11PM -0700, Christian Kujau wrote:
> Hi,
> 
> after upgrading from 3.4.0 to 3.5.0-rc5 on this powerpc machine, the 
> following is printed during bootup:
> 
>   [   18.630750] device fsid ce8c9df5-0a93-47c6-adf6-25084f352a4f devid 1 transid 11061 /dev/hda7
>   [   18.637193] btrfs: disk space caching is enabled
>   [   18.706423] btrfs: no dev_stats entry found for device /dev/hda7 (devid 1) (OK on first mount after mkfs)
> 
> The btrfs on hda7 has been created many months ago and has been mounted 
> several times since then. Assuming "first mount after mkfs" does not apply 
> here, is it then NOT OK that no dev_stats entry has been found?
> 
> IOW: should I worry about this message?

No, you should not.  If this is your first mount after upgrading your
kernel to the one with btrfs dev stats feature, "first mount after mkfs"
sort of applies.

Thanks,

		Ilya
