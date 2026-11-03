Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793688105;
	b=aYVgHF56F+1wiirrFKWNHedfbRl1nRUsASee+FW82Su8IhQDVDSldok+SXCgAYN4gmxc
	 QQ2qw40jkS3GPMe7T0zLCFb8SUO/P7cdbsTk4OOyYgp6WgZtH9Gi6He2Y2QlMpe192ADC
	 xxKWQg7D1puoE80tY3wmZ8jAu7k7D+2fzJ+Y9J2N+TKWrgVLKOyYz94ci3hHKJ3dl2Cp/
	 l/jo61oOMJcJkYZwG6+MsefeY6axHhVWdGk7erRZtA1E6wUyqU1vh9FFGSGBZ3JYoBD4Y
	 sxJUo2XMNTsdHv+XtZLv43t7V2pPSMWfuqHP+1GMP1wKsQJ18pDFJIh1E9poSHPGtVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688105;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3GhAdV6YWwOILn4mDd4q6cYiLjqazm9wTfpjdpaNwRQ=;
	b=W6JK0SgYkXIvfpD00Fmv9W5bmdZtQhCH8f2HBQkpzZwNpjfS1Af92ZEJW0uZP/vns+n7
	 xsjIyjUFSvv2oXi8Cjl2UHzjbviQF1rU6imDCz9s5BiMovJlZDGkT0MBzRMEy/ORixqYg
	 Gd3b53FEQ0BhvP4lbtS3h/bTsw3V+LvCpQ8ARYd55MvnJy2Bvkl0AgxzYNPFUQemdaCLc
	 lIjU4dxwnvjiMlc0erNVU+Yqx0r0b+azATMJCH5Bon1C3D2hpG5nz7Rpq645lxBczpy6B
	 yC7uTvXNMgNsLNSkIoYQpYUO+DCGkRHOn/v3gUrJWuUWESoM4zGqJF5rTs6/uQ67v6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=izsSScfq;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356CE606A324
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 06:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 356CE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=izsSScfq
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-15ea896ddc8so6533437c88.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 22:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793688104; x=1794292904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3GhAdV6YWwOILn4mDd4q6cYiLjqazm9wTfpjdpaNwRQ=;
        b=izsSScfqtaEPi04OrrSMWvX3ry3jlF7A9LPcriwbQpO/4rWhTeZT4pB18nVqdcWZ/E
         AjmrJdC4nUFacz/Vcx2JmSsE9Biu4lGwoy+cZP56fPZxJ9EeyCFhRJKnUwplxJ88rc7Q
         uCDthukfC0wtFudfwjj7b8NuB2EU7wlH7HLHI79kH+lsTzNR+dcIIt5z8n25uZuAaWmB
         hfUPPuay236DgiT+/VtDPz7y/wMHliQhdyoJzdIA6dARpaU7jDLVIKY6BD+wde3CddFo
         qL+J7Ddc2MktG8zns4ZSgBHI74CDl+Fwfwyv3IC52UDajptlFsnAZOCxXtUPZw4P8E3t
         DCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793688104; x=1794292904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3GhAdV6YWwOILn4mDd4q6cYiLjqazm9wTfpjdpaNwRQ=;
        b=i6a8qEDipchY0tgeZEkLaQb0JkV2jC/MBqlyqXBerfNRQT1NJ5hQpCHSUHxAR1ISPz
         oXpNqshPGcWj5wZuL8s7IMb1LvQg1kc2UozrzCiPWXBpGpceHPyDAmxIJk5dSRTDLplZ
         OxFJj4oc1Rl3qF7xF5X//lutHKwOx9e9bZjS9EscFzK4uzBjJoHXRB3RU1vCtpWWhOuE
         Lo4KlA5aRBsO8dHitPiXWM5h9SEPriyTYTkYnXv/UZ4g2uMPaALRg/vJB35jlC+rjERD
         iq5j77oxk4DX9rem7d3P3fEARbKJHQm5nH7mHnLtyrcbXACnfojgW5KnVuasNC2DoVFk
         61oA==
X-Forwarded-Encrypted: i=1; AKwUvBzVtdmcJqcnODvI+pTV/Wloqyk1KW+tP7MTIxGgx/sZdZECQTK+nFIcCIy68kZtqtaFi4g3PMj7VHhTWw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+oANHSpoJXy9vRwiCZSsoesH8NCBjTj7bhejEvGYQmOzM6qf10
	q2mQSOYVTzyrHpV34J3ON37RCBwV/BIulcPVbKjOXdtwA47G1sJxHpZJbgjG8lX4Cw==
X-Gm-Gg: AYBFou3nTfQkoTO87tN4Z99Hg2qsp23g/wJtn0hKpwKNfmH7thIaGzHcSq6QYqY1KIm
	k6VF7RI9NYHfBK2nb8azm93a7KosP8GYOaJtegmTPuLxuuVQneSGWDA/k1rApRzTHaFjemgY3ke
	eHyqfAxXoQ/hTsHXc84bfLDfbyD9Z1hXJS4hDD7oCi3XZgkSbOEwvEfsRFwbvscDtU41Dlv2H2A
	c7mtd8kC/NeoRF83/1yfMCEJdO83lZOf60qKeqRJhJ9C0hwTOIQrfGg1qDxjzZvwyznT+yjScTb
	p8Sab7+fsJZYUOCvz/3hWzvPOA/eUN8VPu/HnseQWLaSTEf+z99UPBAAIy6Xg7MrfdErYdpOa2D
	8XCbSq5/B4CZO1rAzQUpsjlkz431fkp0+W6a8J7HJcSdkeeYY8ePnf4/aqufjuUr3UHOqD+n//X
	FnOmaEZ0hGKdVFGuUtheDoxnnlIimWB1Vtz9zHndw27NJAC681g7HxWz+1T5BzFTsAh2SBcZrnz
	+y+AjVza5MkAjIPXlZqO0JZOyRzgx5fAVBS1bfkDzpqC+46o5N/PVsCKCwDONHRtF5Blnljcb9m
	3BQU+Pm7Vc8H/g5k8ufA2kSyI9qSYshkpKZblMflEQ==
X-Received: by 2002:a05:701b:2311:b0:189:d6bf:7ec7 with SMTP id a92af1059eb24-1ac5ae39462mr15976051c88.19.1793688103972;
        Mon, 02 Nov 2026 22:41:43 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:10b:4313:ca58:9bc1])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac19c6b969sm38876730c88.14.2026.11.02.22.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:41:43 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com,
	wqu@suse.com,
	boris@bur.io,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: tree-checker: reject extent owner ref without simple quota
Date: Mon,  2 Nov 2026 23:41:41 -0700
Message-ID: <20261103064141.2224566-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <b2c34370-3a6d-4864-8093-654288885616@gmx.com>
References: <b2c34370-3a6d-4864-8093-654288885616@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026/11/3 16:46, Qu Wenruo wrote:
>> Cc: stable@vger.kernel.org # 6.7+
>
> Again, use your common sense other than fully rely on LLM.
>
> Will drop it at merge time.

I'm sorry, that was my decision. I thought a hardening change should go
to stable if older stable kernels can still hit the issue. I'm new to
contributing to btrfs, so thanks for being patient with me.

Thanks,
Siddharth
