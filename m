Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab2EUFfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 01:35:37 -0400
Message-ID: <4FB9D3CD.8010303@cn.fujitsu.com>
Date: Mon, 21 May 2012 13:34:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, sbehrens@giantdisaster.de
Subject: Re: [PATCH 4/5] Btrfs: cancel the scrub when remounting a fs to ro
References: <4FB4E7DD.8020802@cn.fujitsu.com> <20120518125207.GI24394@twin.jikos.cz>
In-Reply-To: <20120518125207.GI24394@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 May 2012 14:52:07 +0200, David Sterba wrote:
> On Thu, May 17, 2012 at 07:58:21PM +0800, Miao Xie wrote:
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1151,6 +1151,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>>  		/* pause restriper - we want to resume on remount to r/w */
>>  		btrfs_pause_balance(root->fs_info);
>>  
>> +		btrfs_scrub_cancel(root);
> 
> Can we possibly switch scrub to readonly instead ? I'm not sure what's
> the 'least surprise here', whether to cancel everything on the
> filesystem upon ro-remount or just the minimal set of operations (and
> leave the rest running if possible).

I don't think it is better to switch scrub to readonly soundlessly, because
it is not the operation that the users expect if they don't choose the readonly
mode.

BTW, I think we needn't cancel the readonly scrub on the filesystem upon ro-remount.

Thanks
Miao

> 
> Looking at the scrub code, if dev->readonly is set, no repairs are done,
> so the only concern is to wait for any outstanding IOs and then switch
> to RO.
> 
> 
> david
> 

