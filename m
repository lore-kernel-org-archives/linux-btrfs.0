Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:45990
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbbKMNSG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 08:18:06 -0500
Subject: Re: [PATCH v2] btrfs: properly set the termination value of ctx->pos
 in readdir
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1447418668-24817-1-git-send-email-dsterba@suse.com>
Cc: clm@fb.com, stable@vger.kernel.org
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5645E309.7050905@googlemail.com>
Date: Fri, 13 Nov 2015 14:18:01 +0100
MIME-Version: 1.0
In-Reply-To: <1447418668-24817-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/13/15 13:44, David Sterba wrote:
> The value of ctx->pos in the last readdir call is supposed to be set to
> INT_MAX due to 32bit compatibility, unless 'pos' is intentially set to a
> larger value, then it's LLONG_MAX.
> 
> There's a report from PaX SIZE_OVERFLOW plugin that "ctx->pos++"
> overflows (https://forums.grsecurity.net/viewtopic.php?f=1&t=4284), on a
> 64bit arch, where the value is 0x7fffffffffffffff ie. LLONG_MAX before
> the increment.
> 
> We can get to that situation like that:
> 
> * emit all regular readdir entries
> * still in the same call to readdir, bump the last pos to INT_MAX
> * next call to readdir will not emit any entries, but will reach the
>   bump code again, finds pos to be INT_MAX and sets it to LLONG_MAX
> 
> Normally this is not a problem, but if we call readdir again, we'll find
> 'pos' set to LLONG_MAX and the unconditional increment will overflow.
> 
> The report from Victor at
> (http://thread.gmane.org/gmane.comp.file-systems.btrfs/49500) with debugging
> print shows that pattern:
> 
>  Overflow: e
>  Overflow: 7fffffff
>  Overflow: 7fffffffffffffff
>  PAX: size overflow detected in function btrfs_real_readdir
>    fs/btrfs/inode.c:5760 cicus.935_282 max, count: 9, decl: pos; num: 0;
>    context: dir_context;
>  CPU: 0 PID: 2630 Comm: polkitd Not tainted 4.2.3-grsec #1
>  Hardware name: Gigabyte Technology Co., Ltd. H81ND2H/H81ND2H, BIOS F3 08/11/2015
>   ffffffff81901608 0000000000000000 ffffffff819015e6 ffffc90004973d48
>   ffffffff81742f0f 0000000000000007 ffffffff81901608 ffffc90004973d78
>   ffffffff811cb706 0000000000000000 ffff8800d47359e0 ffffc90004973ed8
>  Call Trace:
>   [<ffffffff81742f0f>] dump_stack+0x4c/0x7f
>   [<ffffffff811cb706>] report_size_overflow+0x36/0x40
>   [<ffffffff812ef0bc>] btrfs_real_readdir+0x69c/0x6d0
>   [<ffffffff811dafc8>] iterate_dir+0xa8/0x150
>   [<ffffffff811e6d8d>] ? __fget_light+0x2d/0x70
>   [<ffffffff811dba3a>] SyS_getdents+0xba/0x1c0
>  Overflow: 1a
>   [<ffffffff811db070>] ? iterate_dir+0x150/0x150
>   [<ffffffff81749b69>] entry_SYSCALL_64_fastpath+0x12/0x83
> 
> The jump from 7fffffff to 7fffffffffffffff happens when new dir entries
> are not yet synced and are processed from the delayed list. Then the code
> could go to the bump section again even though it might not emit any new
> dir entries from the delayed list.
> 
> The fix avoids entering the "bump" section again once we've finished
> emitting the entries, both for synced and delayed entries.
> 
> References: https://forums.grsecurity.net/viewtopic.php?f=1&t=4284
> Reported-by: Victor <services@swwu.com>
> CC: stable@vger.kernel.org
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> v2:
> - the delayed inodes emit dir entries as well, pass the status back to
>   readdir

This v2 works for me again, so:

Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

