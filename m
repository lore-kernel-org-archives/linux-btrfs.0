Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbKIRxp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Nov 2015 12:53:45 -0500
Date: Mon, 9 Nov 2015 18:52:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Victor <services@swwu.com>
Cc: linux-btrfs@vger.kernel.org, spender@grsecurity.net, pageexec@freemail.hu,
        re.emese@gmail.com
Subject: Re: overflow in inode.c, file.c
Message-ID: <20151109175210.GA6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <fdb1fe411a9aa68d196737cbee851a1b@swwu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <fdb1fe411a9aa68d196737cbee851a1b@swwu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for the report (and the reports on the forums),

On Thu, Oct 22, 2015 at 01:36:46AM +0200, Victor wrote:
> Hello, while using linux-⁠4.2.3 (btrfs-⁠progs v4.2.2) with the latest
> grsec patch to date, a feature in the grsec patchset, an overflow
> checker (made by emese) seems to have found some bugs in the btrfs
> code itself (this is not caused by grsec).
> 
> First bug: fs/⁠btrfs/⁠inode.c:5759

https://patchwork.kernel.org/patch/7582351/

> Second bug: fs/⁠btrfs/⁠file.c:1871

https://patchwork.kernel.org/patch/7585611/

> This is the whole dmesg http://pastebin.com/S9gjYpYX , thanks

The logs helped, thanks.
