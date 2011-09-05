From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH] Btrfs-progs: added btrfs filesystem label [label] [path]
 support V2
Date: Mon, 05 Sep 2011 13:34:46 +0800
Message-ID: <4E645F76.5040505@oracle.com>
References: <4E5F47C7.3030803@oracle.com> <4E5F7216.7040909@oracle.com> <20110902125208.GF11678@ds.suse.cz> <4E60D67E.2070903@oracle.com> <20110902154810.GH11678@ds.suse.cz> <46CBCF59-89E1-4A80-B85D-17C65F695247@oracle.com> <20110904170301.GE9907@carfax.org.uk>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>, lizf@cn.fujitsu.com
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110904170301.GE9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2011 01:03 AM, Hugo Mills wrote:
> On Sat, Sep 03, 2011 at 11:11:36AM +0800, Jeff liu wrote:
>> =E5=9C=A8 2011-9-2=EF=BC=8C=E4=B8=8B=E5=8D=8811:48=EF=BC=8C David St=
erba =E5=86=99=E9=81=93=EF=BC=9A
>>> On Fri, Sep 02, 2011 at 09:13:34PM +0800, Jeff Liu wrote:
>>>> --- a/ioctl.h
>>>> +++ b/ioctl.h
>>>> @@ -140,6 +140,8 @@ struct btrfs_ioctl_space_args {
>>>>                     struct btrfs_ioctl_vol_args)
>>>> #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>>>>                     struct btrfs_ioctl_vol_args)
>>>> +#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 5, \
>>>> +                   struct btrfs_ioctl_fs_label_args)
>>>> /* trans start and trans end are dangerous, and only for
>>>>   * use by applications that know how to avoid the
>>>>   * resulting deadlocks
>>> well, it is an unassigned number, but a newly added features should=
 IMHO
>>> allocate greater than current max value, ie over 31 in coordination=
 with
>>>
>>> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_n=
otes.2C_please_read
>>>
>>> table.
>> It sounds reasonable to allocate a greater value, could anyone pleas=
e confirm it?
>     I'd just take number 50 for yours -- Li can update his patches
> later.
Thank you, I'll post a patch for this change later.

-Jeff
>     Hugo.
>
>> What's your ioctl range for online fsck?

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
