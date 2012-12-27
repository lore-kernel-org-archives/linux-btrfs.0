Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20120 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2L0IJo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 03:09:44 -0500
Date: Thu, 27 Dec 2012 16:07:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Slava Barinov <rayslava@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BUG at fs/btrfs/locking.c:265
Message-ID: <20121227080728.GB20325@liubo.au.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CADef55rak5VxVePgXtBz8fVpnqaWh2gRAfnGgZQT2QATJ4AS+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADef55rak5VxVePgXtBz8fVpnqaWh2gRAfnGgZQT2QATJ4AS+Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 27, 2012 at 08:27:11AM +0400, Slava Barinov wrote:
> Hello,
> 
>   Twice for past two days I caught an error with btrfs, you can see a
> fragment of dmesg on http://paste.org.ru/?kz4x31 and
> http://paste.org.ru/?lwdeu3
> 
>   It's a buildserver with jenkins that several times an hour starts a
> test script. The only problem I could suppose is using "subvolume
> snapshot" feature in script. So, I have about two dozen of snapshots
> that refresh periodically.
> 
>   Also, I'd like to add small feature request: it'll be good for
> mount.btrfs  to show more valuable error messages. For example, if you
> try to mount btrfs volume with wrong default subvolume-id, mount.btrfs
> says:
> 
>  > mount: mount(2) failed: No such file or directory
> 
>   And there's nothing in dmesg that could help user to understand what
> happened. I've lost about ten minutes trying to understand what does
> it want from me.

Hi Slava,

Could you please show me what line does 'walk_down_proc+0x2b0/0x2e0 [btrfs]'
refer to?

thanks,
liubo
