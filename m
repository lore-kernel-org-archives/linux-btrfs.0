Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB3A41D640
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 21:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789421348; cv=none; b=keflknYJZS2zZXrrYeh4n/h9hk4WKb/lH0By1tNggBd3fn5w2NNjyqfcBVvgov7EGf3N/lkjYXjHFz1nZZDv1gvVvYp33MThp3rqYgRinGPRSE2DX8vSq1XtzBIrIbwzhcxaPdPkE8tH74tv953e0yWh9dAjHT+KPo1s06boPgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789421348; c=relaxed/simple;
	bh=GbDm4tlhwSa9uFxnp5Xrxy+VP8WqfHnMYQ1ESAuo6fw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNCtalxQ7UGbUFVAXEyN5QW5TNkc18sDAj0HPNaDbqLFN/nf9Ot1IIuLz53J3BH/BzUSfjkvfIZUqs7lxmHbVbb+PeD2h+SDDjolQXQZIvrShOSBPTVAx6JLlywQxA+R0daYW9oQOIoZAnqmAkSdul03JJQh/COMy8Ci7YT2G54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=DPDPVO7E; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="DPDPVO7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789421333; x=1790026133; i=quwenruo.btrfs@gmx.com;
	bh=43y55fdqsiI+9vDK+x09GSAJI584HTh5oCuKYVI9S2M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=DPDPVO7EjgFX6ulQOtG/tThcbu4CdwvbmzEX4yO6/VJv5b4Ksv6F00rN4+gRlnyO
	 iwlzu/x83hgPL1BUCAv6T0vv8dfpnIKdwJ3dDroBWL80EMqG+n2MX+RsOOPCxWsMO
	 Uvty2ueO72OL4I+WKuHW8QOzVyqfx4MRqo6s5bBDIvDWg399P0tAZM58xa/FQ1HNE
	 ePyYaSyc4Kc+kV21L9r756EuZJnApBU7E31izjxmM3XEik7sSNVJBgIqu47OPxccH
	 vH5pSG1JcT+rQinj/omoExZjXVRVdSp4pUGOG8tmE6dfhijs8C7jgwcPQG4NOr67D
	 045cTIvIc3WUMskloA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MjS9C-1wMgww1lrW-00a7Rg; Mon, 14
 Sep 2026 23:28:53 +0200
Message-ID: <f6f95c21-da42-45b0-9fd4-4c855e677b1c@gmx.com>
Date: Tue, 15 Sep 2026 06:58:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add "/dev/root" exception for device path update
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
 <20260914171602.GO54722@twin.jikos.cz>
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
In-Reply-To: <20260914171602.GO54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RUCFnP3C2oqMvRdwwy/i4JDQs84AWckyRuf7HXC20xdGgdJB6hN
 Bwh74y0b4Gnu9ZNyqwTGut4OuhJnLQe8JBKXr8/fuLlPLZ9NvowxgRLFnihMALLQypPwD5b
 UK24uTHP0udVqlNzwkzk5WYfCqgLKhIvSpBmtU/BfSIutVYTY1xJ9W5sKi8DnGfcb4SKX5C
 jM2EGLhm2BvI4YZSd8Urw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LuP9vbYIzRE=;i2dwCtRYAkiXwYg3IilTK7mbNrt
 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



=E5=9C=A8 2026/9/15 02:46, David Sterba =E5=86=99=E9=81=93:
> On Sat, Sep 12, 2026 at 06:12:06PM +0930, Qu Wenruo wrote:
>> [BEHAVIOR CHANGE]
>> Since commit 108cc8733989 ("btrfs: fix a lockdep caused by path
>> resolution during device scan"), users with btrfs rootfs but without an
>> initramfs are complaining that grub2 can no longer detect the rootfs
>> device:
>>
>>   /usr/sbin/grub-probe: error: cannot find a device for / (is /dev moun=
ted?).
>>
>> [CAUSE]
>> Although using btrfs without an initramfs is not recommended (if a new
>> device is added to the rootfs, the system can no longer boot, as there
>> is no way to register all devices), there is still a minority of users
>> doing this.
>=20
> To avoid scanning there's the -o device=3D/path mount option, passed as
> "rootflags=3D" kernel parameter.

That won't work. At that time there is no full "/dev/", those=20
bdev_open_file() call will just fail.

It's already recorded in the man page.

>=20
> The initrd-less systems exist, I think most users are in embedded space
> and there the multi-device root filesystem is not expected. For quick
> boot VMs it's orders of magnitude faster than e.g. systemd. It's
> probably a minority compared to the number of systems with initrd, but
> still it's a valid use case.
>=20
>> If there is no initramfs but the rootfs is on a block-device-based
>> filesystem, the kernel boot sequence initializes a minimal ramfs/tmpfs,
>> creates "/dev/root" with the proper device number for the rootfs, and
>> then invokes mount using "/dev/root".
>>
>> That's why the end user will get the mount output:
>>
>>   /dev/root on / rw
>>
>> To be honest, this is a user space problem: no one should trust the
>> device path shown in mount, only the device number.
>>
>> E.g. one can even use "/proc/self/fd/*" to mount an fs, and that proc
>> path will be registered, and no one else can mount that fs using that
>> path.
>>
>> Before commit 108cc8733989 ("btrfs: fix a lockdep caused by path
>> resolution during device scan"), btrfs had an internal path lookup
>> workaround to address such weird paths, it works by checking if the
>> existing device path can still resolve to the device number.
>>
>> But that path resolution is deadlock prone, thus it's replaced by a
>> simple devt check.
>>
>> This works fine in most cases, as a btrfs device is registered by udev =
at
>> boot time, thus all paths are sane.
>>
>> However this will not work for systems without an initramfs, causing th=
e
>> unreachable "/dev/root" path to exist forever without a way to rename
>> it.
>>
>> [WORKAROUND]
>> Despite updating the docs to discourage root btrfs without an initramfs=
,
>> add an exception to the device path rename requirement.
>>
>> If the device has the name "/dev/root", we know it's booted without
>> an initramfs, and only for that case we allow device path update.
>>
>> And if someone intentionally created "/dev/root" after boot, the
>> existing devt checks will reject that weird name as usual.
>>
>> This should satisfy the minority of users, and still keep most of the
>> existing guards preventing unexpected/unnecessary device path updates.
>>
>> But still, I prefer grub2 to implement a more robust device
>> number based probing, and no one should use btrfs as rootfs without an
>> initramfs.
>>
>> Fixes: 108cc8733989 ("btrfs: fix a lockdep caused by path resolution du=
ring device scan")
>> Link: https://lore.kernel.org/linux-btrfs/CAKLYgeL7nrA4nXcewdv9Fqg_s=3D=
3GS=3DvmoypnEiZBKQ7rySZFuQ@mail.gmail.com/
>> Link: https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28e=
eac5df4@gmail.com/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++++-
>>   1 file changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 4ddabadc9188..b61c68871c0b 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -749,6 +749,36 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_sup=
er_block *sb)
>>   	return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
>>   }
>>  =20
>> +static bool should_rename_device(const struct btrfs_device *dev)
>> +{
>> +	bool ret;
>> +	const char *old_name;
>> +
>> +	rcu_read_lock();
>> +	old_name =3D rcu_dereference(dev->name);
>> +	/*
>> +	 * For systems booted without an initramfs, the rootfs has the device
>> +	 * name "/dev/root".
>> +	 *
>> +	 * Although using btrfs without an initramfs is not recommended (if a
>> +	 * new device is added to the rootfs, the system can no longer boot, =
as
>> +	 * there is no way to register all devices), there is still a minorit=
y
>> +	 * of users doing this.
>> +	 *
>> +	 * And after the system is up, a later device scan on the real block
>> +	 * device file will never get this device's name updated, as the
>> +	 * device->devt is still the same.
>> +	 *
>> +	 * Here we add one and only one exception for "/dev/root", to allow
>> +	 * the device name to be updated even if the new path points to the
>> +	 * same block device.
>> +	 */
>> +	ret =3D !strcmp(old_name, "/dev/root");
>=20
> That's probably a sane workaround, the "/dev/root" has been part of the
> ABI, nothing needs the exception.
>=20
>> +	rcu_read_unlock();
>> +
>> +	return ret;
>> +}
>> +
>>   /*
>>    * Add new device to list of registered devices
>>    *
>=20

