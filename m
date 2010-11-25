From: David Nicol <davidnicol@gmail.com>
Subject: VFS support for fast copy on deduplicating FSes
Date: Thu, 25 Nov 2010 04:19:17 -0600
Message-ID: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

unresearched question/suggestion:

Is there general support for a "fast copy" ioctl in the VFS layer,
which would be hooked by file systems that support COW or other forms
of deduplication and can provide copy semantics by manipulating
metadata only?

-- 
"It is merely a matter of persistence." -- Albert Camus
