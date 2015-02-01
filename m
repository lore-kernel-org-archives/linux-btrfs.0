Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([37.247.49.240]:48345 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbbBARYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 12:24:19 -0500
Message-ID: <1422810946.4462.1.camel@miceliux.com>
Subject: Re: security.capability xattr missing after btrfs send/receive
From: Juan Orti <juan.orti@miceliux.com>
To: Jan Andres <jandres@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Date: Sun, 01 Feb 2015 18:15:46 +0100
In-Reply-To: <20150201121335.GA4599@pitr.home.jan>
References: <20150201121335.GA4599@pitr.home.jan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El dom, 01-02-2015 a las 13:13 +0100, Jan Andres escribió:
> I found that the security.capability xattr gets lost when cloning a
> subvolume via btrfs send | btrfs receive. This is easy to reproduce
> (currently on 3.19.0-rc6, x86_64, with btrfs-progs 3.18.1):
> 
> Have two btrfs file systems, "/fs1" and "/fs2".
> 
> # btrfs sub create /fs1/test
> # touch /fs1/test/foo
> # setcap cap_net_admin+ep /fs1/test/foo
> # getcap /fs1/test/foo
> /fs1/test/foo = cap_net_admin+ep
> # btrfs prop set /fs1/test ro true
> # btrfs send /fs1/test | btrfs receive /fs2
> # getcap /fs2/test/foo
> [reports nothing]
> 
> 
> The cause of the problem seems to be that BTRFS_SEND_C_SET_XATTR comes
> before BTRFS_SEND_C_CHMOD in the send stream, so that the receiving end
> will first correctly restore all the xattrs of the file, and after that,
> perform an lchown() which will cause the kernel to reset the
> file's capabilities.
> 
> I don't know how to fix this correctly (especially in the case of
> incremental sends), so I don't have a patch, but figured it might be
> useful to share what I found.

https://bugzilla.kernel.org/show_bug.cgi?id=68891

-- 
Juan Orti
https://miceliux.com

