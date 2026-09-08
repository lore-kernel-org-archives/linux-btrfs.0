Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE374A3F25
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788906150; cv=none; b=J0FyjImALq4s5gS8SikYOdtadPwNvL6Ml5h0jINCUCMfdPfj3eDcGE8qN+eD5abRsPtoRgNEBQTJx0aKk620X16PfNK+5FKtrX6lHBWdbmM6+oEglPrH+2VheiS4LiHSTYSBPB2atxOAuIw2KSOqf7q4+UZEl7ngAmAHC9Pge1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788906150; c=relaxed/simple;
	bh=dBHzUIUBfsk5+tZfCjA1x9npjd6OXYKBljORHRBuAoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rkgEyoTg6kZid+Hx8KruFI9hz0linxfhyImPQHotsWQ99qCtB8Ml1MvZ/UzVIYq38/m1uSERqvirC6sY06h/GjthD+EUrDAz/OXl3HhVZDe0VAF6oIvxP6/gdSzVqevhaRMmzv8uJkAMG58Lo3zCG/8FCRyD5GxP7u0lrgKvxoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=owH+zgz7; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="owH+zgz7"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f16f12so440094e87.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 15:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788906146; x=1789510946; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dBHzUIUBfsk5+tZfCjA1x9npjd6OXYKBljORHRBuAoY=;
        b=owH+zgz7Mg8jAuv6lAmO1fzd+zXeljxm2ElNWmnYpW+qzAvgiUdP0qWvwa75Vy0TFJ
         nr+V1OySO4fKlx3GbroUNHxDyD+nRcHxNwfmyq/zo2ofjney3juSk9oGjw5ju6TMQdcQ
         BTUPZjPYeLf06tCIc9r07jHZDN4Ms6XumpqGzveauvLdUpfwF+3gsWADVTt5NA+2wyEL
         rnezxvMWEJIaFEhnIV+WsNhkhB7uIHlgGf5/pVLVZeq7yHeWb2jb499WTXIpc5MC0Knl
         i5R9EIrrcuyRaqGiLXfmTSxIYyu9dRfSS3bxJe8eN1OtyMt8g4fexPvdiVmy+lP6esxJ
         qZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788906146; x=1789510946;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dBHzUIUBfsk5+tZfCjA1x9npjd6OXYKBljORHRBuAoY=;
        b=qPwC7v8bQj629n0hEgxpqrot5dIgjRrDrBcv6Q5nkEdHzxw4iPFimcUTrt9UGsTsWd
         wgfpCrQ3ugagt3gkv0iyF7Mhpw9nxpXITQN6uBMmXvIGI7G1upA7IB25tNh7/hk+T01V
         63ouaFtDHJWl3F/aw50MKRSjOs/zVhQBcVAtXDnHmZEldXXsPPinThEhe5maYd4FeHJe
         Io3D0F3yKosg1h1yVWFbRjIXkWJlS+h2j4ADyAWMpoYaxdAw3ePrALw7GH+XrX4bGDXz
         p/WeyfeeXvxxGUM4HYeRZCNb7MnsYITBUfwtHoHk9KTULIv/AhyX4/HWn93s7F6UB73B
         q47g==
X-Forwarded-Encrypted: i=1; AKwUvBxmOQYDNx/zLx5nJJHNkJTb7ygHU1g6W0fw1HuBUuydQKSOy7htx/inIZxwUb3fZA2esNZkPRkKe2o1kA==@vger.kernel.org
X-Gm-Message-State: AFuF++kB+Cf2ZRzh7ERbNgNjsKG2mzpa2CYIM6Vz9dbx4OwETsUKWV8j
	7x4JMzjY+X0lgb7nFOuVHj8tCbXtMnojSI/xVQGPyQ4doNcsAndKxGv2
X-Gm-Gg: AYBFou0e15jDkJRWyfKTdRGJF2LT3OAlsK8iP2tIXxVnsF1bLnTsw+TuPkSK0XF0z9O
	blVw7u+zu+6muv3qCLpkT6Gvu3EecZNfS2PcjUFUA8CM3wyX790f8EyG9eBnjDJ16ASzuMeMGqw
	ZSc8TuIr464GesCRo9OU7wzOErrY3eWKBLdXZiOuGEo2zhLfLGBY29UHmCMompBnPltBWuBasZr
	pEytg0RiS4yDFq9xYl1zNW6tVx6nN3y2ztxiwMfBq62ofvoXvztBAAeWDVbvfTtHsrpBxv8LwV1
	R7MZr8AB8bEms8lYElBOT0WdQgN7PwKkFuu55lCr6Yx80IWIHuWLxvY1Bek3OA3uBuZ1nZR/EtE
	X/YpszpKI+nlVnLi4gjfOSPO98rMMpEtOFlLRjMXMGty0enz7JAXYRjbsxAJ/VE5SU0EAa2x9j2
	p/12VA35inPi3z8AgTa4w6bdqzlKrg9DyUBPURnAjcudHMDaF/gO28Xj5Ro+k/AX7qWutDpk11c
	OQ7jQN+q09Pkvpy65s=
X-Received: by 2002:a05:6512:1321:b0:5b6:422:a61b with SMTP id 2adb3069b0e04-5b763cf3f3dmr657559e87.27.1788906146292;
        Tue, 08 Sep 2026 15:22:26 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b74d55a4absm2792656e87.50.2026.09.08.15.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:22:25 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <378f8289-a32b-4b60-9f5f-dd9f3940b0a2@gmail.com>
Date: Tue, 8 Sep 2026 22:22:24 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: Alex Romosan <aromosan@gmail.com>, linux-kernel@vger.kernel.org,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> Running my own compiled kernel without initramfs

> a git-bisect identified commit
> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
Looks like another consequence of the problem described in
https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/

