Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:48506 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbBPF7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 00:59:42 -0500
Received: by mail-yk0-f179.google.com with SMTP id 9so12420112ykp.10
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 21:59:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E05DCD.3050508@richtercloud.de>
References: <54E05DCD.3050508@richtercloud.de>
Date: Sun, 15 Feb 2015 22:59:41 -0700
Message-ID: <CAJCQCtSSeSbb9r=f830k=5UjKkw=3huE6H_o3oqNWYg2UFJTwg@mail.gmail.com>
Subject: Re: btrfs check --init-csum-tree removes csums again
From: Chris Murphy <lists@colorremedies.com>
To: Karl-Philipp Richter <richter@richtercloud.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 15, 2015 at 1:50 AM, Karl-Philipp Richter
<richter@richtercloud.de> wrote:
> Hi,
> After running `btrfs check --init-csum-tree` 3.18.2 and 3.19-rc2 on a
> btrfs all checksums are gone (thousands of line in the form of `no csum
> found for inode X start Y` in `/var/log/kern.log`). I know that this
> behavior (to delete all csums) was a stub in a dev version and remember
> that it was fixed and that I even fixed a csum tree at one point. Could
> someone please confirm and maybe even point me to a working version?

I just tried this on CentOS 7 with kernel-3.19-0 and
btrfs-progs-3.18.2 (from Fedora 21) and it rebuilt the csums, and took
a little while to do it, unlike 3.12 which was very fast by just
removing the csums. So... worksforme. However I used it with --repair,
not by itself.


-- 
Chris Murphy
