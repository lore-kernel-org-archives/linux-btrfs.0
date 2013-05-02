Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:34176 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3EBW6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 18:58:01 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Re: btrfs subv list -> ERROR: Failed to lookup path for root 0 - No such file or directory
Date: Fri, 3 May 2013 08:57:55 +1000
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CADn-QaPVg6C3sMhkasZc+JsoaQ_YQJB-nnoQRKd+XW7sXc1tew@mail.gmail.com>
In-Reply-To: <CADn-QaPVg6C3sMhkasZc+JsoaQ_YQJB-nnoQRKd+XW7sXc1tew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201305030857.55917.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 3 May 2013, Alexander Skwar <alexanders.mailinglists+nospam@gmail.com> 
wrote:
> Hello
> 
> I'm on Ubuntu 13.04 with Ubuntu kernel 3.8.0-19-lowlatency and
> Btrfs v0.20-rc1.
> 
> Sometimes, I'm unable to list the subvolumes of a filesystem, like so:
> 
> root@ask-home:~# btrfs subv list /home
> ERROR: Failed to lookup path for root 0 - No such file or directory

I asked a similar question about 10 days ago and got the below response which 
solved it for me.

On Thu, 25 Apr 2013, Wang Shilong <wangsl-fnst@cn.fujitsu.com> wrote:
> This problem has been fixed.Would you please try the latest btrfs-progs,
> and see it this problem happens again.
> 
> Btrfs-progs commitid: 64edc851da59c47b92ee6830101be0854add7f09 fix this
> problem. The latest btrfs-progs url:
> http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
