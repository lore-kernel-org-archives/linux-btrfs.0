Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4480524679C
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 05:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778908473; cv=none; b=LCQKqY1VWjPAGGxWlL1BBD6/rfQH2d2Y3A/obqxz7XVjDVlk2omQ57RyxY+zL5ffquvZid0G4H6aWewbGcgrst7QJKFNj3UYEBETX/9aK2XT5hQ3lkZieliNT4Ly7sZtAwssUf4QZLRVW9YD69OyCBAPaEqHVjBbJZPoGzXgjXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778908473; c=relaxed/simple;
	bh=jLtchWusixu7LfLoIUA8/jEmMHSrr8/wTXiXbZzNpW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T6/Goh5j/tfVRP+o3soTKI4u6cwMYw5ZSpl7ERtQpShVQmrpeU8frxU9fNdYF5yzHtkZKiWZJpUcF6WQyQYT8bLOCwAk/yREOZchTHpTvrYYacf55SFZMf+BCZ+wsaAe1IMbztBdTtl9QfYjqqgV5Omq48Pp7O6+5v6VIA4AN9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DIquJ28n; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIquJ28n"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2f0ad52830cso697008eec.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 22:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778908471; x=1779513271; darn=vger.kernel.org;
        h=mime-version:user-agent:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mtPgGB2zU9NqHvi7GwOlYOD+kXF2nthSunwFIsncs4U=;
        b=DIquJ28nRAiNX3e4c21epQM86Foysx7I73X/KdspPdb6dTxMdz7oamAutud+IjvUKC
         CJkw3sPhcCWbKDbp3U+V/Fc+o4zlBx6SudifhLKSWvhAuYhVL/Y/Hb9k++SfSt/DK65o
         APkSnk1tjOAdDlT58PbSoWsNOYsGbxZGEMav2pH0Ca0GxN9PO4rpXDv+EtH47JftI1DS
         7EAbNUKrd85lmlHDvj9uZgXW2WWE5f1Z7nJ7b7bwyDa5ctUvtH9P52wNh3xNU8gOj319
         idSx5HrtrkQJVcHo5dQuo9hvnVErZJI7y7lfW2wYG6CJs+i44Ahp8LNYhDEXuc0CZy7S
         Qfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778908471; x=1779513271;
        h=mime-version:user-agent:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mtPgGB2zU9NqHvi7GwOlYOD+kXF2nthSunwFIsncs4U=;
        b=spWujI6XXM8cxUnKAyfa+49GTp/mQwEDE/k5GeRJMx+pNScxCopfMnqVYze3+ysBIQ
         bgy0YgcqUzP10TQVKEWdzhrA5eMYx/WmdRYzbdrkZYj0IJN2eIb4rYp/jHTACWMc79+6
         a5ycjeuK+VPfUq/bUD+Van+mXmOTktzhxZtV4WCaMM+iHmxQdk3fosoOshUVcxo+Tog1
         PsrvqBtiCSwmzvubp2cAj5/KsULRqhUgtuhudmJtcY2xa1u+pRTOg3ZPwOv819P/L6GR
         Zj94/L9ocZLT1BzebUTBDEzuuYAW/8woVo2UbB8agpzGlXOUIddUDJUlxKChE+S8P6Eh
         SnZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9fFagwcGM3soxkj/uMKfjfaYiS+tdnBINKHDIEIKPCv1BtM5o4DCnUvENEzCue08NB8IUp7ozglJ9RCw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmSX9oyLgsUq76vzdpMWo4VXjVPD9/gDQlA9mJqjT5hCriTng7
	NdadwEjCsIpE7MjgnrOJGhw9Bt5iGWGVdakVG70z87p5To/4/goQs349PKK5Jg==
X-Gm-Gg: Acq92OEDPFSVAV8bBAJRwn9APLZ8aK0dNhvKDZ4/ppDlcsZrKGiLtLibcXsK6t6/Dxv
	GLlFrxgGgnj8eQul14e+QKLNdjuouSxwrrlH3YMpEqaddbHaSjxRtUDOIRVx7WnhjXEQW6fsR+y
	ogxxt/o4V5uIWu64z2iCLfhZjPa+3jRmJwGaedP6xmwTwTMxPq2sjRuWfXbaqOfe8E3rwllp1z7
	+/A1qCHXCuOoZX4C9p50mULFCsKEyzux4761hRkpahcybyN62oKg9TxWgluEVen4EwyUjp7uyT+
	RCwkpTzyUBgd44WqupogYLroo/a5NjTdhC0zLMrmcGBNVsrEypqrR638Goj/jVh+lMcTymrd4eb
	CU3q4SkSiGcZLszzF3Xa8So3XrfM2Pn2EBSoorpiKD4QWIUsfoAKt61xegvwyivMcsxCIv8waRi
	i6IMtUOqtHIQr9gpVB3T9Qa4s=
X-Received: by 2002:a05:7301:644c:b0:2ed:e12:376b with SMTP id 5a478bee46e88-303986b14d3mr3240402eec.33.1778908470668;
        Fri, 15 May 2026 22:14:30 -0700 (PDT)
Received: from fedora ([2601:646:8081:3770:e6d1:d01d:99b8:802a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2ea78sm8916575eec.6.2026.05.15.22.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 22:14:29 -0700 (PDT)
From: Collin Funk <collin.funk1@gmail.com>
To: bug-gnulib@gnu.org,
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara
 <jack@suse.cz>, Christian Brauner <brauner@kernel.org>
Subject: test-fdutimensat failures after 7.0.6-200.fc44.x86_64 kernel update
Date: Fri, 15 May 2026 22:14:28 -0700
Message-ID: <8733zsj5qj.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

After updating my Fedora system to kernel version 7.0.6-200.fc44.x86_64,
I noticed that the Gnulib 'test-fdutimensat' test fails a majority of
the time in my GNU coreutils checkout:

    $ seq 100 | xargs -n 1 sh -c '
      ./test-fdutimensat >/dev/null 2>&1
      echo $?
      ' | LC_ALL=C sort | LC_ALL=C uniq -c
         14 0
         86 134

Here is the section of code where it fails [1]:

  /* Play with UTIME_OMIT, UTIME_NOW.  */
  {
    struct stat st3;
    struct timespec ts[2];
    ts[0].tv_sec = BILLION;
    ts[0].tv_nsec = UTIME_OMIT;
    ts[1].tv_sec = 0;
    ts[1].tv_nsec = UTIME_NOW;
    nap ();
    ASSERT (func (BASE "link", ts) == 0);
    ASSERT (lstat (BASE "link", &st3) == 0);
    if (check_atime_on_symlinks)
      {
        /* The first assertion fails.  */
        ASSERT (st3.st_atime == Y2K);
        ASSERT (0 <= get_stat_atime_ns (&st3));
        ASSERT (get_stat_atime_ns (&st3) < BILLION / 2);
      }

Adding some print statements in place of the comment:

        fprintf (stderr, "%jd\n", (intmax_t) st3.st_atime);
        fprintf (stderr, "%jd\n", (intmax_t) Y2K);
        fprintf (stderr, "----------------\n");

Here is an example of what is seen when the test fails:

    $ ./test-fdutimensat 
    ----------------
    1778905091
    946684800
    test-lutimens.h:192: assertion 'st3.st_atime == Y2K' failed

Here is an example of what is seen when the test passes:

    $ ./test-fdutimensat 
    ----------------
    946684800
    946684800
    ----------------
    946684800
    946684800
    ----------------
    946684800
    946684800

So, it looks like the atime is being updated sometimes despite the use
of UTIME_OMIT.

Interestingly, in my Gnulib checkout residing in a separate directory
the test passes:

    $ git clone https://github.com/coreutils/gnulib.git
    $ cd gnulib
    $ ./gnulib-tool --create-testdir --dir testdir1 fdutimensat
    $ cd testdir1
    $ ./configure && make -j $(nproc)
    $ cd gltests
    $ seq 100 | xargs -n 1 sh -c '
          ./test-fdutimensat >/dev/null 2>&1
          echo $?
          ' | LC_ALL=C sort | LC_ALL=C uniq -c
        100 0

All of this testing was performed on the same BTRFS subvolume:

    /dev/mapper/nvme0n1p3_encrypted on /home type btrfs (rw,relatime,seclabel,ssd,space_cache=v2,subvolid=257,subvol=/root/home)

I could only find one commit since 6.19.14-300.fc44, which I never
experienced this error on, that looked like it may be related [2]. I am
very much unfamiliar with this code, so anything after this sentence
should be taken with a grain of salt.

Looking at the new inode_update_atime function that was added in that
commit:

> +static int inode_update_atime(struct inode *inode)
> +{
> +	struct timespec64 atime = inode_get_atime(inode);
> +	struct timespec64 now = current_time(inode);
> +
> +	if (timespec64_equal(&now, &atime))
> +		return 0;
> +
> +	inode_set_atime_to_ts(inode, now);
> +	return inode_time_dirty_flag(inode);
> +}

Compared to the old inode_update_timestamps function:

> -int inode_update_timestamps(struct inode *inode, int flags)
> +int inode_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	int updated = 0;
> -	struct timespec64 now;
> -
> -	if (flags & (S_MTIME|S_CTIME|S_VERSION)) {
> -		struct timespec64 ctime = inode_get_ctime(inode);
> -		struct timespec64 mtime = inode_get_mtime(inode);
> -
> -		now = inode_set_ctime_current(inode);
> -		if (!timespec64_equal(&now, &ctime))
> -			updated |= S_CTIME;
> -		if (!timespec64_equal(&now, &mtime)) {
> -			inode_set_mtime_to_ts(inode, now);
> -			updated |= S_MTIME;
> -		}
> -		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
> -			updated |= S_VERSION;
> -	} else {
> -		now = current_time(inode);
> -	}
> -
> -	if (flags & S_ATIME) {
> -		struct timespec64 atime = inode_get_atime(inode);
> -
> -		if (!timespec64_equal(&now, &atime)) {
> -			inode_set_atime_to_ts(inode, now);
> -			updated |= S_ATIME;
> -		}
> +	switch (type) {
> +	case FS_UPD_ATIME:
> +		return inode_update_atime(inode);
> +	case FS_UPD_CMTIME:
> +		return inode_update_cmtime(inode);
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EIO;
>  	}
> -	return updated;
>  }

The behavior looks a bit different in the case of flags having S_MTIME,
S_CTIME, and S_VERSION being set. Before that commit it would use the
following to compare to atime:

    now = inode_set_ctime_current(inode);

However, now it will always use:

    struct timespec64 now = current_time(inode);

Could that be the cause of this behavior?

Let me know if there is any other useful information that I can share.

Thanks,
Collin

[1] https://github.com/coreutils/gnulib/blob/master/tests/test-lutimens.h#L176-L192
[2] https://github.com/torvalds/linux/commit/761475268fa8e322fe6b80bcf557dc65517df71e#diff-325e7194d6fde054508f3ab689c05b774e0755b85d5639dc92c19a2230bbcc2f
