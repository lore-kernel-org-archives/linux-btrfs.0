Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33675 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdGAOYx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jul 2017 10:24:53 -0400
Received: by mail-qk0-f180.google.com with SMTP id v143so35803291qkb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jul 2017 07:24:53 -0700 (PDT)
From: =?utf-8?Q?Sidney_San_Mart=C3=ADn?= <sidney@s4y.us>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Very slow balance / btrfs-transaction
Message-Id: <17DC1389-F908-4BF0-AB06-96709166C615@s4y.us>
Date: Sat, 1 Jul 2017 10:24:49 -0400
Cc: jb@capsec.org
To: rgoldwyn@suse.com, linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

February 3, 2017 11:26 PM, "Goldwyn Rodrigues" <rgoldwyn@suse.com> wrote:
> On 02/03/2017 04:13 PM, jb@capsec.org wrote:
> > Hi, 
> > 
> > 
> > I'm currently running a balance (without any filters) on a 4 drives raid1 
> > filesystem. The array contains 3 3TB drives and one 6TB drive; I'm running 
> > the rebalance because the 6TB drive recently replaced a 2TB drive. 
> > 
> > 
> > I know that balance is not supposed to be a fast operation, but this one is 
> > now running for ~6 days and it managed to balance ~18% (754 out of about 4250 
> > chunks balanced (755 considered),  82% left) -- so I expect it to take 
> > another ~4 weeks. 
> > 
> > That seems excessively slow for ~8TiB of data.
> > 
> > 
> > Is this expected behavior? In case it's not: Is there anything I can do to 
> > help debug it?
> 
> Do you have quotas enabled?
> 
> -- 
> Goldwyn

Just dropping in — I don’t normally follow the list but I found this thread when I was troubleshooting balance issues (kernel 4.11, converting raid1 to raid10). Disabling quotas had an immense impact on performance and it would be helpful if notes could be added in *lots* of places. With quotas on, each block group took 30 minutes to over an hour to convert, and the system was only usable for a few seconds per iteration:

    Jun 28 00:42:41 overkill kernel: BTRFS info (device sdc2): relocating block group 7141922439168 flags data|raid1
    Jun 28 01:32:13 overkill kernel: BTRFS info (device sdc2): relocating block group 7140848697344 flags data|raid1
    Jun 28 02:48:59 overkill kernel: BTRFS info (device sdc2): relocating block group 7139774955520 flags data|raid1
    Jun 28 03:50:12 overkill kernel: BTRFS info (device sdc2): relocating block group 7138701213696 flags data|raid1
    Jun 28 05:20:58 overkill kernel: BTRFS info (device sdc2): relocating block group 7137627471872 flags data|raid1
    Jun 28 06:49:00 overkill kernel: BTRFS info (device sdc2): relocating block group 7136553730048 flags data|raid1
    Jun 28 07:23:58 overkill kernel: BTRFS info (device sdc2): relocating block group 7135479988224 flags data|raid1
    Jun 28 08:03:39 overkill kernel: BTRFS info (device sdc2): relocating block group 7134406246400 flags data|raid1
    Jun 28 08:40:11 overkill kernel: BTRFS info (device sdc2): relocating block group 7133332504576 flags data|raid1
    Jun 28 09:44:46 overkill kernel: BTRFS info (device sdc2): relocating block group 7132258762752 flags data|raid1
    Jun 28 10:24:17 overkill kernel: BTRFS info (device sdc2): relocating block group 7131185020928 flags data|raid1
    Jun 28 11:35:39 overkill kernel: BTRFS info (device sdc2): relocating block group 7130111279104 flags data|raid1
    Jun 28 12:53:56 overkill kernel: BTRFS info (device sdc2): relocating block group 7129037537280 flags data|raid1
    Jun 28 13:37:00 overkill kernel: BTRFS info (device sdc2): relocating block group 7127963795456 flags data|raid1
    Jun 28 14:32:19 overkill kernel: BTRFS info (device sdc2): relocating block group 7126890053632 flags data|raid1
    Jun 28 15:45:19 overkill kernel: BTRFS info (device sdc2): relocating block group 7125816311808 flags data|raid1
    Jun 28 16:30:01 overkill kernel: BTRFS info (device sdc2): relocating block group 7124742569984 flags data|raid1
    Jun 28 17:26:57 overkill kernel: BTRFS info (device sdc2): relocating block group 7123668828160 flags data|raid1
    Jun 28 18:15:01 overkill kernel: BTRFS info (device sdc2): relocating block group 7122595086336 flags data|raid1
    Jun 28 18:48:05 overkill kernel: BTRFS info (device sdc2): relocating block group 7121521344512 flags data|raid1
    Jun 28 19:25:59 overkill kernel: BTRFS info (device sdc2): relocating block group 7120447602688 flags data|raid1
    Jun 28 19:55:46 overkill kernel: BTRFS info (device sdc2): relocating block group 7119373860864 flags data|raid1
    Jun 28 20:30:41 overkill kernel: BTRFS info (device sdc2): relocating block group 7118300119040 flags data|raid1
    Jun 28 21:28:43 overkill kernel: BTRFS info (device sdc2): relocating block group 7117226377216 flags data|raid1
    Jun 28 22:55:34 overkill kernel: BTRFS info (device sdc2): relocating block group 7114005151744 flags data|raid1
    Jun 28 23:19:06 overkill kernel: BTRFS info (device sdc2): relocating block group 7110783926272 flags data|raid1

With quotas off, it takes ~20 seconds to convert each block group and the system is completely usable:

    Jul 01 09:56:42 overkill kernel: BTRFS info (device sde): relocating block group 7085014122496 flags data|raid1
    Jul 01 09:56:59 overkill kernel: BTRFS info (device sde): relocating block group 7083940380672 flags data|raid1
    Jul 01 09:57:18 overkill kernel: BTRFS info (device sde): relocating block group 7082866638848 flags data|raid1
    Jul 01 09:57:39 overkill kernel: BTRFS info (device sde): relocating block group 7081792897024 flags data|raid1
    Jul 01 09:58:01 overkill kernel: BTRFS info (device sde): relocating block group 7080719155200 flags data|raid1
    Jul 01 09:58:27 overkill kernel: BTRFS info (device sde): relocating block group 7079645413376 flags data|raid1
    Jul 01 09:58:45 overkill kernel: BTRFS info (device sde): relocating block group 7078571671552 flags data|raid1
    Jul 01 09:59:00 overkill kernel: BTRFS info (device sde): relocating block group 7077497929728 flags data|raid1
    Jul 01 09:59:16 overkill kernel: BTRFS info (device sde): relocating block group 7076424187904 flags data|raid1

Cheers,
Sidney