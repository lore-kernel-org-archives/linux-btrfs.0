Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE035C19B;
	Tue, 29 Sep 2026 23:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724548; cv=none; b=DGhYNNdc3iStivjT0TAF/E0IQuL3I4RIxY3SCehUhvH3yOQz2kUtVARMuJgAjfLpRdvB+0gDcNo4WWdM+tKxdPWto9Ptq2dt5OSk2gFygD8FGp1lTm5zCVMWqIYOHArhQsL9xCPUAy/mUE2D7cHH/GVA8QLrb3x6kIOuOXIpNoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724548; c=relaxed/simple;
	bh=ILusDqZysu5Zn0Js+U07lhViixBPxYSiMdBRjKyGP5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuemW/VWXAyn8QHwuz7BGKTMipICn+47JlFj2w6/IqRfBwzo9Yw5ocUZ613XniEmrklaw1MiQoYG7PEAn7zU6wmBU53CVwwGGOpB/l9Hffmbz0i1KhLHlx6MDCzU95lGupuI5mr37a8hRkLiYPVQUQzTDAUhyUDCZ4R1G3YRYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=fKEIBhTp; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="fKEIBhTp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790724544; x=1791329344; i=quwenruo.btrfs@gmx.com;
	bh=0y8vEZpbXxZXyPbWPD6wYqtvtH3i6mdkEQdkfVbm3UA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fKEIBhTpUqAa7SXgq6yrJ2rZE/37ubgVMR4zKsgv0AbZYDwGKXB31SdQ9xxUCxjl
	 qepKjm0kS9khy16WwT6Q0K1KHC0fSvXx6cjMH9XBJf1wZ+C33HH/jnp+Bzobfmjq3
	 vqGEIpq1YCa8P/w/4I/uod5d9XBg5d8rWL/0VAklRtKXRFIALOB03u7HGMAFs6Bwo
	 TIcfNaUo2MB5BzbN2Zxx/chCrMgWzibe4RXyMng/ZNTWyJmlrKJqa0xeyA54miPDk
	 L+wP3GzTmCteioN6wWHTsJlIp6m2kADZPYNPCVu36MypZoW+QOJf4cCviA69RsgsB
	 g674OIQizQirAT+zsQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M72oH-1x4ptI3PFn-006P5c; Wed, 30
 Sep 2026 01:29:04 +0200
Message-ID: <66eaba4a-9b3a-4a65-bab5-8c336477faa2@gmx.com>
Date: Wed, 30 Sep 2026 08:58:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] btrfs: wait for a grace period before freeing a new
 device
To: Binbin Deng <18983559317@163.com>, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260929123616.139759-1-18983559317@163.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <20260929123616.139759-1-18983559317@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7hzJwkmDN46Ac41T+6Mxf8IYvzQJmwAlDVM5HguGTNyX4VXXRWA
 iRDUf2VAy990WNzHRij46BiHDqPxImrbb3/5rsG/lAVMe6Il6GNK7teCijo6zPaalogziQe
 /wErUAPFo3ZFvNcnB8ruCZpQaD7U5Hz+bHzw8BQ+1sgS7XUSvChL4z7LMwXRf40ZhMowdCS
 nnaOjP/ZN+j7UyHd23sPg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ym0VmWkXEnI=;IStDWiznsRsG/C1lKe5oufYQK4V
 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
 1T0I



=E5=9C=A8 2026/9/29 22:06, Binbin Deng =E5=86=99=E9=81=93:
> KASAN reports a slab-use-after-free in btrfs_statfs() walking
> fs_devices->devices. btrfs_init_new_device() publishes the new device
> with list_add_rcu() and can fail afterwards, for example with -ENOSPC
> in init_first_rw_device() when a user with CAP_SYS_ADMIN adds a device
> that is too small to a seeding filesystem mounted read-only. The error
> path removes the entry with list_del_rcu() and frees the object in
> btrfs_free_device() without waiting for a grace period, while
> btrfs_calc_avail_data_space() and btrfs_ioctl_fs_info() keep reading
> the device list under rcu_read_lock().
>=20
> BUG: KASAN: slab-use-after-free in btrfs_statfs+0x11af/0x14a0
> Read of size 8 at addr ffff8880096be858 by task poc/252
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x53/0x70
>   print_report+0xd0/0x630
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   ? filename_lookup+0x1a9/0x540
>   ? btrfs_statfs+0x11af/0x14a0
>   kasan_report+0xce/0x100
>   ? btrfs_statfs+0x11af/0x14a0
>   btrfs_statfs+0x11af/0x14a0
>   statfs_by_dentry+0x117/0x1e0
>   user_statfs+0xac/0x130
>   ? __pfx_user_statfs+0x10/0x10
>   __do_sys_statfs+0x80/0xe0
>   ? __pfx___do_sys_statfs+0x10/0x10
>   do_syscall_64+0xf9/0x540
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> Allocated by task 256:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   __kasan_kmalloc+0x8f/0xa0
>   __kmalloc_cache_noprof+0x158/0x370
>   btrfs_alloc_device+0xad/0x3e0
>   btrfs_init_new_device+0x3e8/0x36e0
>   btrfs_ioctl+0x150d/0x6c20
>   __x64_sys_ioctl+0x134/0x1c0
>   do_syscall_64+0xf9/0x540
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> Freed by task 256:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   kasan_save_free_info+0x3b/0x60
>   __kasan_slab_free+0x43/0x70
>   kfree+0x121/0x380
>   btrfs_init_new_device+0x4a0/0x36e0
>   btrfs_ioctl+0x150d/0x6c20
>   __x64_sys_ioctl+0x134/0x1c0
>   do_syscall_64+0xf9/0x540
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> Fix by waiting for an RCU grace period after the device is removed
> from the list and before it is freed.
>=20
> Fixes: 1f78160ce1b1 ("Btrfs: using rcu lock in the reader side of device=
s list")
> Signed-off-by: Binbin Deng <18983559317@163.com>
> ---
>   fs/btrfs/volumes.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85ea9c5d4536..2693dacd1da7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3168,6 +3168,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs=
_info, const char *device_path
>   	btrfs_update_per_profile_avail(fs_info);
>   	mutex_unlock(&fs_info->chunk_mutex);
>   	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +	synchronize_rcu();

Please follow all other call sites where synchronize_rcu() is called=20
just before btrfs_free_device().

>   error_trans:
>   	if (trans)
>   		btrfs_end_transaction(trans);

