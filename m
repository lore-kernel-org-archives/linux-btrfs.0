Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.214.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793177504;
	b=kbh3zxjuejCjewz+2Y31rxyYevkCawpnZ54kJlJbBJBtWzyKEOjjz3m3IPf14cJuerBq
	 BeqOiZNjwmrLIj/ZnLZSCuiN4qdiMfkYvUr0U/bgv1z6rd0HQg0Fld2ZrPKehQjAL9djz
	 xkLfqG+UjneW94CWg/a+iE6yC8B9f4Y+su8p3Mp3S8XWSkSe3/5KDHahpoHVwmNJi0OqW
	 xxVMDoWng/aVKhbow0SUh25VIbculUdaRChSje5c7Fbn8atBLhRoZvsgd7d0nvkebp27o
	 ueWEeF4/B/qPpYixDTKoDMIocpleCXcHOwzfTG2JPRxG0SohVX7FTJLqSHJNsaeE+KQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793177504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=1EeFooAMcisDZaa57XJjifs27WOCXklcXpVtOXVSG6s=;
	b=V92FzqS/aMZcbbzW5J0rbdVO4EisqJCD4dCkjbcuHBpPQFEvNZY3f+5jaagr4QOI2Yfs
	 xMe5A/H/8lUnn4VNP2TttA2e46xKvNINMhPLoegiwsLz75quBcEbjMkIrkGCQG2goeMZn
	 0E/7tuhHDaFn7N5PiwrZy/TfK3Ex8tgFxyk9faWQvAIhoeacm9EiA5f8PYB/c1WeWra6J
	 LCZJEqh3HQ3bRNTFA4IeEuZFW418minOT1FEYb50YZsTidfjLA488Ie4mUmqc+Xq0ptEs
	 ri2VGHNQzITC+YIQu0jwZivPWvf9v54R+ENLuT0dKHIAJ4a7TE3HFD2KTZrwAqjsRmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZQP1Ay8w;
	arc=fail smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671FC606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 08:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 671FC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZQP1Ay8w
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso4037665ad.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 01:51:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793177504; cv=none;
        d=google.com; s=arc-20260327;
        b=L+HEibIHh+gn7evWIMuPX04Jjj8e44e1ivw/aHzpTk4ie82n8wGGBe0I5BhHTL2OA1
         5p927f+a3cxiN0d1WdqyWNw78pkJ0ojuPd+M89Rbl2SVafVZq8tj7YkmX8MOoQxPLyEJ
         G28G9FtOSKMDeBdQzB377Jp9+FMlJS9Qy1HEPp3AaSD0G+FFXoyr/VOKI3uk1nJR/3v7
         QsaDp9YqrRT+HXOICSNEXR+uKvqZAx+4Txdq1va7WalEiizS4K3yin8qkjn5WaBeJ4MX
         AsZHzIxIJno1T2l1jnZVOsGDcmgJBKRiYUb1Oqx1I09r7L7aBJUUetKg4byXBsoKGL5t
         otJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1EeFooAMcisDZaa57XJjifs27WOCXklcXpVtOXVSG6s=;
        fh=lyVXvjIeZBUzvqYawrlFSDkRL5GfDfABGIrdc0CGw6Q=;
        b=H4MHdpdPzTVsVwvZY0YpwnzjYkSmvNx6HoV61I+1z2sAKRQ/vmgZeTA40oe2HAybJ3
         o7IuwR/39rO8NdTvrMZ2SnEmxxsmm8E7emIbnfMgyijR68fKHnNK3wSSZw77kSpqgj1o
         Yvvl4F/L75hylBq/lsmy6IgNgRiXhw38V9P7fTfd4+tq1ZfcWtqnyyj3hmsoLaIvI4qK
         Nvg/WZ5vHu502H5tIp8Cm08/eEWuFFXINKKaibpSsLB3hKW2sTlXgv5gzQXMBH61GE/8
         k1TQQgf5+LB2Mu1ABTPIlL4J1kjOgN+3VfQUTDH9ihWiuq701CsV7YxqufG44frw1W5N
         gHRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793177504; x=1793782304; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1EeFooAMcisDZaa57XJjifs27WOCXklcXpVtOXVSG6s=;
        b=ZQP1Ay8wd6LeEZqlcy8Mzgpc1cJNvzlAcc9GY/nFpF5MJMCMiwbItrR7g8j5zdKbNB
         wuJbcNsp1LhPspb1Fu0Gn7zIVq7+3UwMcfqXzriyCRfYQfJfkNvM9R+qBq6YY4YfHEyQ
         +R4GAOtt1KZm6VjJWrUezRrss7HHXtxOD3OB8CY5XS/a1U1rQZ8hprmaJQ8ArM9z/u+3
         sQiQcUyvZoUefKgbj5nZkSIa9WQRX+ZKqcVhejOQZRpUiixmZD6lpNQHimMVl4iDyQfX
         zYIqS6PP6U+jBLjL7Eu3pKqMko7NbZRBZo0cMWD15/YCPzUSfiiUIb61XTd7pAmQ8yo9
         GBYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793177504; x=1793782304;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1EeFooAMcisDZaa57XJjifs27WOCXklcXpVtOXVSG6s=;
        b=og26PSzeERBiZ0Soq7BNwqIzD+aXfdEqwpOW/Wkcz1+qCRQIfb1K5SDxMnz+thdpBr
         dVbjnLDqk94tdzMZmsAD04PW+iAIZg3emROZAQjBae81Puf/62vXUZnIBtstVPZulcLG
         H/G3KVxh4FIk0ELjwyVkValYe0NkzMRCYGzvmSbIETTjPT3F4HPy2WKxOQyL/pI5Tn+t
         Jno+B8FUrw85qbCih3UgqQZ4tIjyamm2inG/UaNa0MimkZh9xBS4bA6rb5zooqeSGKmj
         LtfXhk0Ya7lzieFCc/N5G7OaJk17/9R4a9K/qHIj9tOVzinfXDnPITg+xS3Al8NxcXMe
         0OkQ==
X-Forwarded-Encrypted: i=1; AKwUvBzuH938KXKnQKQ43gjhIlT3wdibZr6kgrLXUugsW5BUKrxO+766qxCpBBlYD5bH/XveHpGW4nD00zpB/A==@vger.kernel.org
X-Gm-Message-State: AFq9FYKvuHNA4qXIw0XUJT15TbbbH1CKX5qFmgu29E2CO6qYXz2mTYEm
	nSlQQ++LsZ8VzyAgFiYd4Q8buLC/PkE8n6ICYapDxDZrJwLnYWok2ZNEH5KFNVKgOydlgBLqAlp
	Xhblwxi/KpQDn8LzGfsmGwr/VpLuatWM=
X-Gm-Gg: AYBFou02e2SkfcU/SqSGsYX2zQ1yZjJosEijC71P4dAKCJrZ05AiS+A5x0kobHuWO4Z
	bVKJraHwp5teO9cjh0BfAK4Bd5W5B82Ydi7rHzNSAot5lZ0gaHuKFXekX37N7cHvDTecPGnNN1R
	wcpzCDxDsq38yC2zecji3iLVzgj8YfWrD6gOQ0aSqOKeZKJojMg5MryfUWX3n2Nnsu209F9IWlX
	Dn1q4ej+nEnkeRaXUqOy/lIAsNXhE0NTkiW2zWTCrpobRDidW/vvBjd7IcipnFQvg0S3NEe8wGx
	dmbrOmnzWM5bH6qQw4UZsETkHSUOb4Vq1M/gMNR6ijYwrqkA9KEHF/yYv46DzWh+v2ZLDIGDHFq
	604RzU5803VJmo/ylu8uIlw9+HEo4mPR1puOtM5pzcx+7MsUlf4bKVMCT
X-Received: by 2002:a17:902:d546:b0:2e8:486d:fa00 with SMTP id
 d9443c01a7336-2eb00374563mr16912315ad.29.1793177503597; Wed, 28 Oct 2026
 01:51:43 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
In-Reply-To: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
From: Luca Stefani <luca.stefani.ge1@gmail.com>
Date: Wed, 28 Oct 2026 09:51:32 +0100
X-Gm-Features: AclHuK-W7tQ9BUgY6zXhq61ZHhZ-QvaVHjA4WXgAGEYQXLZpdA0nUbFDuHHyB6w
Message-ID: <CAO0HQ0UE5BtevPHHfV9mQo5HoqzxzDDjAkj9e=pD_0AaXmSYFQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
To: zhiwei.liang@zliang.me
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Qu Wenruo <wqu@suse.com>, 
	Filipe Manana <fdmanana@suse.com>, Robbie Ko <robbieko@synology.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Oct 2026 at 07:57, Zhiwei Liang via B4 Relay
<devnull+zhiwei.liang.zliang.me@kernel.org> wrote:
>
> From: Zhiwei Liang <zhiwei.liang@zliang.me>
>
> When a suspend starts during FITRIM, fstrim can fail with:
>
>   fstrim: /: FITRIM ioctl failed: Unknown error 512
>
> On a Fedora 44 laptop with kernel 7.2.7, 3 of the last 21 weekly
> fstrim.service runs were in progress when an automatic suspend started.
> All three failed this way and left the filesystem untrimmed.
>
> Since commit 69313850dce3 ("btrfs: add cancellation points to trim
> loops"), the trim loops return -ERESTARTSYS when
> btrfs_trim_interrupted() sees freezing(current), and FITRIM returns it
> to userspace. Since commit bfb670b9183b ("btrfs: handle user interrupt
> properly in btrfs_trim_fs()"), btrfs_trim_fs() returns it right away.
>
> -ERESTARTSYS is only valid while a signal is pending, because only the
> signal handling on syscall exit turns it into a restart. But
> freeze_processes() first sets pm_freezing, which makes freezing() true
> for every user task. Then it walks the task list and sends each task a
> fake signal. The trim loops check btrfs_trim_interrupted() after every
> extent. If a check falls in this window, the loop returns -ERESTARTSYS
> with no signal pending. Nothing restarts the syscall. On that laptop,
> with a few thousand threads, freezing user space took 2 to 5 ms in each
> of the three suspends above, and all three runs hit this window.
>
> Make btrfs_trim_interrupted() treat a freeze as an interruption only
> once the fake signal has arrived, i.e. when
> freezing(current) && signal_pending(current). freeze_processes() sends
> that signal in the same call. The trim loop stops at the next check
> after it, so suspend is not delayed.
Looking at how ext4 handles this scenario it seems to me they don't set
the error code to -ERESTARTSYS and (from a quick glance) return the
bytes discarded to the caller.
And like before they continue the discard (which will skip/fail again) until
there's nothing to be done.

I don't know what the intention of btrfs: handle user interrupt
properly in btrfs_trim_fs()
was, maybe we should just swallow the ERESTARTSYS case in those scenarios.
>
> The restarted syscall re-reads struct fstrim_range from user memory.
> When the device phase is interrupted, btrfs_trim_fs() has already stored
> the trimmed byte count in range->len, and btrfs_ioctl_fitrim() copies
> the struct back unconditionally. The restart is then asked to trim
> [start, start + trimmed) instead of the requested range, or fails with
> -EINVAL when nothing was counted yet. Skip the copy_to_user() for
> -ERESTARTSYS. In all other cases the partial count is still copied back.
>
> Tested in a VM with pm_test=freezer. Without the patch, 18 of 20 freezes
> during a trim leaked errno 512, and 10 of 10 restarts after a
> device-phase interruption failed with -EINVAL. With the patch, all 30
> runs restarted and trimmed the full amount.
>
> Fixes: 69313850dce3 ("btrfs: add cancellation points to trim loops")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Zhiwei Liang <zhiwei.liang@zliang.me>
> ---
>  fs/btrfs/free-space-cache.h | 3 ++-
>  fs/btrfs/ioctl.c            | 7 +++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> index e22443598b..cba2f5fd6b 100644
> --- a/fs/btrfs/free-space-cache.h
> +++ b/fs/btrfs/free-space-cache.h
> @@ -58,7 +58,8 @@ static inline bool btrfs_free_space_trimming_bitmap(
>
>  static inline bool btrfs_trim_interrupted(void)
>  {
> -       return fatal_signal_pending(current) || freezing(current);
> +       return fatal_signal_pending(current) ||
> +              (freezing(current) && signal_pending(current));
>  }
>
>  /*
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ac070c745b..b02c59cbb0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -529,6 +529,13 @@ static noinline int btrfs_ioctl_fitrim(struct btrfs_fs_info *fs_info,
>         range.minlen = max(range.minlen, minlen);
>         ret = btrfs_trim_fs(fs_info, &range);
>
> +       /*
> +        * A restart re-reads the range from user space, so do not clobber it
> +        * with the partial len the rerun would otherwise take as its input.
> +        */
> +       if (ret == -ERESTARTSYS)
> +               return ret;
> +
>         if (copy_to_user(arg, &range, sizeof(range)))
>                 return -EFAULT;
>
>
> ---
> base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
> change-id: 20261028-btrfs-fitrim-freezer-d4cba16e7e13
>
> Best regards,
> --
> Zhiwei Liang <zhiwei.liang@zliang.me>
>
>
