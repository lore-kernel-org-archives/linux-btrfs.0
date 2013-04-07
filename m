Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35715 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765166Ab3DGB4k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 21:56:40 -0400
Received: by mail-oa0-f52.google.com with SMTP id k14so5212613oag.11
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Apr 2013 18:56:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANu+oN1szXCzLDqeT8UMCz660dO47dDTa8PTL1KFUoG6z-u_rQ@mail.gmail.com>
References: <CANu+oN1szXCzLDqeT8UMCz660dO47dDTa8PTL1KFUoG6z-u_rQ@mail.gmail.com>
Date: Sun, 7 Apr 2013 07:26:39 +0530
Message-ID: <CANu+oN1q-r2ti+uZs2_2Mg4_4J8gdNdtLedPAC3u5WZa=+jjFA@mail.gmail.com>
Subject: Re: [BUG] btrfs.fsck failing to fix corrupted block
From: Shripad Ratnaparkhi <shripad.ratnaparkhi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Replying to my own email]

Found a patch which seems to be discusses the fix in a patch provided here:
https://patchwork.kernel.org/patch/1946561/

Still now sure whether that is already there in v0.20-rc1 or
applicable to fix my issue.

thanks,
~shripadr

PS: BCC'ing the patch provider.

On Sun, Apr 7, 2013 at 7:16 AM, Shripad Ratnaparkhi
<shripad.ratnaparkhi@gmail.com> wrote:
> Hi there,
> I am newbie and recently started using btrfs. Now facing a weird problem.
>
> FWIW, I am on archlinux, kenel v3.8.0, having Btrfs v0.20-rc1.
> After an abnormal reboot, getting these errors while boot:
>
> systemd.fsck[289]: checking extents
> systemd.fsck[289]: checking fs roots
> systemd.fsck[289]: checking root refs
> systemd.fsck[289]: found 23728128 bytes used err is 0
> systemd.fsck[289]: total csum bytes: 23092
> systemd.fsck[289]: total tree bytes: 81920
> systemd.fsck[289]: total fs tree bytes: 24576
> systemd.fsck[289]: btree space waste bytes: 38038
> systemd.fsck[289]: file data blocks allocated: 23646208
> systemd.fsck[289]: referenced 23646208
> systemd.fsck[289]: Btrfs v0.20-rc1
> [   OK   ]  Started File System Check on /dev/sda1.
>                Mounting /boot...
> systemd.fsck[289]: checking extents
> [   OK   ] Mounted /boot.
> [   OK   ] Reached target Sound Card.
> systemd.fsck[289]: checking fs roots
> systemd.fsck[289]: checking root refs
> systemd.fsck[289]: extent buffer leak: start 206893056 len 4096
> systemd.fsck[289]: *** Error in `fsck.btrfs`: corrupted double-linked
> list: 0x0000000002081d80 ***
>
> and its not proceeding and stuck here.
> I have the rescue disk handy, but not sure how can I fix this issue.
> Any help please.
>
> thanks,
>
> --
> ~shripadr
