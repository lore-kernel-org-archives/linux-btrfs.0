Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:49678 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbbBVS0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 13:26:39 -0500
Message-ID: <54EA1F5A.7010802@pobox.com>
Date: Sun, 22 Feb 2015 10:26:34 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: scrub problem
References: <CABgvyo__OdS8N=Gwf-n58FTViyOi5ZWOcchud+Hmt1JfD8pNpw@mail.gmail.com> <54E7A128.1060603@barrowhillfarm.org.uk>
In-Reply-To: <54E7A128.1060603@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2015 01:03 PM, Bob Williams wrote:
> /var/lib/btrfs/scrub.status.0b07b829-9a0e-44ab-89ee-14b36a45199e
>
> (the last bit of the filename is the filesystem uuid)
>
> Look for a line that ends with "finished:0" and change it to say
> "finished:1"

Why does this data item even exist? The filesystem/kernel should know 
whether a scrub is ongoing. Isn't is universally cheaper to do the 
single IOCTL to ask the kernel whether a scrub is ongoing compared to 
the open-and-parse of this file?

