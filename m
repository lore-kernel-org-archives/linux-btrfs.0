Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33122 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbCaDTT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 23:19:19 -0400
Received: by pdnc3 with SMTP id c3so6227652pdn.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 20:19:18 -0700 (PDT)
Date: Mon, 30 Mar 2015 20:19:17 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Robbie Ko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs Send/Receive "utime" error And "WARN_ON Cannot allocate
 memory"
Message-ID: <20150331031917.GA31032@mew.dhcp4.washington.edu>
References: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 11:06:10AM +0800, Robbie Ko wrote:
> Hi,
> 
> I have  testing btrfs send/receive recently.
> 
> I got an error "send ioctl failed with -12: Cannot allocate memory" on
> send side.
> WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.
> 
> I got an error "utime failed: No such file or directory" on receive side.
> The followings are simple reproduced steps and related information.
> 
> I have applied the following patch in the url :
> https://patchwork.kernel.org/patch/6113581/.
> However, it did not fix the problem.
> 
> Is there any  idea about what this might be or how to fix it?

[Bah, gave Gmail a chance to do plaintext and it blew it. Back to Mutt.]

Have you applied https://patchwork.kernel.org/patch/5996271/ as well?

-- 
Omar
