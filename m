Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4F5803A7
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963502; cv=none; b=sPPGqZb/9dflYMdH8CyQBIHRQI8R2CUKbZIK6WCxdP+r0Hoxnvm5EEymFYXMM4kFAADd/eivLJPOROcxid2qLfCcKUUL1FbDweqBmwzcIA9FfyUNCbqhkjoP4gWKwIwP5e6Cn7/AbJaPEgLokgbkIMoPbe/29kEzibw5r+HfA9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963502; c=relaxed/simple;
	bh=Meo9Rp3zohQIqB1vXn367Ag9vMSfnn8cKn1zoX4hLW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r77JF2Z/YCGSDkawzjMrEVU1Q24qr3ynbEnM0vhv2WdciWk+/yN/+jB9uBWJTsz/E018/UJ4cB6HnirjDHLHGZk24+EMP7AsLRRGMyQbkUA4z6sx36h9I7Yxjwph47jffDXkeJBMEpH6oxPl3U0q0w2dgz3Jfh3V5bnNIJCTGHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOnBo9Bk; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOnBo9Bk"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2544ff970dso878418466b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 07:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788963498; x=1789568298; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Meo9Rp3zohQIqB1vXn367Ag9vMSfnn8cKn1zoX4hLW4=;
        b=jOnBo9BkPUFs4cN8QKKcLeiXwUv0r0gFRRQGfjD06sF5lAvoEWtnLYJXNu+bVCzP9F
         zKioutOekmhhaHMab/9+Jf0jtVSif6N40gyQfmY7eiwXLqvpSmVvqs/VeXIxshZj2UQY
         xBDp5pQ4WysqoNnvrIFtF9+QsfAd9QhEjVXwDlRQG2kQMhldoupJvPpPC962lJNzB8gx
         vkxz7r1KNj9+j4wz9rlZHNNDZkWFY5Nw8qH7mB8UHSJffTsrQEQq420XdNBlxxIv2gg+
         dxsR5+O4P/Q/nFAch7hMEpTJ9b/cPHM+3Y3CEqqwGYZBifkLAwhPWgsBQXSMS8M30aKh
         7Wkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788963498; x=1789568298;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Meo9Rp3zohQIqB1vXn367Ag9vMSfnn8cKn1zoX4hLW4=;
        b=F3P7T6iN8lhSrWbwV4/IXoDS0nANnq8YYW03QnwFG8yxXGkScRBg8ouECbLBlAKMf1
         vmf6zlBBRaGcalU6pleNlE5340/K6F9C5eZyCYJU58Pug47YYhkUZe52WEuHASUXdqgg
         ruMHV5GRdPHVhHX2QE5EwWfubdZto669bI8UMMKkhg8Sc2qE/O6kXAQCyeWyUokjMiXY
         TLC8+8+wgjFXtPj3vN4WInm6uPBAVJQMgZejLSRxRIW+waS76Tw/uPD4ZBW522etQuxA
         54fj4slO+hoFNcI87YMR1ds0/1IKL5aum5kzxPDEKEwU2j0Yw8OnYKRZbHFfHrX7q+h/
         m9Pw==
X-Forwarded-Encrypted: i=1; AKwUvByfn9uEhlcyp5Q80485Tll+l5NEwdXaxBnSXVtD5xZQWMJQsLxjsZi+QxoCl7rtLOJEiEWdH7kcOn2gdw==@vger.kernel.org
X-Gm-Message-State: AFuF++mPgHyNchKi8YbLsOUCjvUq0G+Omut2BoHWG6ThDLN/UEshWUg/
	b/vEGH4/Ijg0qzFeulsycRI8bUtnXVlhDm5Y9XRlwopeD5wAvp5kLGiy
X-Gm-Gg: AYBFou0CQBWMl+etqaR3L22dfbfzo400l9SWgsBIJfv1f4d8kej6cNz3QlArfgmJbs5
	FCCnHRlralmaFrb892aXG3c8S3VxfdDJuzjZcLv8zu1qMxg9rX1eG7IyeacgKznMgP2yh0qlHYs
	L5ZwH2LrjCQ19xNTx2PRJjkuJPlnAmXq/f1OOqLnnqKoojTq/hsem3O0Wnx3CkktyLbJCIw8iCm
	f1vWJ64nm/0Bh87b3Lp/zdn4uyXxPscr58qcrptBipEM5ObhEmmZGxXAjwCS9n0Nx2UIuOG20T8
	4JiEkHiq3s1oj6Yd8cS2JkfyEfEgiWOKr40KH+YCNq9R6rUBXTJ2aoNLbHarcxdeNxZrGIAVUcv
	RUSk5V07gOQx+BOWiDnxPRcyhLSBUS9qDGUIqLlYyIFxSh9yKnS9AqjrTYb4IpSsQ0xIxd3Szu2
	+yK8vGvI4AjbZKDZUYjj0oeff3TKU7yagwY0HnyY9V0j3dCoSLUi2zzbV7tsKP8zVoOEL2Vtmns
	fwRJxhJK0mzAHBig3U=
X-Received: by 2002:a17:907:7281:b0:c25:cb7a:12d6 with SMTP id a640c23a62f3a-c260c9972aemr1402237466b.14.1788963497888;
        Wed, 09 Sep 2026 07:18:17 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5497cbsm791502666b.34.2026.09.09.07.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 07:18:17 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <7c331e23-d0ea-4611-9bed-d7099dcb41ab@gmail.com>
Date: Wed, 9 Sep 2026 14:18:16 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: dsterba@suse.cz, quwenruo.btrfs@gmx.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <20260909002506.GF9053@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

May I ask why you guys keep ignoring me completely?
This is clearly a regression for userspace (see my previous reports).
If your answer is "won't fix", state it explicitly please.

