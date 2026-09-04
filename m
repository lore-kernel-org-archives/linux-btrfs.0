Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D533B3C11
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539645; cv=none; b=QNPNkeyHyiL3Hji2OUaPP7WEdb9RH+4qz++a/EJHVwV69ffwGVd9uYjibhNIHxKDNSfs5mJpyThlYPTLW2P5uSz2t0F67WKJbVghEbq5psGMWLcUHOVOINUDn3BOWUIIXLIZrm31X9z39pcH6UccMayegZRduRCuGKwh3iq1/qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539645; c=relaxed/simple;
	bh=88/WYNdUmjIt2aIYMTu3hLcoWMK3Yjn4J1AZQhzUDzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4lDNRxl/eDjqMwXkqfUG0P6zcNTeirLJXnO0GJNxzAnoEYPiu0C3MAb1GjkqJOSlRFZRw2zRqdoRN3SerLJoytFUrNg9g99JM3o5jZCXABA66nRr2Bo3kdhbhV+ZqyYM/r6bFjoqJ0tISQH6dEnz7M5nZ4u1tw1/VPGcn+aDBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cg0LKoUb; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cg0LKoUb"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c255c58156bso235049566b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2026 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788539642; x=1789144442; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=88/WYNdUmjIt2aIYMTu3hLcoWMK3Yjn4J1AZQhzUDzQ=;
        b=Cg0LKoUb7+eA8SNYqNTMQjKBeg71vqedpICzWAzu5wzTO292Dpyv642vfnriVdzaPC
         2ThN7zmZK2sKWJvRQyd6uogMEzSoqXA+cjjOuiyvZK7NvbDDIeoVdLn4C5WTj1MVXQ34
         yOd1i0i7b8wfywHEwmRakzp4fsKPGmO/2DBpeBpPcV19qmXfKLhX2s5l7wnOGZuoest0
         fy55Xig/JMDXavMBtH8w111hz+/5nf2RBbofNi49zasnsZAya5b3HBuXDDxh40fQEfKd
         wFwFodugpGmd+hNCK+C1NqZaEoRjTJM5NOBhI0pZYbaILh+t457DOq8DC4lN0Xdkw/t9
         iXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788539642; x=1789144442;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=88/WYNdUmjIt2aIYMTu3hLcoWMK3Yjn4J1AZQhzUDzQ=;
        b=CBpYIociqZCVclrT2EC55yjrt9AUdW1D5llhpnTgu7AouKUooRpDuveORxLTIGyUTV
         0U9VQxkq6Ra42BoY2+5goj9cddGRyPo/aKbjydDSleGVBBfhqMhGsHXW/vTlQuBTONZX
         jIlDJr7RiW0zHgrLcm4Der61TLdqeMJ2p3brF68Onurhvpv7tGVdXokHzJY5EruJZ3kl
         oFMS5j1dyJL0hNKchinWG/z2ZBjELA49hwDOZKeNJfNd1McqpQkt6jjc9PlWSFayzVI2
         DcSgdfNzMXNTjXGi+KmF9MceF9Xwr/K3bqQYhxSxGJLKrvcrZ7TSpXs8dvCewTbNsjwn
         Swhw==
X-Gm-Message-State: AFuF++ni1jo7TCQPoC5tj0+ZkeWSjiwds/hM7OaqDcEsNvEg6UBL+3O4
	YOnrPJ7p2jeJH659vWgroEHt5D2dfdPC/58en8YEgWqovQXo1Cw7XFwYrz1w4sGl9ZAqMw==
X-Gm-Gg: AYBFou1o3LX0YAxr91dPWZza60hKmuRObX1gm2IKJ/CY8lDRPU6UwQA18Y9jKMFeRT9
	zNee4bEd93VJoKMIQHlqvwnnBdvGE+mkfDx/wXwRX10FNntrSEwxgC8BXzNoihLBHzCy4sgOWvK
	0BlMgtzFk5QRfa3mBqma/OGIBKtzJZ6JMpeqMvBmMJgbIiYBIuM98oHN5OqRCympR4kF54+1vaa
	iXGMsaEDBCNlfPGEZO/LI+2Yk2W0h8MP2LaI445ewO6XU5JaXYPtWhu6nFinFf9OCeaC8CPDfnb
	ULJf05Q8iRbInkDlYF7MlEM9envyrePVddX/30ElDnf6VU+FPSa2JmOcjdoiV/PctbjJN5nZ4Jh
	iY+qAdojurmwmasqO+6/H6F4/pCdwq7rgKGBJZN4WdC3lmklQneg72LfNtweVR2aeIKsSTC/k6e
	yEqtsvNlkmbmdJ2GPggMu2XqCFoCWByfjGiLUeeaSNDJDd9SDuM/au0evxC9ei9D4u4PYo2egcQ
	Utafjtg
X-Received: by 2002:a17:907:8d8d:b0:c26:19de:9ac9 with SMTP id a640c23a62f3a-c2619dea69dmr177988266b.33.1788539640815;
        Fri, 04 Sep 2026 09:34:00 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4a8b7dsm134646166b.21.2026.09.04.09.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 09:33:59 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <e40fa51a-6be2-4640-bcb3-ac4f8cf83813@gmail.com>
Date: Fri, 4 Sep 2026 16:33:58 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Device for root volume appears as '/dev/root', 7.3-rc1 regression
To: kocelfc@tutanota.com
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>,
 David Sterba <dsterba@suse.com>
References: <P0h7XLr--J-9@tutanota.com>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <P0h7XLr--J-9@tutanota.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/09/2026 15:56, kocelfc@tutanota.com wrote:
> I am also running into this but only when I boot without an initramfs.

Hmm, yeah, I'm also running without initramfs.
I guess the patch author just didn't consider such scenario.

