Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BAA3A1A27
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 22:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789509918; cv=none; b=KwaPAY8kdgoRYV3HC3IdkQtE80xmODhVIqVf+pXHZwSaH86It+owPBBYKQ8vuMgIjBFHJhI+pt/KEyb8GvdYB5O2DjLfKyhXBoDe0Ji1jIOCh4FICZLnRzo+bntvxRbjMt/ysyfgUEIxUy7YX1Jg1qoIp0tLFm/kGuLWCbHrg88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789509918; c=relaxed/simple;
	bh=lD9/nHhq2T8zHRClwjSOncyK6m3BqwLI/DdTyJSbim8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pL5WwrZMb8/Q1tI9Ri0/KKHrRa8aZLNGd9OKG+6ObVyXT5kjZ2sdLiO86ZuJq1q1BBRawrgARgINmuh3gPm2dlcvNIidXPJa3z3xpG8hOXqIjzHPW2LzyumYpy9A6/rvepK2u9c5ksGwLKrDnBhTPTEyEvlIkrSnRXTdJ4Z0CgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=A+UdNmAg; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="A+UdNmAg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789509913; x=1790114713; i=quwenruo.btrfs@gmx.com;
	bh=Huf68UDOI0dYIlnWVC7Fl1fQ/eTFrI1quoMzfz+RAXA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=A+UdNmAgy8EgSuZeaTxs1mrdHShVCu8MNY5rpfRYmnzzEr9T92Ff43i4XdYoM8X5
	 cHL+Y045MhsdtsCcCdldtiTeBxUy1roEU3QBR32V84IrSi2+05e9hVX2xN8SlYcli
	 GMRvm6v1AY0qcALaEWt6Tg4wE2UpoJcOXlIsjsWhleGI+T6myo9xhoZg+PlN18Qo+
	 JssxFVW2Qk3f3QfqAYhYKDs1x0JtqPs1naOMZHZnyYTqHDEdApK1Art3E6D8Kgq4z
	 k9SDPK2h8fkAa8QAeNgpoCV8uiKHiw+/hX8m+UOKD8oFSyE2/61h6zfG/jCw8ODWp
	 ahbsiWk7t9k1iGL5DA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MacSY-1wVctW0GLq-00ivk1; Wed, 16
 Sep 2026 00:05:13 +0200
Message-ID: <5a3895c8-57a7-4ffc-87f5-7dedf758dce9@gmx.com>
Date: Wed, 16 Sep 2026 07:35:06 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: introduce a new ioctl to force updating the
 device name
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <5e65d9ba5927b4b6985ce819e9e49d082c6e9b45.1789112424.git.wqu@suse.com>
 <20260915191659.GB910335@zen.localdomain>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260915191659.GB910335@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EDlOwCBKJSoFUjjoMq+GtgbymJK4V2DK8m84q6jlk3X5xsVuaNy
 oWC/VpuxEhNheIuzHf8xgdbx6DSyYTRJ0LAuJfMFDhJLML+fcGAPpvEi1TvMLuC+Anvvfnr
 LHncl9eRCHO+7pWcXmwKKMfwAn2IUlMgkfGkOMoUTE422RdIp+sawD6c1olIovbxcE4Kq8W
 1s+yJOGHmU6VH0OuTpKWw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aU0hYXeTEP0=;BSARiIdGPTO1U4oH0y3XBGjBQ1M
 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
 Rtxzb5bk5IFib



=E5=9C=A8 2026/9/16 04:46, Boris Burkov =E5=86=99=E9=81=93:
> On Fri, Sep 11, 2026 at 05:10:28PM +0930, Qu Wenruo wrote:
>> Btrfs has a very long history fighting to determine what is the proper
>> name to show in btrfs_show_devname().
>>
>> The long history includes:
>>
>> - 7e06de7c83a7 ("btrfs: canonicalize the device path before adding it")
>>    To address a report that a very weird path can be utilized to do the
>>    mount, and btrfs saves that weird path as the device name.
>>    But such a name cannot be accessed outside of a certain pid, so the =
end
>>    result is that the device shown in btrfs is completely meaningless.
>>
>>    That commit tries to canonicalize the path, but it is not good enoug=
h.
>>
>> - 2e8b6bc0ab41 ("btrfs: avoid unnecessary device path update for the sa=
me device")
>>    This is to address a lot of unnecessary device path updates caused b=
y
>>    different soft links of the same block device.
>>
>> - 8fb1dcbbcc1f ("Revert "btrfs: canonicalize the device path before add=
ing it"")
>>    This reverts the first patch.
>>
>>    The reason is that the "/dev/" directory is not guaranteed to be a
>>    devfs, it can be a regular directory with manually populated special
>>    files, and it can even be in a different name space, which means oth=
er
>>    namespaces may not see the same special file at all.
>>
>> - 108cc8733989 ("btrfs: fix a lockdep caused by path resolution during =
device scan")
>>    This one completely gets rid of the path based device check, to avoi=
d
>>    deadlock.
>>
>>    Since the "/dev/" is not ensured to be a devfs, one can put "/dev/"
>>    into a btrfs, and path resolution will lock the involved inode,
>>    meanwhile device scan also needs to lock that inode, which can lead =
to
>>    deadlock.
>>
>> - A recent report that the device name shown in mountinfo is incorrect
>>    This is another corner case where the end user is booting the kernel
>>    without an initramfs.
>>    So that at rootfs mount time, a special path "/dev/root" is passed a=
s
>>    the device for rootfs.
>>
>>    And a later btrfs device rescan won't update the device name since t=
he
>>    newer name points to the same devt.
>>
>> In short, unlike LVM which uses device-mapper and has a dedicated dm-*
>> device, btrfs has to directly manage the device names during mount/resc=
an
>> and all kinds of corner cases inside btrfs itself.
>>
>> Instead of handling all those hassles inside btrfs, push the
>> responsibility to end users, and provide a new ioctl to force updating
>> the btrfs device path.
>>
>> Now all the decisions are made by end users, they have every right to d=
o
>> stupid things (including namespace related hassles) or to replace
>> outdated device paths with a correct one.
>>
>> With this new ioctl and corresponding btrfs-progs changes, end users
>> finally have the proper way to update the weird names shown in
>> btrfs_show_devname():
>>
>>   # cd /dev
>>   # mknod weird b 253 3
>>   # mount /dev/weird /mnt/btrfs
>>   # mount | grep weird
>>   /dev/weird on /mnt/btrfs type btrfs (rw,relatime,discard=3Dasync,spac=
e_cache=3Dv2,subvolid=3D5,subvol=3D/)
>>   ^^^^^^^^^^ The weird name is still utilized here.
>>   # btrfs dev scan -r /dev/test/scratch1
>=20
> One thing that is slightly unclear to me is what the required connection
> between /dev/weird and /dev/test/scratch1 is. I would hope that they
> must resolve to the same device for this to work / make sense.

Yes, /dev/test/scratch1 points to dm-2, which has the same major:minor=20
number as /dev/weird

>=20
> Can you make that relationship a little more clear in this worked
> example by including some commands defining/printing /dev/test/scratch1?
>=20
>>   # dmesg -t | tail -n1
>>   BTRFS info: devid 1 device path /dev/weird changed to /dev/mapper/tes=
t-scratch1 scanned by btrfs (4068)
>>   # mount | tail -n1
>>   /dev/mapper/test-scratch1 on /mnt/btrfs type btrfs (rw,relatime,disca=
rd=3Dasync,space_cache=3Dv2,subvolid=3D5,subvol=3D/)
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v3:
>> - Remove the DEVICE_READY ioctl change
>>    That will break the kernel ABI, and there is really no special meani=
ng
>>    for using _IOW other than a different ioctl number.
>>
>> v2:
>> - Add a new patch to fix an existing bug in ioctl read/write direction
>>
>> - Use the correct _IOW for the new ioctl
>>    Exposed by Sashiko, and the older wrong direction was copied from th=
e
>>    only exception.
>> ---
>>   fs/btrfs/super.c           | 16 +++++++++++-----
>>   fs/btrfs/volumes.c         | 24 +++++++++++++++++-------
>>   fs/btrfs/volumes.h         |  6 +++++-
>>   include/uapi/linux/btrfs.h |  2 ++
>>   4 files changed, 35 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 464129b1b0d4..76c58a2e6d40 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -374,7 +374,7 @@ static int btrfs_parse_param(struct fs_context *fc,=
 struct fs_parameter *param)
>>   		struct btrfs_device *device;
>>  =20
>>   		mutex_lock(&uuid_mutex);
>> -		device =3D btrfs_scan_one_device(param->string, false);
>> +		device =3D btrfs_scan_one_device(param->string, 0);
>>   		mutex_unlock(&uuid_mutex);
>>   		if (IS_ERR(device))
>>   			return PTR_ERR(device);
>> @@ -1872,10 +1872,10 @@ static int btrfs_get_tree_super(struct fs_conte=
xt *fc)
>>   	mutex_lock(&uuid_mutex);
>>  =20
>>   	/*
>> -	 * With 'true' passed to btrfs_scan_one_device() (mount time) we expe=
ct
>> +	 * With BTRFS_SCAN_DEV_MOUNT passed to btrfs_scan_one_device() we exp=
ect
>>   	 * either a valid device or an error.
>>   	 */
>> -	device =3D btrfs_scan_one_device(fc->source, true);
>> +	device =3D btrfs_scan_one_device(fc->source, BTRFS_SCAN_DEV_MOUNT);
>>   	ASSERT(device !=3D NULL);
>>   	if (IS_ERR(device)) {
>>   		mutex_unlock(&uuid_mutex);
>> @@ -2270,7 +2270,7 @@ static long btrfs_control_ioctl(struct file *file=
, unsigned int cmd,
>>   		 * Scanning outside of mount can return NULL which would turn
>>   		 * into 0 error code.
>>   		 */
>> -		device =3D btrfs_scan_one_device(vol->name, false);
>> +		device =3D btrfs_scan_one_device(vol->name, 0);
>>   		ret =3D PTR_ERR_OR_ZERO(device);
>>   		mutex_unlock(&uuid_mutex);
>>   		break;
>> @@ -2288,7 +2288,7 @@ static long btrfs_control_ioctl(struct file *file=
, unsigned int cmd,
>>   		 * Scanning outside of mount can return NULL which would turn
>>   		 * into 0 error code.
>>   		 */
>> -		device =3D btrfs_scan_one_device(vol->name, false);
>> +		device =3D btrfs_scan_one_device(vol->name, 0);
>>   		if (IS_ERR_OR_NULL(device)) {
>>   			mutex_unlock(&uuid_mutex);
>>   			ret =3D PTR_ERR_OR_ZERO(device);
>> @@ -2298,6 +2298,12 @@ static long btrfs_control_ioctl(struct file *fil=
e, unsigned int cmd,
>>   			device->fs_devices->total_devices);
>>   		mutex_unlock(&uuid_mutex);
>>   		break;
>> +	case BTRFS_IOC_RENAME_DEV:
>> +		mutex_lock(&uuid_mutex);
>=20
> What privileges does this require? We don't check CAP_SYS_ADMIN or
> anything like it, but maybe being able to read the /dev/ files implies
> sufficient privilege? Somehow this feels similar enough to ADD_DEVICE
> that it ought to require CAP_SYS_ADMIN?

Makes sense.

Rename should have a higher privileges requirement, thus CAP_SYS_ADMIN=20
looks very reasonable.

>=20
>> +		device =3D btrfs_scan_one_device(vol->name, BTRFS_SCAN_DEV_RENAME);
>> +		ret =3D PTR_ERR_OR_ZERO(device);
>> +		mutex_unlock(&uuid_mutex);
>> +		break;
>>   	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>>   		ret =3D btrfs_ioctl_get_supported_features((void __user*)arg);
>>   		break;
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 4ddabadc9188..268bf10ab181 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -758,7 +758,7 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_supe=
r_block *sb)
>>    */
>>   static noinline struct btrfs_device *device_list_add(const char *path=
,
>>   			   struct btrfs_super_block *disk_super,
>> -			   bool *new_device_added)
>> +			   bool *new_device_added, bool force_rename)
>>   {
>>   	struct btrfs_device *device;
>>   	struct btrfs_fs_devices *fs_devices =3D NULL;
>> @@ -869,7 +869,7 @@ static noinline struct btrfs_device *device_list_ad=
d(const char *path,
>>   				MAJOR(path_devt), MINOR(path_devt),
>>   				current->comm, task_pid_nr(current));
>>  =20
>> -	} else if (!device->name || device->devt !=3D path_devt) {
>=20
> Going back to my question above, just to be sure I undertand:
>=20
> My understanding is that we get here when we found fs_devices by
> path_devt and then found device by devid. So the new force_rename is to
> use the new name when we find the device and the name is present and the
> devt matches.

Yes.

>=20
> So basically we use the new name for the same maj:min by force, which is
> the intended behavior.
>=20
> The part that is less clear is whether it is possible to hit any of the
> other scanning paths that modify the device by attempting the force rena=
me
> with some different device. Like if I craft a device with the right
> UUID, devid but wrong devt,

There is an existing branch, "if (device->devt !=3D path_devt)" for that=
=20
situation, and we just error out without adding the new device.

Thanks,
Qu

> then call this ioctl or something. If it
> gets to *this* code, it is probably ok anyway, but if it takes some
> other path, it could be messing with the core volume logic without
> enough permissions.
>=20
> Thanks,
> Boris
>=20
>> +	} else if (!device->name || device->devt !=3D path_devt || force_rena=
me) {
>>   		const char *old_name;
>>  =20
>>   		/*
>> @@ -882,9 +882,14 @@ static noinline struct btrfs_device *device_list_a=
dd(const char *path,
>>   		 *         different name. or
>>   		 *      b. The missing-disk-which-was-replaced, has
>>   		 *         reappeared now.
>> +		 *      c. A device scan is triggered on different soft links
>> +		 *         of the block device.
>>   		 *
>> -		 * We must allow 1 and 2a above. But 2b would be a spurious
>> -		 * and unintentional.
>> +		 * We must allow 1 and 2a above.
>> +		 * For 2c, we should only allow it when it's triggered from
>> +		 * BTRFS_IOC_RENAME_DEV.
>> +		 *
>> +		 * But 2b would be a spurious and unintentional.
>>   		 *
>>   		 * Further in case of 1 and 2a above, the disk at 'path'
>>   		 * would have missed some transaction when it was away and
>> @@ -1443,14 +1448,19 @@ static bool btrfs_skip_registration(struct btrf=
s_super_block *disk_super,
>>    * and we are not allowed to call set_blocksize during the scan. The =
superblock
>>    * is read via pagecache.
>>    *
>> - * With @mount_arg_dev it's a scan during mount time that will always =
register
>> + * With BTRFS_SCAN_DEV_MOUNT it's a scan during mount time that will a=
lways register
>>    * the device or return an error. Multi-device and seeding devices ar=
e registered
>>    * in both cases.
>> + *
>> + * With BTRFS_SCAN_DEV_RENAME it's to force a device name update for a=
 mounted
>> + * device.
>>    */
>>   struct btrfs_device *btrfs_scan_one_device(const char *path,
>> -					   bool mount_arg_dev)
>> +					   unsigned int flags)
>>   {
>>   	struct btrfs_super_block *disk_super;
>> +	bool mount_arg_dev =3D flags & BTRFS_SCAN_DEV_MOUNT;
>> +	bool force_rename =3D flags & BTRFS_SCAN_DEV_RENAME;
>>   	bool new_device_added =3D false;
>>   	struct btrfs_device *device =3D NULL;
>>   	struct file *bdev_file;
>> @@ -1489,7 +1499,7 @@ struct btrfs_device *btrfs_scan_one_device(const =
char *path,
>>   		goto free_disk_super;
>>   	}
>>  =20
>> -	device =3D device_list_add(path, disk_super, &new_device_added);
>> +	device =3D device_list_add(path, disk_super, &new_device_added, force=
_rename);
>>   	if (!IS_ERR(device) && new_device_added)
>>   		btrfs_free_stale_devices(device->devt, device);
>>  =20
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 337d7007d9e2..509e1c0ef67c 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -747,7 +747,11 @@ struct btrfs_block_group *btrfs_create_chunk(struc=
t btrfs_trans_handle *trans,
>>   void btrfs_mapping_tree_free(struct btrfs_fs_info *fs_info);
>>   int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>   		       blk_mode_t flags, void *holder);
>> -struct btrfs_device *btrfs_scan_one_device(const char *path, bool moun=
t_arg_dev);
>> +
>> +#define BTRFS_SCAN_DEV_MOUNT	(1U << 0)
>> +#define BTRFS_SCAN_DEV_RENAME	(1U << 1)
>> +struct btrfs_device *btrfs_scan_one_device(const char *path, unsigned =
int flags);
>> +
>>   int btrfs_forget_devices(dev_t devt);
>>   void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>>   void btrfs_release_device_allow_freeze(struct file *bdev_file);
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index 0a13baf3d8d1..ea95470b1347 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -1226,6 +1226,8 @@ struct btrfs_ioctl_get_csums_args {
>>   #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
>>   			       struct btrfs_ioctl_quota_rescan_args)
>>   #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
>> +#define BTRFS_IOC_RENAME_DEV _IOW(BTRFS_IOCTL_MAGIC, 47, \
>> +				  struct btrfs_ioctl_vol_args)
>>   #define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GETFSLABEL
>>   #define BTRFS_IOC_SET_FSLABEL	FS_IOC_SETFSLABEL
>>   #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>> --=20
>> 2.55.0
>>
>=20

