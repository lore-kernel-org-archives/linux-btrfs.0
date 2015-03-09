Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbbCIKiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 06:38:24 -0400
Date: Mon, 9 Mar 2015 11:38:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH] btrfs-progs: use less memory for pretty_size_mode buffers
Message-ID: <20150309103822.GA5841@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425062244-14807-1-git-send-email-dsterba@suse.cz>
 <54F9FE3A.4030405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54F9FE3A.4030405@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 06, 2015 at 02:21:30PM -0500, Anand Jain wrote:
> Program received signal SIGSEGV, Segmentation fault.
> 0x00000800007caf18 in __vsnprintf_chk () from /lib64/libc.so.6
> Missing separate debuginfos, use: debuginfo-install 
> glibc-2.12-1.132.0.8.el6.sparc64 libblkid-2.17.2-12.14.0.2.el6.sparc64 
> libuuid-2.17.2-12.14.0.2.el6.sparc64 lzo-2.03-3.1.el6.1.sparc64 
> zlib-1.2.3-29.el6.sparc64

Thanks for testing. Is it the same error as before? IOW if the patch
hellped to reduce the stack usage or if it's a bug in the patch itself.
