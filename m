Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58999 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3I1Xqn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 19:46:43 -0400
Received: by mail-ie0-f174.google.com with SMTP id u16so7067930iet.19
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 16:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Sun, 29 Sep 2013 01:46:23 +0200
Message-ID: <CAEx9m450LqPOH=2tmSss=njScuY4yC4eBhwJDsTF-+jv97C_Vg@mail.gmail.com>
Subject: Re: Questions regarding logging upon fsync in btrfs
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am using linux kernel 3.1.10-1.16, just to let you know.

Thanks

On 29 September 2013 01:35, Aastha Mehta <aasthakm@gmail.com> wrote:
> Hi,
>
> I have few questions regarding logging triggered by calling fsync in BTRFS:
>
> 1. If I understand correctly, fsync will call to log entire inode in
> the log tree. Does this mean that the data extents are also logged
> into the log tree? Are they copied into the log tree, or just
> referenced? Are they copied into the subvolume's extent tree again
> upon replay?
>
> 2. During replay, when the extents are added into the extent
> allocation tree, do they acquire the physical extent number during
> replay? Does they physical extent allocated to the data in the log
> tree differ from that in the subvolume?
>
> 3. I see there is a mount option of notreelog available. After
> disabling tree logging, does fsync still lead to flushing of buffers
> to the disk directly?
>
> 4. Is it possible to selectively identify certain files in the log
> tree and flush them to disk directly, without waiting for the replay
> to do it?
>
> Thanks
>
> --
> Aastha Mehta



-- 
Aastha Mehta
