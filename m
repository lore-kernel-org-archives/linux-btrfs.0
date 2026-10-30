Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793369507;
	b=DntCo4nRbpd4z2iZxcuxJ1vOqsTIAaBXPrnWrzksYrgVfGJqAuKqgMF3+1m1m6El5z8O
	 3uB+1G2b1CybwQdFNasP48n55CzNJGdZZgElUUkSnYL3eioQU9Jd9B/mMjtMqAHGgMZwp
	 Ezh/zEoyQ49WmAJiofOxiKdHFzsVCX5SnG/K/6+FnnapCZ9KDnXbGt/vTE1AwDGkJEXei
	 /I12zCWsUaA9Ma44YmL6ikrOiNUiMGKO/QeOFcbKvVKjnVeJbWnZxMHjYNprrR4J+jo8e
	 uEQg4FyeJ6CLxscMP/bp+LxcCGf1YvajYB7KfQXp1zYR61Lk7I643hEe7FyQvGLV82g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793369507;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=66LBFrIdvPN5I/Sp7uCyiL3h5+EwlBIU1Tk64BEBwyA=;
	b=Qop3+tHMoItwMwHI9K++TqR5gXkdKCiJ8vHBbo0gbxXdgzjjDK+mScVvRuLoNjkT4IjD
	 Lxf5Ty8OUjmS/fxWQjTegpz7WcqSrAfe1oPahHsl4PNXyOtldtMIhb4YmFr/UpBRxWqy/
	 sJe7itMJU3mg4OdqAF4LW4W8ZcaGk9u7wGZCIIZIOrWb+fSvC5cJDR7Q9QcJlqLttu4JQ
	 QBPksGmC6GtoYvfPemiNTosfYoJGRCMhlOd/LC5z9J+fLrxkozvapgm+SL+VMlm4Q9Vj1
	 uEyU0KWekAHvod5lRb9wlPcN7nCXXhhTG4ABw87ucGy7V1a0DGWzAfLRHR5z9Gzy+7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BuL1neDN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1435B606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 14:11:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1435B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BuL1neDN
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso535691f8f.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 07:11:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793369505; cv=none;
        d=google.com; s=arc-20260327;
        b=gH/aNhGPSSFEw//GjsUE+yZ16kSNkwFPfjneiqhFCdeI+FKldwIAyxBKYUmpJXaXhh
         UYZCxqefXB8eMqPLJo2ywxgzgRouJ72F5NBW/JgBCqF6nU3ASbB5OWvk3wBYnbqYPh8U
         hTV0lGQxW73CPous8guJKfsos3YYKY9Gt0W7ZGmO+HsGiazBB8qzScUMVxIqHMp+3fGC
         by5pzvO8/dVYdQH1LrATxDz2jhJNV4GpcFmx63J9cDaiDhbgOEfTQx/z9Y0FgB3lJw5K
         AppUTQVaxa6xKDw8/pOYPD7ezGn/soNw2/GZo0LBW5SSwD/JTpBu82aXsj8BM4sFH9W8
         2DZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=66LBFrIdvPN5I/Sp7uCyiL3h5+EwlBIU1Tk64BEBwyA=;
        fh=ophR1e0Lsn9Y/8TTUwXdrKdEW/1dhK6AGj+1B7cV4H0=;
        b=rHJD85oT+2mb7USR9PCYGeEK89EZnr6v2viZZSz/p1E7qAN+Y+aYuvErGzfEPSYXXk
         Gm4IXDn0OWy/I4IT5wB/GD6oDOzucuSHbFF3y8kyNxcwLwf1y8CR8ZjJ5u2l2Fkw8UCR
         IFlj9qkfq1cUoDuG62Sz/nY+SEXrCZadjBo0HgfWj5geG/D687hPLw5wjGx60v0pstjw
         xIQaufvp6z5LaDKHYtadUzewGG0eKD+XfmZVakjSMmr+K60VZVGYZqmGkEsdLztklR9p
         5ZPTOhaBpKzcyYiVFIKLN6t/gvWey4pBIlAELpKMVfhSHO+Ot5JwrHlib45125D62l3B
         Jz4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793369505; x=1793974305; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=66LBFrIdvPN5I/Sp7uCyiL3h5+EwlBIU1Tk64BEBwyA=;
        b=BuL1neDNGdWshafjIbCeK741DC/opGgdwzqcNKNID8jAu0tcoYnijbuv+IrBjue3IX
         KqU8tnNgBxAJ72rLfaeWKz9HTni0q6xbO3BR0ID6rBESZGZeUVV95jGaHsz+nMzkzp9y
         T+rFJkA/rRg64LKHvr3QF1c+DtPySdoDbiaPAAFhV5zk1Bq8pBCO3zZQkJ1xTM6DxDaL
         QuebSWNHELM9gAAg2IkIibtK/q5HPLpcfbWzZeIgPcZQC2t50cFZMbtuuk4MFwqnSbO1
         RxcbbiOS/dX4kA0DjWi9NmSHhhzUZwZyJy7fCpvcybDdG0MeEHi/v5zO+KMeloFoLPdn
         2Zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369505; x=1793974305;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=66LBFrIdvPN5I/Sp7uCyiL3h5+EwlBIU1Tk64BEBwyA=;
        b=q09ZkM1icQ6MkA76Z4/FUwIZS/s6ANRhJ1Q1Ax1l1fpEK4Qq0NkbrET/qYvGwch+LC
         oUFr2u8XbbadbcFjmgNzELF23vVNOeUpC126HLsrW/HDA3PC21jxWL/0gA/CHZknFMkK
         e8PmzBfR+kQRuZdxKJdsVXBIgM7R/CG3rLa1iHDCoyQXCjQURnMd55vaqiI5adeyrlpj
         Qj8sf+uxxQilrWjc7rP22hp5nY9DnXvCWwnDMom1OKW7fmAtUUTOdV6HwHAwi9qXxSLU
         aWs/HdSGIV+umvOuRO2b3B3FWs1m+EKDqnjHfOQ/rfGJ+PdbH64s0cf/91hcHQLvksdh
         vyZw==
X-Forwarded-Encrypted: i=1; AKwUvBwWwP6BPcldtpGOY08c0wLwHyDgBEWvdESnW3u8w6Ekcrj2j6lD5z+UL2LZKGgDUU621LR7uklbG9Matg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLxqSqty4pvvwEOwPRu9Hhu0ClDEcw7HOxMJF4US8OZe7eZ9BgO
	gIJX9qXtqnHMHsskWDWCscJ8+1ro6kR7byeWpTKWuMCwskRy2mpuwNJ+sYW6YGEryr8rhwgTZ/3
	zLevcBYkrf2kAC/O9AuBHCQLXI6DkV4da66BFTVCCZw==
X-Gm-Gg: AYBFou0T/OzLuAOIEl/B1LvXZifMQwuGI55Yaxx5xxiQiyqIhqohF3SypX9G/llcYiq
	Cov6pN2CE0VLqGARl1vt2EXGxDSN9x4JB1IZ4CTh8JXm7CtoBgtITPoDKH4pRCJl0945w3cum2N
	QccTlPIUk5C5pr796i0JkD3lmsVE6malLWgaIXpn1Y9OCVNv+EGqHUeqok3UA337easdxRbflCn
	E3pAm4ou7ofYv4FU25Gcz7qGb0PSvnrLzTpq7LL64RRgZPMH/juhGoQDQ4XCDvgF+sbmeQwqROO
	KrSBR3cldrvH97QrCWDDJDRQKGyT7oBD0fpF2M/9Yp0SEMcynGS1/IwGOkLkJDOykh7JR0Q1s86
	tTwGpsa/GH2vzuepanIxI4KhF9x92WzJqo4XJ792P6qc6SoXPt+rJGZBS5942NCEQKsNdEdZF+q
	SWwJwyDywM8Yu/Pnw6fHhAVaMZCebu9WbfoUY=
X-Received: by 2002:a5d:5d06:0:b0:48d:ff71:dd87 with SMTP id
 ffacd0b85a97d-48e6e303f29mr5929875f8f.17.1793369505232; Fri, 30 Oct 2026
 07:11:45 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014023733.266854-1-18983559317@163.com>
In-Reply-To: <20261014023733.266854-1-18983559317@163.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 30 Oct 2026 15:11:33 +0100
X-Gm-Features: AclHuK9_U1sdsfah92JETnlIiZP0F7Q7mLVpYaOkJD3_p8ZASapxcKb1MBMHWaE
Message-ID: <CAPjX3FdCZpJkj+QaCMObtTy0_W=uxXfZfatUHvOPdjN07v7KTQ@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: wait for a grace period before freeing a new device
To: Binbin Deng <18983559317@163.com>
Cc: dsterba@suse.com, mason@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Oct 2026 at 04:37, Binbin Deng <18983559317@163.com> wrote:
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
> from the list and before it is freed.Place the synchronize_rcu() after
> dropping the mutexes and before the `error_trans` label.
>
> Fixes: 1f78160ce1b1 ("Btrfs: using rcu lock in the reader side of devices list")
> Signed-off-by: Binbin Deng <18983559317@163.com>
> Reviewed-by: Qu Wenruo<quwenruo.btrfs@gmx.com>
> Reviewed-by: Daniel Vacek<neelx@suse.com>

Pushed to for-next. Thanks

--nX

> ---
>  fs/btrfs/volumes.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85ea9c5d4536..2693dacd1da7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3168,6 +3168,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>         btrfs_update_per_profile_avail(fs_info);
>         mutex_unlock(&fs_info->chunk_mutex);
>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +       synchronize_rcu();
>  error_trans:
>         if (trans)
>                 btrfs_end_transaction(trans);
> --
> 2.43.0
