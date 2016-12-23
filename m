Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i4.italiaonline.it ([212.48.25.215]:36674 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1760437AbcLWHRJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 02:17:09 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Fri, 23 Dec 2016 08:16:52 +0100
Message-ID: <2794788.M4CZ3odufj@exnet.gdb.it>
In-Reply-To: <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <CAJCQCtR0k9gr5XQ=5jUXYTFrntui3t6-tdf6uvAJpAV_ue6B0w@mail.gmail.com> <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(synthetic resend)

I'll try to compile the kernel and mount with the config and option enabled.

I keep in mind the side effects of that option.


Thanks for all.


P.S. Sorry for my bad English.



Chris Murphy ha scritto:
> On Wed, Dec 21, 2016 at 2:09 PM, Chris Murphy <lists@colorremedies.com> 
wrote:
> > What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
> > mount option?
> 
> This slows things down, and in that case it might avoid the problem if
> it's the result of a race condition.

