Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34247 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab2ERR50 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 13:57:26 -0400
Received: by pbbrp8 with SMTP id rp8so4250923pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 10:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB5C563.9050203@cn.fujitsu.com>
References: <4FB522EC.50305@gmail.com>
	<4FB5C563.9050203@cn.fujitsu.com>
Date: Fri, 18 May 2012 21:57:25 +0400
Message-ID: <CAExpLJgfCGzadZGs0xxp0p7G-14bwwrMH6u5JN=py6uYFRSM6Q@mail.gmail.com>
Subject: Re: trim malfunction in linux 3.3.6
From: Sergey Kolesnikov <rockingdemon@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello.

2012/5/18 Liu Bo <liubo2009@cn.fujitsu.com>
>
> On 05/18/2012 12:10 AM, Sergey E. Kolesnikov wrote:
> Could you please show some logs about the corrpution?

Ugh. Sorry, but logs got corrupted too :-(
Today I've tested 3.4-rc7 kernel and everything seems to be fine.
May be fix mentioned by Tomasz should be ported back to 3.3.x since it
is current stable release and this bug is really dangerous.


Thanks,
Sergey.
