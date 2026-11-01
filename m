Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793514528;
	b=Ckc/VzLe7x4zwBUz4VKFYt2fyX8ejeLMKwZ15j8LthtnOf7gdsoY0rWP1UArBf4L6G/T
	 /sFt2wMx4QrfxDGtWfdbn7y8c6ckTa1g8p6zlicdVDoauicMvvzVo1sxL6EynCaIML5/N
	 4JOdhpwo1vn89TS4sxmwYNBoWYsmXu+qXQzpNwGwhn6/mQbgzvX24OQQFMvPx11Dnon9T
	 PiEkN6xxHXxiCG0zWbTTNWp4baWc0HqJuW6H71ANJaAKKrdLto5+8VEfvPlmHP3ngZn1I
	 UUBTJQsFxn2h7xdOfzNX0vogL4LxR9P/Z4wupGSKUVDCiK77hI0g0YAIZFM9clO6qag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793514528;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cryEu9tHgT27PfW4SdIWtKNvZjOxn3pb1ryVgxYgaKE=;
	b=TAjMsDFwkmGlqpV0kO9OaMLKkgF06XpZKwdYpQCmmTMXm0dgcGoF/7KYxqNQ7CvV98Dz
	 qJvIAmPa8YqRlTOETVFh7Rhl9PjYe843L4PsMolxk0x8VR79fclZF7IKZi7g/vrrkEvO9
	 IkRNB27LcCSwksSlJxbeY10XxoxNFoTzd4nNLwEkLF4Or69svV0kV6C/9KQhv9ivyGIwy
	 b8Km/v3057nmW9xFm38fNb2ZCcN+M5H5xR3WYKb+lDNaREUegwSsEHstaxNR/FBTFd/Mg
	 C4yN1sMrUycuAPz+5fg8DEzBlBhHRvqR9BSSY/t0bDuf5AZbkhZYyo7DuuzPWqmlbHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L0lwaixZ;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5966606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 06:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5966606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L0lwaixZ
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso356600eec.0
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 23:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793514527; x=1794119327; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cryEu9tHgT27PfW4SdIWtKNvZjOxn3pb1ryVgxYgaKE=;
        b=L0lwaixZiwm0CDnMcBAYO+o0aukysflgoVSzeVmDuozuKypw72PdUZKRKdFe1f0I8t
         CGD5zF0o6Xqju+zKLAerHCfnNxqBgFzFbbVl7neBfDc8RFXcz2xPH/8mbUw2LnNjbN2q
         Z752voQkvJF3SLcua+YJKnJkIy4AXguJ9vhKeTTBtZsAiqQVmUv9MOSzigGlvfpQmpt/
         ZmYd14IoazLSrpRfjnxUILGLYs83Y1jX+lFzEz0j//S0qz+zeQfP84aWl/W+7IgXOD/1
         dKsm9vyCmHTXdP7VObXzNx4WYQUJ6jww/b/7TQLBuoMwfBu6RIBZa4dGfVKc12V7O8xL
         bqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793514527; x=1794119327;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cryEu9tHgT27PfW4SdIWtKNvZjOxn3pb1ryVgxYgaKE=;
        b=BRN6Hp2W6OXhilANGAxbonYnpzcorm5EGi6hOJaUPgtp3eekIrnGVqd07cVSz2Q4K6
         turjaYpsnvDg6N18+S/oqgHGhDOxs1bboJ30Jy80hh0Taz+JP29/PzlE+lCYqqGq5YwV
         XKmHhYfnbC4eHZy4NoncMNPtc1HNggV2HjfFFWV8LXPU+Q0xM2Tk/AK15RUTxlNffLw4
         Sy4zz71twE+tfS+72JaeaVcbdUKIrhSJgjiT6XHT+w5V7gB9+qkG9hf6USV7vcYNn2AT
         hOaP/CGhzEGI0oYLQD0RZuyMLF+sp0yDhPplKFZMbY5jA/qMwqoXFXIl7ohpHNb0c8gp
         xfqA==
X-Forwarded-Encrypted: i=1; AKwUvBwzO6JlRnb4yexEEyEuUek4OBTyUlR9NbqZL7qcsSnbXSOZdPKgxosUVJWebtORgKy1HK6diw9ecJhoeg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9B1fbzP9183tJl54zi6N8R65fi9l/OuQmRnW4EimR5z/Y3dDmg
	Mtn2Ml75GqspynMKK+mcoZIPyIbYqWY0ahgOAS/gPHOz6pFbMfZZDmzx
X-Gm-Gg: AYBFou1v4zQC3wBIuIl9hVF0/+Ja/Nvi5yr3i5Sv7ShFGhPvibHJnIg9E1vukyxhOQj
	dInlr9EoJeMnF+Lt2Y5+lR9xz3MndM/AzYa2nGv7LfoyeGlXyCdHgEsWHKFo8e6Zde+T/bOvJkB
	LpyeHGEtYvhWdat1LZthEBO2B1oeE5A1NCaA11HZDV58g9V6RuB5iA/Gw1ege+CKyZYDfuVS26Z
	uvGaIHdL4xdVguoE2beb8a5V6NlS3JRCfHnXIpurgHO/128rEBqhVQQN4vMLm8hyfJZzu8KAxhs
	XfyJsE5jYYUHUYGU8cPtKD3gSKAkniah84+oP/4onrK6MXHyRcQmY6Ypo5MOHqXrpW2AzmBIvrE
	xaaGKobU0fI+WvwGpjp62ZBnEseytZvZu/NEEPb2jPw7vbdwdVdAowkCyB75Tgc68Xz2KGQS+AA
	72ZT3zdl7fqaIGLrq7B9m+8/p+hgpBPTv1ZOitxa2bH24Rqqu7gACiDX0JhbSirMRFfUhUpKDum
	S9OuDzH8YAO6ujT5fjjbZlqndZOl7+iuFLZtCur6LNlNLV1/PvIwBg29RJ4kW2RlRqtakP2B1As
	mgxEPzvPvKxsr7g3EQKSRl/cBJC4SIEaQiNAJ00pfxEz32YoaUCzO1Nw7T8nSUE9hJXG
X-Received: by 2002:a05:693c:41c2:20b0:36a:5042:85b1 with SMTP id 5a478bee46e88-36a50428d57mr7272857eec.2.1793514526725;
        Sat, 31 Oct 2026 23:28:46 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42952e1csm25828235eec.20.2026.10.31.23.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 23:28:45 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Cheng Yongkang <teel4res@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT
Date: Sat, 31 Oct 2026 23:28:39 -0700
Message-Id: <20261101062839.1747239-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <dd97efe9-91ec-495b-b698-acff1447421c@gmx.com>
References: <20261025180258.349175-1-teel4res@gmail.com> <dd97efe9-91ec-495b-b698-acff1447421c@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Qu,

Thanks for pointing out the failed-delete path. v2 is here:
https://lore.kernel.org/linux-btrfs/20261101062539.1744605-1-teel4res@gmail.com/

Before waiting for a deleted subvolume, it now returns -EROFS if the
filesystem is read-only. The check runs on every iteration, so it also
covers a filesystem that becomes read-only during the wait. On a
writable filesystem, a zero-reference root without DEAD returns
-EUCLEAN, with unlikely(). Subvolumes that were not deleted or do not
exist still return -EEXIST and -ENOENT.

Thanks,
Cheng Yongkang
