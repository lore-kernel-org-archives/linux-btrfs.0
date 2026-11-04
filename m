Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753393;
	b=tGMbIMBaQjfHm/qJRZkMMWLReejLfJwyGcJsXIe//HT/DWclOjwVZIAgI9rGryQxBHSX
	 D3Ygc8lP6P+jc7PMl4geCKkM/JlnixvLRHYsIqzHpQmMszRw6j8scK5QHl20Ljy1MjvHI
	 Jum1yIZoBeVlLDQHUaJR78cWJWE5JGlykyw0CJZTyA1zBVSqD6cPixlRaukX2Jg/ufBNW
	 /8ijR/pi9XefadSWOQYK0QAnq8q7RUDsqOilUZV54x5bAYwdnrhbuDhuVECMcuU5WTk1D
	 WHatgAMKavRNvA3RHaktf1t1KfZlz+iwfBsV1t0EpShZZl9TbpzgS6fFUzLrCiqRFpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=Ljprd5M8YJ4gFZok2eAlzoKmrVshZ57zRat8h3/q4JMUCnA4/sgM5a9IfrRqUGjCr9bi
	 fFthzOutxZY2cpVgw3/uj1euDyrLPZhxiSyewir5RNwwseuuQqM5o1n5jtAPwqjSlz7I1
	 GY+M1856EHYsHYCvHcRNGpSmuotltrpN543hcHrcHmp2NlT+hC96r2dZu1FeBEDlfnPdj
	 rWe3aKY/9fFRnV+/kf+KbNPeLxBubME6cfWnS3SmhXFzLNDZORNsDiuodokijtxvOqH49
	 3jBjMFIxLMXnEefQMDaw3gVdtyMPmLvjgt3CWxQ/M9EKh20w8xdPtcJU8FASW1+xueA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCFA606A328
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 00:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DCFA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-886e61fa30fso101055b3a.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=VT+pUP2NwuZcLnfpE6RBehWP9rj7p+v+tKoR/WVHOzz1v7CJgJGu6gqjY1V/YGEdmw
         igNrVOnPTFLv9xvYK2tnZhcPD4jqAzwLjDlQ2iFsJIT0vgZOsXkUB60qRSrv68Heg2+2
         k5XkKmMrKWtBUKDoGvgF6CjyKJx7mmzehyXgiMW8Z51NtcdDEa4LvP5GkI/GPk/JWdX0
         E0pyc83t8pyqA1wDQ4YMhv4IP3UIHbsnnJtT4+s3TyxuI9ePzpN8dD0BzwPhXNBIUBNN
         GS4KAdHBqzLrJ9upnMsWdUfiG2GuZuR+cDGx90+hJalABWpp8S3bPmquj5j2mZuikn7l
         6bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=n3DSt9H7YVBDBxRUNoIeAzvwqR6reZaINI5y62q+2Ag/o63rDGRnw5TnuMCdCpaw3U
         QqUMpEg0Xu6BKgkrFP7tBkKTC79VxOG5BsZWS8LDD3Itq/ZzEgfZ5/XpJK10DCwQWHc3
         EBNeHLgpvbPro2Cyoy2gTXZr0LAUsYfkyYPQZR5ZgXnSmubTwu1bIazlxIsN35CZig51
         XgnFsTao0h7P2AP7rImGnkM028RCrS7JUBkP69osgLtAACV2nPFfS4AbuG0ZdzMA3d7E
         80b7654NYF7VxaCqBmEXX/2scMX5E8n5IkzWXOn/6mFrcvJkxrOYBFyL8t/vBApEmuWa
         hkdA==
X-Forwarded-Encrypted: i=1; AKwUvBxqGXca/1/IdKTIE4K2SazOp+N/RxV3Qh/25SjRqtmXKi7Ga4caOepjZb+A9YfSa+g0S3vgt2mQPhqv+w==@vger.kernel.org
X-Gm-Message-State: APuU4Z//2tgH51g9L8YAux9p1IR4pgIUF6G3ITOJQpvOIDexQkk7GexL
	ky+FTrWu3EPUkBEULHShK9VcTd74r5gSG25LTcY2JFNOXK1/0qP9VLmA
X-Gm-Gg: AYBFou2GLVVMz7SutT5z+g2CNLGk41gphLSCEYOaUzhzq3fMAZO7TKcKKjmL9T0Cv6k
	4TkjmiC3kQfyDC5f0z5EMcUlyPjQ116vopAqZu33ulzt9yYhFoNsRbPC5pPldlPuIkc90GVtgDt
	dZvZHgVUF5aUNNG+UQlsSIf/73a5SSTh2pTj21wMnpGFv6/xQ3w7x49b5HbyiQl/4OUCHUBDvrr
	0fFVd3tRuMXCNrHiK2XdAW86z4WxKKjsalcvXUsdcTG0LM4yQgt0lAvMyI1VIxWkE+hPaTLWzrS
	myXd1MYkll6s+jpFZWA6jVHnrQICAG+LpGCjohXRLsO28udKaSiKra+esiaEiPGAj/Q2jiOwxW3
	/aPdLMFmt8QXWNDrAVcq7YXTDXWZRS3VjFVjsBYyb3Rt24a7gUqW9EuYEpnD8mE0bndX2TZrvLy
	ETvoqePPUbNwwj+TRkcxyLfJ2vkGXLPlusDDPF4uf+zArp/D9kDNp+/9dtmVYNlkRzZgUoCbmzz
	MPC6aZjeVlPcVvbch8Ox/iUl0ZvVjl3ePqmk+v5iHBHKOEXFppuwfskSIj5RwIlGvx89FmlFxP4
	Fmt92yeGlPyMJ4+4Pqs+oEi0UbPdLqAq4QpZIrk=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
