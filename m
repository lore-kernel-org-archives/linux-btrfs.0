Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:47616 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbbAEVSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 16:18:07 -0500
Received: by mail-qa0-f48.google.com with SMTP id k15so13150385qaq.21
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jan 2015 13:18:06 -0800 (PST)
Message-ID: <1420492683.10853.4.camel@kepstin.ca>
Subject: Re: Balance is inexplicably dieing (repeatedly)
From: Calvin Walton <calvin.walton@kepstin.ca>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 05 Jan 2015 16:18:03 -0500
In-Reply-To: <CAAe=sHXgd0J+rm-w4cHC-P9T=PUCRx6vmLH0U3Uyhr03EZ_r5g@mail.gmail.com>
References: <CAAe=sHXgd0J+rm-w4cHC-P9T=PUCRx6vmLH0U3Uyhr03EZ_r5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2015-01-05 at 13:18 -0600, sys.syphus wrote:
> I start it. I check it and its like 2% done
> Several hours its stopped and the re-balance clearly didn't finish
> because I can see one member of the array has a fraction of the usage
> of the others. Dmesg shows no errors.
> 
> Thoughts? should start it again in the foreground with verbosity or
> something? any logs i can check other than dmesg?

It doesn't sound like anything is going wrong here, but to be sure can 
you please paste the output of `btrfs fi show` and `btrfs fi df` run 
on the filesystem mountpoint?

One thing to note is that Btrfs's "RAID1" mode isn't actually RAID1, 
but it rather writes only 2 copies of the data. If you have an odd 
number of disks, this will lead to having varying usages on different 
devices.

> dmesg only shows similar to below
> 
> [342210.304169] BTRFS info (device dm-4): relocating block group 
> ##### flags 17
> [342219.191141] BTRFS info (device dm-4): found 129 extents
> [342233.029425] BTRFS info (device dm-4): found 129 extents
> [342235.434779] BTRFS info (device dm-4): relocating block group 
> ##### flags 17
> [342252.264736] BTRFS info (device dm-4): found 67 extents
> [342266.630318] BTRFS info (device dm-4): found 67 extents
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Calvin Walton <calvin.walton@kepstin.ca>
