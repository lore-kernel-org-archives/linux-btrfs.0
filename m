Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30578 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETF7T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 01:59:19 -0400
Message-ID: <537AEFE7.5030203@oracle.com>
Date: Tue, 20 May 2014 14:02:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: all super blocks of the replaced disk must be
 scratched
References: <1395057486-4341-1-git-send-email-Anand.Jain@oracle.com> <20140320182154.GM29256@twin.jikos.cz>
In-Reply-To: <20140320182154.GM29256@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 21/03/14 02:21, David Sterba wrote:
> On Mon, Mar 17, 2014 at 07:58:06PM +0800, Anand Jain wrote:
>> In a normal scenario when sys-admin replaces a disk, the
>> expeted is btrfs will release the disk completely.
>>
>> However the below test case gives a wrong impression that
>> replaced disk is still is in use.
>>
>> $ btrfs rep start /dev/sde /dev/sdg4 /btrfs
>> $ mkfs.btrfs /dev/sde
>> /dev/sde appears to contain an existing filesystem (btrfs).
>> Error: Use the -f option to force overwrite.
>
> (your signed-off is missing)
>
> Reviewed-by: David Sterba <dsterba@suse.cz>
>
> I've noticed that btrfs_rm_device also cleans only the first superblock
> signature, so it should do the same.

  A separate patch was generated for this
    btrfs: btrfs_rm_device() should zero mirror SB as well


Thanks, Anand


> I can't think of any drawback where all the superblocks are scratched,
> should be safe.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
