Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3INL0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Sep 2013 07:26:25 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8EBQOHt008806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Sep 2013 07:26:25 -0400
Received: from [10.36.4.106] (vpn1-4-106.ams2.redhat.com [10.36.4.106])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r8EBQMoA012685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Sep 2013 07:26:24 -0400
Message-ID: <523447DE.1080507@redhat.com>
Date: Sat, 14 Sep 2013 13:26:22 +0200
From: Harald Hoyer <harald@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow mounting btrfs subvolumes with different
 ro/rw options
References: <1371569344-2978-1-git-send-email-harald@redhat.com> <52246E91.2050500@redhat.com>
In-Reply-To: <52246E91.2050500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/2013 12:55 PM, Harald Hoyer wrote:
> On 06/18/2013 05:29 PM, harald@redhat.com wrote:
>> From: Harald Hoyer <harald@redhat.com>
>>
>> Given the following /etc/fstab entries:
>>
>> /dev/sda3 /mnt/foo btrfs subvol=foo,ro 0
>> /dev/sda3 /mnt/bar btrfs subvol=bar,rw 0
>>
>> you can't issue:
>>
>> $ mount /mnt/foo
>> $ mount /mnt/bar
>>
>> You would have to do:
>>
>> $ mount /mnt/foo
>> $ mount -o remount,rw /mnt/foo
>> $ mount --bind -o remount,ro /mnt/foo
>> $ mount /bar
>>
>> or
>>
>> $ mount /mnt/bar
>> $ mount --rw /mnt/foo
>> $ mount --bind -o remount,ro /mnt/foo
>>
>> With this patch you can do
>>
>> $ mount /mnt/foo
>> $ mount /mnt/bar
>>
>> $ cat /proc/self/mountinfo
>> 49 33 0:41 /foo /mnt/foo ro,relatime shared:36 - btrfs /dev/sda3 rw,ssd,space_cache
>> 87 33 0:41 /bar /mnt/bar rw,relatime shared:74 - btrfs /dev/sda3 rw,ssd,space_cache
>> ---
>>  fs/btrfs/super.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index f0857e0..80ed3e2 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -64,6 +64,8 @@
>>  static const struct super_operations btrfs_super_ops;
>>  static struct file_system_type btrfs_fs_type;
>>  
>> +static int btrfs_remount(struct super_block *sb, int *flags, char *data);
>> +
>>  static const char *btrfs_decode_error(int errno)
>>  {
>>  	char *errstr = "unknown";
>> @@ -1036,6 +1038,26 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
>>  	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
>>  			     newargs);
>>  	kfree(newargs);
>> +
>> +	if (PTR_RET(mnt) == -EBUSY) {
>> +		if (flags & MS_RDONLY) {
>> +			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY, device_name,
>> +					     newargs);
>> +		} else {
>> +			int r;
>> +			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY, device_name,
>> +					     newargs);
>> +			if (IS_ERR(mnt))
>> +				return ERR_CAST(mnt);
>> +
>> +			r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
>> +			if (r < 0) {
>> +				/* FIXME: release vfsmount mnt ??*/
>> +				return ERR_PTR(r);
>> +			}
>> +		}
>> +	}
>> +
>>  	if (IS_ERR(mnt))
>>  		return ERR_CAST(mnt);
>>  
>>
> 
> Any comments?
> 

Not even a "no, we don't want that" ?
