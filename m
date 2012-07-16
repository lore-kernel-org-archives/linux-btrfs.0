Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.servus.at ([193.170.194.20]:37772 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab2GPTEd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jul 2012 15:04:33 -0400
Message-ID: <50045DD4.3090305@oberhumer.com>
Date: Mon, 16 Jul 2012 20:30:44 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>
Subject: ANNOUNCE: linux-kernel-lzo-20120716 - update LZO
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <4F16DFB0.2060404@oberhumer.com>
In-Reply-To: <4F16DFB0.2060404@oberhumer.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I finally have prepared a small package that updates the LZO version
in the Linux kernel. Please get it from:

  http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-20120716.tar.gz

As stated in the README this version is significantly faster (typically more
than 2 times faster!) than the current version, has been thoroughly tested on
x86_64/i386/powerpc platforms and is intended to get included into the
official Linux 3.6 or 3.7 release.

I encourage all compression users to test and benchmark this new version,
and I also would ask some official LZO maintainer to convert the updated
source files into a GIT commit and possibly push it to Linus or linux-next.

Share and enjoy,
Markus

Signed-off-by: Markus F.X.J. Oberhumer" <markus@oberhumer.com>

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
