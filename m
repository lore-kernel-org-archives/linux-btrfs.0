Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaFEIDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 04:03:16 -0400
Date: Thu, 5 Jun 2014 10:03:11 +0200
From: Karel Zak <kzak@redhat.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: util-linux@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] mount: add btrfs to mount.8
Message-ID: <20140605080311.GW9000@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2014 at 10:05:19AM +0800, Gui Hecheng wrote:
> Based on Documentation/filesystems/btrfs.txt
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  sys-utils/mount.8 | 186 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 186 insertions(+)

 Thanks, but I'm not sure this is the right way. It would be better to
 create BTRFS specific btrfs.5 man page and maintain it together with
 another BTRFS stuff rather then within util-linux. In the mount.8
 should be only a note about btrfs.5.

 My long time goal is to remove all FS specific sections (at least for
 mainstream filesystems) from mount.8, because we duplicate effort
 here. The primary and well maintained is usually kernel
 Documentation/filesystems/ and unfortunately FS developers don't care
 about mount.8 at all.

 The ideal solution would be to generate the FS man pages from kernel
 docs (for example from asciidoc etc.)

 See 6 years old discussions: http://marc.info/?t=122767310200002&r=1&w=2


    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
