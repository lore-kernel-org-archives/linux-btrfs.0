Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44982 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2EUCNf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 22:13:35 -0400
Message-ID: <4FB9A5D5.7040805@cn.fujitsu.com>
Date: Mon, 21 May 2012 10:17:57 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: do not resize a seeding device
References: <1337256489-20887-1-git-send-email-liubo2009@cn.fujitsu.com> <20120518130123.GJ24394@twin.jikos.cz>
In-Reply-To: <20120518130123.GJ24394@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/18/2012 09:01 PM, David Sterba wrote:

> On Thu, May 17, 2012 at 08:08:08PM +0800, Liu Bo wrote:
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1303,6 +1303,13 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>>  		ret = -EINVAL;
>>  		goto out_free;
>>  	}
>> +	if (device->fs_devices && device->fs_devices->seeding) {
>> +		printk(KERN_INFO "btrfs: resizer unable to apply on "
>> +		       "seeding device %s\n", device->name);
>> +		ret = -EACCES;
> 
> I think EINVAL would be more appropriate. EACCESS is about permissions
> which do not make much sense in context of resizing devices, besides
> that CAP_SYS_ADMIN is required anyway (and checked a few lines above).
> 


That's true, I'll follow your advice.

CAP_SYS_ADMIN has already been there. :)

And thanks for reviewing this.

thanks,
liubo

> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


