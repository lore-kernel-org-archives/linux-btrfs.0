Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55006 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2FOO26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 10:28:58 -0400
Received: by bkcji2 with SMTP id ji2so2450988bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2012 07:28:57 -0700 (PDT)
Message-ID: <1339770469.24514.22.camel@ierdnac-hp>
Subject: Re: [PATCH] Btrfs: add "nocompress" mount option
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: dave@jikos.cz
Cc: linux-btrfs@vger.kernel.org, arnd@arndnet.de
Date: Fri, 15 Jun 2012 17:27:49 +0300
In-Reply-To: <20120615105006.GV32402@twin.jikos.cz>
References: <1339754209.2212.22.camel@ierdnac-hp>
	 <20120615105006.GV32402@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2012-06-15 at 12:50 +0200, David Sterba wrote:
>   mount -o compress,nocompress /dev /mnt
> 
> Is it on or off? Yeah we can document that nocompress has higher
> priority. But then I can't turn a nocompress option back to compress via
> remount. This is possible with Arnd's patch.

This happens for space_cache mount option:
ierdnac-hp ~ # mount -o remount,space_cache,nospace_cache /mnt/btrfs/

Also there are mount option that can't be enabled/disabled by remount
like:
nobarrier - > "barrier" mount option doesn't exists
ssd -> "nossd" doesn't exists
noacl, user_subvol_rm_allowed, autodefrag, inode_cache, check_int,
check_int_data.

For some of these(ex: nossd,barrier) I think it would be usefull to have
the reverse action.
What do you think ?

Andrei


