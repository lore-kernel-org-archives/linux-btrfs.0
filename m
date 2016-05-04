Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34117 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbcEDQbq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 12:31:46 -0400
Received: by mail-lf0-f68.google.com with SMTP id m101so6562820lfi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 09:31:45 -0700 (PDT)
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
 <pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
 <f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
 <pan$6ee8b$a34d8ed2$894ceb38$41a8085e@cox.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <572A23EE.5010902@gmail.com>
Date: Wed, 4 May 2016 19:31:42 +0300
MIME-Version: 1.0
In-Reply-To: <pan$6ee8b$a34d8ed2$894ceb38$41a8085e@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.05.2016 18:54, Duncan пишет:
> Niccolò Belli posted on Wed, 04 May 2016 15:52:39 +0200 as excerpted:
> 
>> Thanks,
>> Now my fstab option are
>> rw,noatime,compress=lzo,discard,autodefrag,subvolid=257,subvol=/@
>> I tried to add rootflags=noatime,compress=lzo,discard,autodefrag to
>> GRUB_CMDLINE_LINUX in /etc/default/grub as you suggested but my system
>> didn't manage to boot, probably because grub automatically adds
>> rootflags=subvol=@ and only a single rootflags can be taken into
>> account.
>> Do you have any suggestion?
> 
> What about the subvol=/@?
> 
> I think if you specifically add your own rootflags, grub won't add its 
> own, and you said
> 

It will, but it will prepend it to GRUB_CMDLINE_LINUX and last
occurrence on kernel command line should win, so rootflags from
GRUB_CMDLINE_LINUX should be used.

> noatime,compress=lzo,discard,autodefrag
> 
> but left off the subvol=/@ (unless you simply forgot to put it in the 
> posting), and without that, it would have mounted the btrfs default 
> subvolume, which would be (the filesystem's) / (subvolid=5) if you 
> haven't changed it, and would have failed to boot as a result.
> 

But if I understand it correctly, GRUB already adds correct subvolume,
and none of listed options should cause failure to boot.
