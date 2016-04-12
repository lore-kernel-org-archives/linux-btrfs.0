Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37478 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbcDLT6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 15:58:34 -0400
Received: by mail-ig0-f176.google.com with SMTP id g8so31926470igr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 12:58:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYK=Hd5xvEXp-51JMD1_kMYfsHR9Pt3DRNoq+HTi=eTALg@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
	<CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
	<CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com>
	<CAJCQCtRiTcy3OSA60G=N7LMA3xEpjeqmxv+gNyv7E+HyvG68Mg@mail.gmail.com>
	<CAAcrkYK=Hd5xvEXp-51JMD1_kMYfsHR9Pt3DRNoq+HTi=eTALg@mail.gmail.com>
Date: Tue, 12 Apr 2016 13:58:33 -0600
Message-ID: <CAJCQCtQ1sJKVb2dKfF7E2+OgFQCO2nKM0gZon62xo8058JrwvA@mail.gmail.com>
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 9:48 AM, lenovomi <lenovomi@gmail.com> wrote:

> root@ubuntu:/home/ubuntu# btrfs restore -D -v  /dev/sda /mnt/usb/
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> Csum didn't match
> Couldn't read tree root
> Could not open root, trying backup super
> warning, device 2 is missing
> warning devid 2 not found already
> warning devid 3 not found already
> warning devid 4 not found already
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> Csum didn't match
> Couldn't read tree root
> Could not open root, trying backup super
> warning, device 2 is missing
> warning devid 2 not found already
> warning devid 3 not found already
> warning devid 4 not found already
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> checksum verify failed on 17802818387968 found FF45E2D3 wanted BFB02AEC
> Csum didn't match
> Couldn't read tree root
> Could not open root, trying backup super
>

Why are devices 2, 3, 4 missing? I think there's a known issue where
btrfs fi show might see drives as available that other tools won't
see. Try 'btrfs dev scan' and then repeat the restore command with -D
just to see if the missing device warnings go away. If devices are
missing, it's kinda hard to do a restore.


If these are hard drives, there should be supers 0, 1, 2 and they
should all be the same. But they may not be the same on each drive, so
it's worth checking:

btrfs-show-super -f <eachdevice>

And then also btrfs-find-root <anydevice>




-- 
Chris Murphy
