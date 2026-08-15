Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D51835DA55
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786784422; cv=none; b=DNOdjO1+2/BtMtEWUgMdHHR9b2COevGO1hfk2i8bq4g8x3xeKwFzvu3KQQR9nkeGLuU7+zrNixBQeg5O0iE6KizovGZhHJ1yc6lYmdTQwq8feFlbnTU2S+qM8eJ+nFcEKhPTtnSEkDRUtXeMV3dby0Nj5LRe4JFbCKl2kqxv17I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786784422; c=relaxed/simple;
	bh=B5HZQT09xnO0oUj/MuhKfASlz1TTsiVkWItxwmVvTZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rm3xkJMzrDZRTDE6Ikl3lIW+vg5/jXcqDEDtFavgNZpHveqyxq4zqn4gQSeELGP+dmOwfmweYkVSPkFvxFJlBNkbc9THu/4W21xFIsMjEHJqbhtULt25w7O/GZ3mIF6uxvBSyFDEeZTc8v7Z55+4Wulv2GhRt3bTaimHA1VhfQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMN3gtxn; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMN3gtxn"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38de840f2f0so1582019a91.0
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 02:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786784414; x=1787389214; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B5HZQT09xnO0oUj/MuhKfASlz1TTsiVkWItxwmVvTZw=;
        b=SMN3gtxnSPTn8JRFAHUjElZmoR99zPL6b0VrgTgCmYtYRF/7VGfC839gz/YAWk+911
         YuqyxANT8HGvSLJp1YSl+jxW3T9Mc5y9E/dL8yrz7/oDRFbWdzAL1xXw50hcHGhwveQW
         oXoQh0P4zk40JL3j2hfg5nPv8X8kVqS672IIby7MEzckRUiLvdS4U8tLW4l/xt4puaM8
         ACXs0cZT0vVqrG9Fkes8jQtkXdzA80CMKt3YQgnemsZD0DAunFOeeb7yV7G9YkjPuF7W
         CvOA6KbTnezivzTdC0CyvKqbx6GoLOGsUb25RxyTPmukvSBfTs4jnF6aOPIZMazkQ7jd
         d8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786784414; x=1787389214;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B5HZQT09xnO0oUj/MuhKfASlz1TTsiVkWItxwmVvTZw=;
        b=ARuOlc0f8ls9MF1NP/lyTUlR9H+jTpknT/gLeIt47p6BQGnQm7rOJjG2BDwek6pM10
         TG/WDmixBUtgjPoMYgGGqrMAe4WHvuu8ueTbUHBLF+P8OTryM/6V1WzxrzzJloHIO5fZ
         IfkAe2pjagzdtjA4dPnyQcdJoMlJy0s0Y1sHE0oEy0G3BF7LggrAgiWS12S7M+WIwuwl
         8mfpyBURNGcoJmfgBZkwz51OigV9yM5OVmv2CbjSSul6H+y9kgVHnmodChzsM7unI5bt
         uG2U0/FyzzL5v9f+MAk/OrDHHyZQIgMQBiFbngu1b/C6Ca8PfTI1vZXfEoE/yHGbhvbB
         0WTg==
X-Forwarded-Encrypted: i=1; AHgh+RoT7s8KTwzOjXn4+JOJmn+bTM62fjj5AwehZlSoJw2lN3aGu0jn1UvBKrSQdnBHGyfzy1b6W7BEsL3K+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzNnC98XYcMEkOx93GUc/CK3SeYBjaBoCN1dLThI382u5rupP3D
	bH46mnqnhjq4UUnZyxNywaqLpGEcih0WmSbmvITuksuJrpCcFHpqkPts
X-Gm-Gg: AR+sD12Gq4uDkOSWlbwBKjDZqAqqv+BKIaxqDnYz+wrQMxhjjxcemQoGhP6fGRtJfd4
	V8qASQ4rBnX+xfF4Vv1WbkVC3h2V8kZotL1vwRTyxfULwdiLt1U3tSm4TPRqRJrAe3NWuE9rD0p
	kW2gnqUVL8GW8+d9tdNZWd1xt8XUSYCkgz2sSYiY9BRWu/PNGrfvLD0WawTeuCcPRPzXV18iRpE
	v71O6NPp2vURCbFmjearn/El4SoGZG+rbktExB21oX0YvMFSY/tr8mkVX6IPUXKOyUCmOadiDm2
	wWhYQ/JxbQuVN02B0gNzB7Izx9vMCVrZZCF8cy5jCVprUQjbCA830FILi0DNowZupWRoE/UTOTK
	AspFStIJidRpUHDQ9pd6XYfuSEZuPeogO/6UbQ24gceU0TqLkpYa3HYXE8/xd1eKzt3v/9/ZHcM
	fN9IWGsWJr6jx5VRCGLJw1QxlsXshX0rl+7iNhhXyoq7xxK/plDdpG2xQf1fg9vbYIkNU4gqozc
	SX6aH41nAJcPQ==
X-Received: by 2002:a17:90b:3147:b0:38f:1a2e:6e56 with SMTP id 98e67ed59e1d1-3933b8825fdmr11759602a91.9.1786784413741;
        Sat, 15 Aug 2026 02:00:13 -0700 (PDT)
Received: from localhost.localdomain ([203.175.14.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3933b6d1ddfsm2390722a91.4.2026.08.15.02.00.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 15 Aug 2026 02:00:12 -0700 (PDT)
From: Guanjie Chen <jk.chen1095@gmail.com>
To: wqu@suse.com
Cc: clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	jk.chen1095@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: free qgroup configuration when quota enable fails
Date: Sat, 15 Aug 2026 17:00:04 +0800
Message-ID: <20260815090006.81397-1-jk.chen1095@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <d239645a-b291-4fe9-b256-f0be849c875a@suse.com@suse.com>
References: <d239645a-b291-4fe9-b256-f0be849c875a@suse.com@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Hi Qu,

Sir, for this bug, I only used an ChatpGPT to translate and polish my mailing-list message and commit description from Chinese into English. I understand your concern, and thank you for pointing it out. Going forward, I’ll clearly disclose any use of AI tools.

Best,
Guanjie
