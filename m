Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hr2.samba.org ([144.76.82.148]:41950 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965131AbeGBLZ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 07:25:28 -0400
Date: Mon, 2 Jul 2018 13:07:26 +0200
From: David Disseldorp <ddiss@samba.org>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] btrfs-progs: lowmem: delay before lowmem repair
Message-ID: <20180702130726.21a3257d@samba.org>
In-Reply-To: <93c08062-8368-616f-f8c6-5ff8616aad08@suse.com>
References: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
        <93c08062-8368-616f-f8c6-5ff8616aad08@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2 Jul 2018 12:43:20 +0300, Nikolay Borisov wrote:

> On  2.07.2018 12:28, Su Yue wrote:
> > Since lowmem repair is dangerous, it should remind user more obviously.
> > The patchset add 10 seconds delay like btrfs balance and add am option
> > '--force-repair-lowmem' to skip the delay.  
> 
> IMO this is the wrong way to approach a dangerous option. If it's so
> dangerous it needs to be written in the documentation explicitly this is
> so. If someone wants to use lowmem then they should explicitly set
> --mode lowmem. So I'm inclined to NACK this patch.

AFAICT it's already documented as "experimental" in the manpage, but the
usage flag appears to have been dropped as part of refactoring for
87c1bd13c1fca430c3dbf0da62e9aa33bde609c8 . If nobody's working on a fix,
and lowmem removal isn't an option, then please consider adding the usage
flag back, e.g.
--- a/check/main.c
+++ b/check/main.c
@@ -9386,7 +9386,7 @@ const char * const cmd_check_usage[] = {
        "                            original - read inodes and extents to memory (requires",
        "                                       more memory, does less IO)",
        "                            lowmem   - try to use less memory but read blocks again",
-       "                                       when needed",
+       "                                       when needed (experimental)",
        "--check-data-csum           verify checksums of data blocks",
        "-Q|--qgroup-report          print a report on qgroup consistency",
        "-E|--subvol-extents <subvolid>",

Cheers, David
