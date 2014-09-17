Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40451 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaIQJnB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 05:43:01 -0400
Message-ID: <541958A2.1030204@oracle.com>
Date: Wed, 17 Sep 2014 17:47:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Sam Thursfield <sam.thursfield@codethink.co.uk>,
        linux-btrfs@vger.kernel.org, baserock-dev@baserock.org
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <541839E5.5030006@fb.com>
In-Reply-To: <541839E5.5030006@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Chris,


>> -------
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e9676a4..1224b61 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -533,7 +533,7 @@ static noinline int device_list_add(const char *path,
>>                   * the btrfs dev scan cli, after FS has been mounted.
>>                   */
>>                  if (fs_devices->opened) {
>> -                       return -EBUSY;
>> +                       goto out;
>>                  } else {
>>                          /*
>>                           * That is if the FS is _not_ mounted and if you
>> @@ -566,6 +566,7 @@ static noinline int device_list_add(const char *path,
>>          if (!fs_devices->opened)
>>                  device->generation = found_transid;
>>
>> +out:
>>          *fs_devices_ret = fs_devices;
>>
>>          return ret;
>
> Anand, are you planning on sending a full patch out for this?  One concern
> I have is that after the device_list_add call:
>
>
>      if (!ret && fs_devices_ret)
>              (*fs_devices_ret)->total_devices = total_devices;
>
> We should only be doing this from the newest super, not blindly overwriting.
> But that's a merge window fix.  For now I just want to deal with the regression,
> and your patch above looks good.
>
> Thanks for jumping on this one.


  Sorry for the trouble.
  yes, I will be sending a full patch. I am finding too difficult
  to revive the function btrfs_scan_one_device() which is predominately
  to handle device scan and list_update _before_ any mount. Further
  to the concern which you mention above, there is Ioctl
  BTRFS_IOC_DEV_READY also using this function, which absolutely should
  not have any intention to update the device list, but it does ..
  theoretically. And I note that this ioctl is used by systemd as well.
  So the fix is getting a bit complicated. I am attempting.

Thanks, Anand

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
