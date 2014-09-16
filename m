Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16510 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117AbaIPNYE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 09:24:04 -0400
Message-ID: <541839E5.5030006@fb.com>
Date: Tue, 16 Sep 2014 09:23:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        Sam Thursfield <sam.thursfield@codethink.co.uk>
CC: <linux-btrfs@vger.kernel.org>, <baserock-dev@baserock.org>
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com>
In-Reply-To: <54170F35.4040103@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/15/2014 12:09 PM, Anand Jain wrote:
> 
> Sam,
> 
>  Thanks for reporting. Can you apply the following diff
>  on top of 3.17rc5 and check if it helps.
> 
> -------
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e9676a4..1224b61 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -533,7 +533,7 @@ static noinline int device_list_add(const char *path,
>                  * the btrfs dev scan cli, after FS has been mounted.
>                  */
>                 if (fs_devices->opened) {
> -                       return -EBUSY;
> +                       goto out;
>                 } else {
>                         /*
>                          * That is if the FS is _not_ mounted and if you
> @@ -566,6 +566,7 @@ static noinline int device_list_add(const char *path,
>         if (!fs_devices->opened)
>                 device->generation = found_transid;
> 
> +out:
>         *fs_devices_ret = fs_devices;
> 
>         return ret;

Anand, are you planning on sending a full patch out for this?  One concern 
I have is that after the device_list_add call:


    if (!ret && fs_devices_ret)                                             
            (*fs_devices_ret)->total_devices = total_devices;

We should only be doing this from the newest super, not blindly overwriting.
But that's a merge window fix.  For now I just want to deal with the regression,
and your patch above looks good.

Thanks for jumping on this one.

-chris
