Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753735;
	b=47jfALs19Sii1Me+pjj3Wum/eBHQim88wEf/ThXOvP3g52+jLYp9AOGFMuAV1P53CiZt
	 yuWyLKYIf98gmP4xXNzrQdxWD/Dp/FeUtQXO546D9SsqlU5HRhB4E6a2OK1wkQMz8yeoD
	 zXniAo0VOZKmK5S6j8QB3/Xm6oAlpFT1pfnzQ3qJJKW+DzEsGVZkbTL2FeyHXSMRAWXKm
	 H+1BVJDECR43YytWdCYhFP4ITPwZaGIwNqfxbYw2wC0Lsg82UKsjEoYGy7jArgllvfiCb
	 ox3UZb/aLF8PTF9dmDJJe/IRTiIRRXzUsiLyMMxuTL/VLfKZW+BqXN/TzMVkvEYdIGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=TnV1KU2v3yDMiZxVFkcDB6v1EryfJ/ed8qlDtcWz8Z3+3WreJxk6JGpxImsdTvyTty1f
	 aWD5Sa9ICVWL7jKESUnwC1arM7yvr+J94QzdihtOcYsk5uIVuT6Qr0lNegNNEJwj78Vju
	 gKnuOaoY6IqVf/D+jH7lnHHKeD2yoFxev5+Rt2cBl9upH9n8a72eiZEkqUVkLwZZp/83h
	 JPrCuriLfroCoRM1Mmu+aqRN1j9a8RQqlsSiiTkAi2L5Ztt5CIDQllHpgJr4o3Qh0jhHQ
	 VdVWYU4PhI2BQBVpy31l3CZyorkvHBGyKh4gl66ZehjrkFiJ91+zoJrrgpcb8rLVbtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C40606A330
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71C40606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so150014a91.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=sudo5wuzf8me28sIhbntLBwUiKNWuwSV6wtIncQpUBbsN4Zu1yMj1uOdtNMULS+qse
         p10GSTbsQZQej+RmcaRVIPfYXpiJc7DVP332tBPCeYi6iIxYHtw/pCGnwu6pUZaiYkuu
         1jzqj0fIApJI24vXlIZRW+4LFyo/2rv7mV5cIr8Gch74DjfIbhBYVLv8/dyYnqAxTrWw
         7/Kxsv4asQfbrP6PWPBOlk/xWVzyI0hLDQrJy+RjayW+oFANYAqhfVZpq60HUf6srI5f
         LvFF0LRAtEUesVRTlzKq8hIDxyh050q8ogJnunYhdFI0Mss29VGLQmid0PHrrP/vhgJw
         FudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=jkcC1zMVNiMNt5FgZNBwVqu0FrEYR0zWajRDPZDhLmqkjaV5yK1IlYeIcLbLt7fpom
         0in+0sLT/Gwu4GoUizh8XJenRhzS3c97yyFCr5WzFUZMxvbkk6s//2WG1yD0cqzcVnn+
         2+ZvmX88uUtBRvSCOrPFzVPznaCGE2uMqkfZ/5TKNYmS6yBALYz5VLlcPSmWojoqzMH3
         vZO2/LqoiDNh0tVjSr5+FoX2KOMDjhwhVb1E3OuV4M4McSO2M9hYR+0BJBYWjfmvq3Ic
         MpOxGVdwY407ryuYCucUgTy1+MHE9CoVj969s8wBLu/Sb/q6kOm/xZHZBTRvx2r/Zd+x
         7Kew==
X-Forwarded-Encrypted: i=1; AKwUvBwPzutoyJaK7bz78p0GnFdQuVap6iMGgyQBR9i669ZpXSQvdLg7uC4QHSLBrnOdOqFKEfjKziJd253mVQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+zDV5TevYy+UilqqOICyHPMOIoOhKrAYshzVDbTj602KB/ye2v
	bS80gWro1QmVir3NMVDnA2JS6x5BmMKSxO4pwcPgtsujxNJgJVzSJOGY
X-Gm-Gg: AYBFou2MoAD7lB2oF32PW6+IXmBUioR71JRGX2HtTkvSoqqL541xfuh1xrWz6/lQPMJ
	M8ufFT3gfncBiTZr5+UB8EujxGC6MOw9J18STrZG3Yv1XR+FQKbasuhYERElJxqGETpN4cCS7lD
	FOQDm9M3wAWnO0Nd3zxx1CfyjDAYq+KRRGJxPGOhG3a+DuJ/XE2vUOss6zzODX+bZIsk/R8FJCf
	gi0rzXmbFuE+GI8ZOewyNFg4RdXucWhwhNwGg81KJdgjt4jYuxxUKXgpD6ZDJHKPX6gVzGNWtHp
	JoCl0HKPIeyTSHZTSBO4BrOiy2rJDEEKzl2joVD6T7SXoMW5faHnFAGVzaQCTUFcL/zNJkYFiym
	ffEKQs9tkYKz/mP9rv5D57iG26FMfclqPcIecF81g6VtJKRaIbuXkq/T0HQzo9imtFjMizwzA8w
	mNQVu9aZ/TTWk9H1CEHPzLUz4tbrmM+rdcF8tqXvTNM6RfAAg7I0T9KOk4PiinW5sWEvtacewrB
	68ZYlUMjarvKGDjFoQgMYoVY5yymL5pYP5pLBd4GtyTR+V/4Id2eAQ1nxuuYZKxJSQRd/AFtNnf
	mhhcY3ubYtZcKk1o0w==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
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
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
