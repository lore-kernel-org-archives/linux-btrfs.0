From: Jeff liu <jeff.liu@oracle.com>
Subject: Re: [PATCH] Btrfs-progs: added btrfs filesystem label [label] [path] support V2
Date: Sat, 3 Sep 2011 11:11:36 +0800
Message-ID: <46CBCF59-89E1-4A80-B85D-17C65F695247@oracle.com>
References: <4E5F47C7.3030803@oracle.com> <4E5F7216.7040909@oracle.com> <20110902125208.GF11678@ds.suse.cz> <4E60D67E.2070903@oracle.com> <20110902154810.GH11678@ds.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=GB2312
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>, lizf@cn.fujitsu.com
To: dsterba@suse.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110902154810.GH11678@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>


=D4=DA 2011-9-2=A3=AC=CF=C2=CE=E711:48=A3=AC David Sterba =D0=B4=B5=C0=A3=
=BA

> On Fri, Sep 02, 2011 at 09:13:34PM +0800, Jeff Liu wrote:
>> --- a/ioctl.h
>> +++ b/ioctl.h
>> @@ -140,6 +140,8 @@ struct btrfs_ioctl_space_args {
>>                    struct btrfs_ioctl_vol_args)
>> #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>>                    struct btrfs_ioctl_vol_args)
>> +#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 5, \
>> +                   struct btrfs_ioctl_fs_label_args)
>> /* trans start and trans end are dangerous, and only for
>>  * use by applications that know how to avoid the
>>  * resulting deadlocks
>=20
> well, it is an unassigned number, but a newly added features should I=
MHO
> allocate greater than current max value, ie over 31 in coordination w=
ith
>=20
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_not=
es.2C_please_read
>=20
> table.

It sounds reasonable to allocate a greater value, could anyone please c=
onfirm it?

Hi Zefan,

What's your ioctl range for online fsck?


Thanks,
-Jeff

>=20
>=20
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
