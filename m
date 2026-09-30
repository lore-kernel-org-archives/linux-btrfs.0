Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0C4F3ED6
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781188; cv=pass; b=QcA1JQMh9HD7F6++9hwFzrczQu+gujWwD+HEyAbTxpd/IdtMCnAUIfHQWied49iD3AtoT3/qrny/UQgsbH8dvHKyu39tq3AtWr8hIhgNrAaBPZfOElnNVwbasxsVJvip2Cn72KVHxYra3ODPTrCqKLg4ZO4Wtf6W1HCEPPrt2Qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781188; c=relaxed/simple;
	bh=dWPoP5tiJFfGs3d+AjtKuoPQm6W7knvCUa4Vdkd92c0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Iaf7P5oIb8qovNv+BwrzZI3WGnROs5/vUH6BioayxqCLWQDWHLb6foXVtymuZZgMOcRlv8IM4NEyDb2Vs/mUSMpc0snFaX6UYIuZ9tT9fzL8N2j19OtYXkKgYMc/9+MxHLheX+dsXDyASSdGnEK00Tko7ijFRBxX23PkYwEYS9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dGlX8+He; arc=pass smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dGlX8+He"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6c0fce17so30013385e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 08:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790781177; cv=none;
        d=google.com; s=arc-20260327;
        b=Jv7Suf5atLlsBhCT/eOzMG2TAxTwos+LdtawQFLhBrgpd9h/47RheUGwlK67Qy4dWH
         8vEqr5DLKVcuREZOYvwnrc+TH0STuOqgvZbXDNZK2Jyc+NHVnZlu2WGwwohA/7Uav2E4
         b/mQD0TjD9m1q9P9cUhTV7ObDVxyZvtqqiqtRyl5EYdcZZwrzmnk0ZaHO6hmYSRXt5iG
         NiXPCPUMjd1MtoPNV9t8vCkbG3g+QKcz3cERlnctfu16es6m/xOGEf4ihVdh1yqZJgbJ
         3ibQAZq99egKn7UAxQkG+BQEVhxMLigqLrBgMvyHG4dsIoZ30V8+mDPaL8QHK63JeEtH
         srjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+sKOHEJ5lVElWIr3V7PS2oyi4Sxq4Ni0O03Yi9pepGg=;
        fh=6sy2bJaP9HD4EO9rjUsD9j6M+nP8BSmsrPBIE5FVGdk=;
        b=LyAwkTWTxHpwQ4l1X+lxkfrd5lof6AS9lYwajH6IFTPQFiwY26rRVOK1DnxlQXbctV
         GE5QiDuTn5WIQQ6FUSeP+OFyCmqDwfW7efFmfTazGFsiXHz8clKYmLNhne0ZYquwBKy5
         FDjagT9jfOLx8xM5zaq8jhMkVxaBH/taiXaaiPxDwp+G1ebOBbYWoWhYbdDnPkdc1q9E
         hghKtfRpIaihzFNUgEEXnTKNw1Dsaj6Sf6io/YyzC2jDSfMnc7hzX9VfI9Q5dD7kGweS
         pfOzq+9rqRjb8oKHeMBSAofupzzZEuqsJoMADILhzqmuckEhf+fQr6USsI/QWi6SmUm0
         ozww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790781176; x=1791385976; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+sKOHEJ5lVElWIr3V7PS2oyi4Sxq4Ni0O03Yi9pepGg=;
        b=dGlX8+He4fUICrRxmUItgNWcCNvAvhPrE102SyAPXGgsYjZ+47ZufGiBE2PXQ0KhLD
         vOWyl9qCS5WjJ87l2mbj9pbeD1d8R8OMm5rL/L4uPJZSj6+QAbaFMWn1j04wyhdIeL4K
         R/i9at8F6Kob9GC6Luw83F52K7HryXqugcqEu2wkkxO6eeeF7rR8azEWPSnv9uEo2jFD
         0jqsmGitqDLFjTYllg6MkH+P6XpQiQg30hQvvUJ4pKVbt3fC94fubrp4CaABxQzvlmE7
         pThr/0uFjxSG5V2uqEst0Q5S+4p+bnqpjkqdPdy3IKssE7vR0ZfaW9YJXYGJlcOXa4/Y
         Pjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781177; x=1791385977;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+sKOHEJ5lVElWIr3V7PS2oyi4Sxq4Ni0O03Yi9pepGg=;
        b=en1tdOJABK+lt9UN6GXIeesdhxg5bmabJY/zo1Jep4m0iaiAWyiGLVlAjhfBWU7qgR
         OCp2PTPKgTu7IJl3h7+Mo9QSsZogpnXokK8D3sTXSCT2w8dG7S0U9e5tMSm3avd50lS3
         Xe6/Hwi/aTXwkA1Ju2DVmYqaQiQrQIhIU/Z/DnDlBA6fokusaXwynm3PzHq0qHRNbuGX
         F/MlB2jUao7GWGZj+LSrsKbzjwwrzaetiuL+usCGseB/Xn4d2XbHOXzHF8KyYxNTguO8
         GN/o8jJzN5XbINQ5nG1W4gsol7Wy4ce5V1JcD9aZukl9rLOKRmWBZ7HkUPQ8fyB/OUVi
         5Y+A==
X-Forwarded-Encrypted: i=1; AKwUvBxofU0ZpYbYTwmQ5INF8xhlZNj3BMcA0xryKLJrrAQI0yOL6bRNP5uXXD0p3TdLC+M4v9saY+mYpeFeTg==@vger.kernel.org
X-Gm-Message-State: AFuF++lROvu6QAV8PnGznQx3KcIXQY4+oseUI4tfZN415KFpSTN/oPHd
	AqTAVEPKB8T+I8d/LL6eTb0fwc/Wd+XWeLIYHkvy4mnUchYi7vQB/iK0xeoB9zHsziu8oVklpuz
	oD0gS5qxJdfylONO/CKUFytEOkA9/S0JMQciGK/UjMQ==
X-Gm-Gg: AYBFou0g8XbZcnVQ0iJcr8nxQdRJeuDW9YCkdikq05XtN5gBz8S99CzdMNzZ+4ScnzB
	sVcaGwOBcz+pmZRRN+nJLwTl9jhDlTwTuSwt4IVss0uHOQgRM2qmxsCgQjAn1j+llnPg6pnMNAP
	GO43aA7LRk0EModeZLX7pzxiFWk1+LgwoIfJvMWa8ngtho9bt5AGjNt544GVj8yinsMFFqyPlaf
	hi+kIAnOXiLFqknjh+OCINZh6F9+E5dsB8RFRYSBL+t80LA8HvVUWYRmSgogxzfQEKStIPsqcii
	CUn00diXPeXDOd1/6MKhFJ4hxwnFi/ZG1duHMawdElbXElE8Ge6TTvqL9W2GLuwUS/X2AdqWuld
	8Ej+ep9D4sg7O9VxH8C6R2Wj0fK8nCt+gBBQVijMMUZBU93WYGmSh
X-Received: by 2002:a05:600c:45d3:b0:49f:cac3:c68a with SMTP id
 5b1f17b1804b1-4a01affeca0mr26046025e9.31.1790781176386; Wed, 30 Sep 2026
 08:12:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929123616.139759-1-18983559317@163.com> <66eaba4a-9b3a-4a65-bab5-8c336477faa2@gmx.com>
In-Reply-To: <66eaba4a-9b3a-4a65-bab5-8c336477faa2@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 30 Sep 2026 17:12:45 +0200
X-Gm-Features: AclHuK_5J9yKSzibQ3_PkDRAaClKmgotVRkVXp1ETvrcDpdVESzC-EzaCItLOfg
Message-ID: <CAPjX3FdRzd7HYAJJEKrpe=r-O1iDBOLeoMf-VQs_62VFHrtV_w@mail.gmail.com>
Subject: Re: [PATCH v1] btrfs: wait for a grace period before freeing a new device
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Binbin Deng <18983559317@163.com>, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Sept 2026 at 01:29, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/9/29 22:06, Binbin Deng =E5=86=99=E9=81=93:
> > KASAN reports a slab-use-after-free in btrfs_statfs() walking
> > fs_devices->devices. btrfs_init_new_device() publishes the new device
> > with list_add_rcu() and can fail afterwards, for example with -ENOSPC
> > in init_first_rw_device() when a user with CAP_SYS_ADMIN adds a device
> > that is too small to a seeding filesystem mounted read-only. The error
> > path removes the entry with list_del_rcu() and frees the object in
> > btrfs_free_device() without waiting for a grace period, while
> > btrfs_calc_avail_data_space() and btrfs_ioctl_fs_info() keep reading
> > the device list under rcu_read_lock().
> >
> > BUG: KASAN: slab-use-after-free in btrfs_statfs+0x11af/0x14a0
> > Read of size 8 at addr ffff8880096be858 by task poc/252
> > Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x53/0x70
> >   print_report+0xd0/0x630
> >   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> >   ? filename_lookup+0x1a9/0x540
> >   ? btrfs_statfs+0x11af/0x14a0
> >   kasan_report+0xce/0x100
> >   ? btrfs_statfs+0x11af/0x14a0
> >   btrfs_statfs+0x11af/0x14a0
> >   statfs_by_dentry+0x117/0x1e0
> >   user_statfs+0xac/0x130
> >   ? __pfx_user_statfs+0x10/0x10
> >   __do_sys_statfs+0x80/0xe0
> >   ? __pfx___do_sys_statfs+0x10/0x10
> >   do_syscall_64+0xf9/0x540
> >   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Allocated by task 256:
> >   kasan_save_stack+0x33/0x60
> >   kasan_save_track+0x14/0x30
> >   __kasan_kmalloc+0x8f/0xa0
> >   __kmalloc_cache_noprof+0x158/0x370
> >   btrfs_alloc_device+0xad/0x3e0
> >   btrfs_init_new_device+0x3e8/0x36e0
> >   btrfs_ioctl+0x150d/0x6c20
> >   __x64_sys_ioctl+0x134/0x1c0
> >   do_syscall_64+0xf9/0x540
> >   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Freed by task 256:
> >   kasan_save_stack+0x33/0x60
> >   kasan_save_track+0x14/0x30
> >   kasan_save_free_info+0x3b/0x60
> >   __kasan_slab_free+0x43/0x70
> >   kfree+0x121/0x380
> >   btrfs_init_new_device+0x4a0/0x36e0
> >   btrfs_ioctl+0x150d/0x6c20
> >   __x64_sys_ioctl+0x134/0x1c0
> >   do_syscall_64+0xf9/0x540
> >   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Fix by waiting for an RCU grace period after the device is removed
> > from the list and before it is freed.
> >
> > Fixes: 1f78160ce1b1 ("Btrfs: using rcu lock in the reader side of devic=
es list")
> > Signed-off-by: Binbin Deng <18983559317@163.com>
> > ---
> >   fs/btrfs/volumes.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 85ea9c5d4536..2693dacd1da7 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -3168,6 +3168,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
> >       btrfs_update_per_profile_avail(fs_info);
> >       mutex_unlock(&fs_info->chunk_mutex);
> >       mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> > +     synchronize_rcu();
>
> Please follow all other call sites where synchronize_rcu() is called
> just before btrfs_free_device().

This call site is unlike the others. The device is allocated and
initialized here.
There's no need to sync with RCU until the device has been published;
i.e. the other error paths are perfectly fine to just free the device
right away.
Placing the synchronize_rcu() after dropping the mutexes and before
the `error_trans` label is exactly the right spot in this function.
We should really be serious about needless RCU syncs.

--nX

> >   error_trans:
> >       if (trans)
> >               btrfs_end_transaction(trans);
