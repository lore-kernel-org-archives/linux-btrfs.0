Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52539 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3BUPUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:20:39 -0500
Received: by mail-lb0-f172.google.com with SMTP id n8so6992810lbj.31
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 07:20:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130220142612.GA2062@localhost.localdomain>
References: <20130220142612.GA2062@localhost.localdomain>
Date: Thu, 21 Feb 2013 07:20:37 -0800
Message-ID: <CADU+-uBHcLUQQiv526xTheB_csCq5-fXOHgJbXCAZG9t5z2xdQ@mail.gmail.com>
Subject: Re: LAST CALL FOR BTRFS-NEXT
From: Filipe Brandenburger <filbranden@google.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Please remove the following patch:

Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h
(55e301fd57a6239ec14b91a1cf2e70b3dd135194 in your btrfs-next.git)

It's not fully cooked and I'm working on a second version of the patch
that will do a little more rearranging of the header files according
to the discussion on IRC a while ago.

Thanks,
Filipe


On Wed, Feb 20, 2013 at 6:26 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> Hello,
>
> If you have patches in btrfs-next, make sure they are the right ones so we don't
> have to rebase and repull and merge and all that crap for this merge window.  If
> I'm missing stuff that's fine, I can throw that on top, but you need to make
> sure I have the right versions of stuff already in the tree so I can rebase it
> _now_ rather than trying to figure out how to fix it later.  Thanks!
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
