Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8405012B6
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781348; cv=pass; b=bXv3//NBSW4rQKxAZvvGFgmbqkksfXeMU2wwQPCSEOBipI8X+/R9pjLKZpmcsuGKekSRVskkxV7G+GKdKjPXO+oobDePcX77bvxurEBa1X6lvgBBxmxEEx6sdrRg3oaJ9N4Jp8P4GFQ/fs1xtPJezm1fhr/uIM2G8UYnq5/c0+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781348; c=relaxed/simple;
	bh=T8M5+WAa5eRfBdC5jOImCi4Z1P9fZSQvbmpoYos19RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uxDi4gL7aR5bO1J7LF+QUOBN9KKOZOg2gyYo5zL51pjurZFAu1zDfJFfBJMv7h6yZaNCIKqcTZm/SPKZDZIMMDWHIbGddaL/sHcMaUrD+NApeD35mg1DnnD6J4pyzdRXp41puDo7gfxyhjeA7O6euUMB9mRj2ztTtR+ZbettsGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T4XBXgPQ; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T4XBXgPQ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4887d3c59ecso863128f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 08:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790781326; cv=none;
        d=google.com; s=arc-20260327;
        b=ODHVkIeNRRhrlUuk6RkwwCVvjoOuMwtDQGI4EB7W0Nu5rbql/dgLChH/LnoxmzcwRE
         hx9kIBwWsu+UGb8vdaH4LQvwhGCe/aWrfVoAa22DtP4SKF8FbNYCDaNJruYfXU3JzE41
         R4JYfJ/itAqY4VZBDXzDptUWoYFtKg7ulv9wu5ieLPQDkY33PTYlgW5REq5sSnIfE1v+
         u9gT6feDL+mFAkNSqS5I0JllaYSx5bW8GSl8t60e3WUHw/Y3/SeCC42rN2v7MzMPlCuZ
         pN+2VvEjHkXFHpHZGlXsxvPCQZo+OmeMDsxtsomoMLvNCpGj1w3CjgMl+scaXGG31vEG
         x2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6ezcTOg+btvYGvscdxJXEFqblYT6m0ireQk8xLTmAY0=;
        fh=l0XmO+YT+sDuoSewlHGxNqhm6aktTh9N9UHfWu17Ht4=;
        b=sr0xNkaq4ITNt7NM69TdBLe8oLuZGTVH/WOlLyTXrRQHekBUG0QYYB8MkeRkpT3egN
         n8bRvuIEwkB2ZbmLdp9uBurbja4jUPVcMuCTIOtzLhi8+TDzf9ZZK/3K9Gbn/ApjZakJ
         eQEjcgRgLySDEqJPg0PwKe/gviZe8b006A58/SlPDLgpKyTW9do+ijhDzk/4Rj9pOmeh
         jvT43ocjRNPAFegNNG6XBJ2pojyIigXX58cnMkNO7OqHFwuiolYSM0CH55CeXoEW+f7x
         nzrnFfkKSGNMzJoztMP68/Hfz+98h8wUaJFOm1YNh3rV0Uuzsxi/H0spk6cPWTJEOONZ
         Xnyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790781326; x=1791386126; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ezcTOg+btvYGvscdxJXEFqblYT6m0ireQk8xLTmAY0=;
        b=T4XBXgPQYhviWMkjz1IKDSZh9IHGs7QfYc9MuRBvJfg9mMuAX4lzDXE50mQHtuODIS
         7ZuE6wtxdpaxe1hwjYKMYNiN5G00DWEMiMNzUUVSJQ5EGBIQ4/CFmWKoqxcSD9MRUalZ
         4Z4HQU9CL/c9hnfzPRVYCQ/Xc4E6afZrTSYtb8gwGzaWMBqj7GZ24TCwUAycLMz15OUQ
         Fxfb8HygcF6DHxpgW98U+CjlsjTM2al6yjCI0cpAhC4fdlHR/eFh4De6zwZaNf84rcp7
         O4UClrTJyN2Dq+Tnvi8l4fryGIRIqFhFesz34LD/DyO0Raz/xc/s7s+9yu1tm5pFi/Tk
         JMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781326; x=1791386126;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6ezcTOg+btvYGvscdxJXEFqblYT6m0ireQk8xLTmAY0=;
        b=fguqB2svW5/R2Og3SNCSfCYngZLMCFZvyZ9I1sTZRCX0on43RnjQjTymieacdb6LXe
         iZTFbvGaXa0OCYbcKw9jh+jHMrxwFzLuqiVYVwghIHe0QeSS+hn8O7kaKWt5gR+qRjAG
         GA2MxihfTRIPe3t8nlGkyzIjfsYTUR8NWMQe71VTYiuJaOJkZjLRZLEoMB9/VN545Rdh
         E3eKvpPIyiLeyR/L114xmfJXii02SFgkkZ2yQuOLNkHh/7ZmWDyX2VqUXdI7DE8rZsPR
         3g9032jwT1tWIiJAw0qd8tm5xNK/ZLyATYWUQLqsr4itqbQR2if9WT+DMmzaxYgg1Ej3
         5inQ==
X-Forwarded-Encrypted: i=1; AKwUvBzst4pl/OAJH90hgkYd0nk69bLfqrGpD5EbgJ6tUfssepcON3HgOIe/enwoI8dJjbK7USB0dP609P/zRQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI+laqrZZGWFn6zlJwwJxO9Q0DulkdqUr3KUoomFDSEattsLddX
	UbBeIsJOlLeKe5j4LvSgItfJPs7N/HLzII0VZ/6cwS/kuxwjbJtJmtjOMh43o67oQPYyzYa9Sj8
	R+yyLwEj4ziZ0ToUaYwlvv/IoZbBJ+YyV1kyeU2FTog==
X-Gm-Gg: AYBFou1PZbqKW0GQ0vIFFHjsOour+PYeaeNYQDW9n4ZSKQz3rcuK1jPwni3R591vlZm
	Wr3V9vqz49YEJqMlNISTzJJhulNaDmIK1Yd2FIOaWcLs6+3SA6xf3LHmsLhE5J2L+yO8LsJQhg4
	M+oVTbMgC2a/pXiFUgChOhFrrdw2ADY8Wmm0ehAtRE/nm/UJ4yYEhbiewHLXhkQOEBDo+XP3SIM
	sntSZ4HBUoCfb/GNZn2/G9lmn0daVIqmuKs1+0zlkKI4rcJrNKX+wJe3HXC5/gt9MWgIQ4rtLN1
	Css+urcweTG5Iot04lj0tQJXCJNiL0FsFgdUf9zCVmd0T/AGkKN7rFI1h3WH4p/4pI72cTjBUjy
	Y3s8ijLVdWzse0jN8Yh0grQj0ZDWxpyqL9Uij909wgYprSweTI8Co
X-Received: by 2002:a5d:5f55:0:b0:485:8413:5272 with SMTP id
 ffacd0b85a97d-48b02521988mr3221377f8f.26.1790781325777; Wed, 30 Sep 2026
 08:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930134808.399544-1-18983559317@163.com>
In-Reply-To: <20260930134808.399544-1-18983559317@163.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 30 Sep 2026 17:15:14 +0200
X-Gm-Features: AclHuK9n1yMpQcY96WbBWhY4VgmmWkiraZ8f4ykE9U2ItzQPNufu8jSq7nFkxwU
Message-ID: <CAPjX3Fc_gnuJZbUfJ=sPTBbhNDwajGRMmZ_gr6g2Jb_evg7Rhw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: wait for a grace period before freeing a new device
To: Binbin Deng <18983559317@163.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Sept 2026 at 16:09, Binbin Deng <18983559317@163.com> wrote:
> KASAN reports a slab-use-after-free in btrfs_statfs() walking
> fs_devices->devices. btrfs_init_new_device() publishes the new device
> with list_add_rcu() and can fail afterwards, for example with -ENOSPC
> in init_first_rw_device() when a user with CAP_SYS_ADMIN adds a device
> that is too small to a seeding filesystem mounted read-only. The error
> path removes the entry with list_del_rcu() and frees the object in
> btrfs_free_device() without waiting for a grace period, while
> btrfs_calc_avail_data_space() and btrfs_ioctl_fs_info() keep reading
> the device list under rcu_read_lock().
>
> BUG: KASAN: slab-use-after-free in btrfs_statfs+0x11af/0x14a0
> Read of size 8 at addr ffff8880096be858 by task poc/252
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x53/0x70
>  print_report+0xd0/0x630
>  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>  ? filename_lookup+0x1a9/0x540
>  ? btrfs_statfs+0x11af/0x14a0
>  kasan_report+0xce/0x100
>  ? btrfs_statfs+0x11af/0x14a0
>  btrfs_statfs+0x11af/0x14a0
>  statfs_by_dentry+0x117/0x1e0
>  user_statfs+0xac/0x130
>  ? __pfx_user_statfs+0x10/0x10
>  __do_sys_statfs+0x80/0xe0
>  ? __pfx___do_sys_statfs+0x10/0x10
>  do_syscall_64+0xf9/0x540
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Allocated by task 256:
>  kasan_save_stack+0x33/0x60
>  kasan_save_track+0x14/0x30
>  __kasan_kmalloc+0x8f/0xa0
>  __kmalloc_cache_noprof+0x158/0x370
>  btrfs_alloc_device+0xad/0x3e0
>  btrfs_init_new_device+0x3e8/0x36e0
>  btrfs_ioctl+0x150d/0x6c20
>  __x64_sys_ioctl+0x134/0x1c0
>  do_syscall_64+0xf9/0x540
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 256:
>  kasan_save_stack+0x33/0x60
>  kasan_save_track+0x14/0x30
>  kasan_save_free_info+0x3b/0x60
>  __kasan_slab_free+0x43/0x70
>  kfree+0x121/0x380
>  btrfs_init_new_device+0x4a0/0x36e0
>  btrfs_ioctl+0x150d/0x6c20
>  __x64_sys_ioctl+0x134/0x1c0
>  do_syscall_64+0xf9/0x540
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Fix by waiting for an RCU grace period after the device is removed
> from the list and before it is freed.
>
> Fixes: 1f78160ce1b1 ("Btrfs: using rcu lock in the reader side of devices list")
> Signed-off-by: Binbin Deng <18983559317@163.com>
> ---
>  fs/btrfs/volumes.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85ea9c5d4536..ec89dc3dc4cd 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3174,6 +3174,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  error_free_zone:
>         btrfs_destroy_dev_zone_info(device);
>  error_free_device:
> +       synchronize_rcu();
>         btrfs_free_device(device);

I believe v1 was better regarding the RCU sync logic.

--nX

>  error:
>         btrfs_release_device_allow_freeze(bdev_file);
> --
> 2.43.0
>
>
