Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3340847C11A
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789400798; cv=none; b=S/SnurlzMaLK0Z4N3sdUXfWNDImAtMqYWTi+Iq/Y+RuxHCy+9SEVAg7wGd/O07tQIaJ+vldvWDDQyvfehMr8aMJUdBuP2cOWIJHMiWP7ojrT0tYclrpuvPfrtEpmFBZYmqFIRdzWEptC07rId8ApX3kzLR22OWZpL1rSP/cBW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789400798; c=relaxed/simple;
	bh=gBwAe5TBiFXfb35pUF98VGBY87i/walO5tOvmQxRV6g=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SgXERGGZCu2qTh7u9Uhq/ILd2pEWxUuKuxyCevZ6qSTIPG7pPkWoRezDLgV1O5Dl+SfV8tkn48z1d1jhdWtodjaIbLgRRlcVn74MEg+DfZzw9jppwdDC2DD8aeSBNmGcH+GibjgcxfaDLAulnpZb/0wlcYU1ftn5cClF6Mf8g7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qe+HigZZ; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qe+HigZZ"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e69b9e16aso20557595e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789400794; x=1790005594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:to
         :content-language:mime-version:date:message-id:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Eueg2rVRrl7/DJi0yRqlm5dl+jGnR5nI0VSR2DkiDJk=;
        b=Qe+HigZZUgv00FzZU8esYfNtJZW4JhUfcktYj71Mai4iL9H2OUmzZPPgXYCpSh3Oun
         VJHisGkCRu+XHflJ1wyHZcwHOcLaEYQY89K3hjIVrYQziPETp0ao+2Q9Iu+BwsIy+4MJ
         ftBic2NKQbKcujXjKmFSphKXlH+eDN8x3uQtGG7xTFr+ssOqkorNjIilCWvjAFFzIaQT
         BcPAE8uWxm+z52WHAGXiqyTxlZH8nka4sa8AZ3WuBxPk7cv3KVuWFuf0Wf6x33n94mId
         Vkr8hOauqV/e+aeZbs1x/BBeurMMjIGTa0FGukulGQ2JCSHKjvuPvuLw3npF5F0v7Ktq
         GwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789400794; x=1790005594;
        h=content-transfer-encoding:content-type:subject:from:to
         :content-language:mime-version:date:message-id:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eueg2rVRrl7/DJi0yRqlm5dl+jGnR5nI0VSR2DkiDJk=;
        b=PyeQDRmuxxlARN09YBltE3hEJIQI+gzLWYEf982WtePQQY8r3VqIr+w4JHBxoIXEGL
         4PBSBuFT0y9m14sTRKbJHpwc+rbt43oOZvHTwCuG5zVYw6qISRMwaS5y9Wado5S0L2lX
         dsLfzEnHE+M24+saNxNbGqPaNJLUo79g8hzGgPUKGhqUHsF7rjYPW0mc3llffC+ZSlCm
         BtjFQKj8fzkI+fCmQdaYPd+f3SV2/eHab4Tlv7PbYfqG1V61hgzRBlnJgsg060crk1hL
         /Nh1mmHMp50J5KmWbaMP7bRWi36qWic50ybUyHzHiqhyJvfTyIkizvvLzR+rGzUutGC/
         pVFw==
X-Gm-Message-State: AFuF++nY4nIF7ns6gQus3myspLEs+Vk3k3d5nunZzbN4YjYa6YduSH+6
	jOGPUF5mjaztf2zbXMpPLnPA7XgVOr5K/Lzxa7/j3ds06BxXFu2LxR4hVH0xSeCnzvE=
X-Gm-Gg: AYBFou3T0GkN/ogFfXKyg6pBZGXH6wXme5nma0SnELwW7HfNphswNU/tAjygyzmrvXK
	1O9z/qkOWw8amsoU/Jsq0jQBM3fCP9EB7xW84ZJIbRRH88Sh2fGAcCYbut14zhOARb8aqnccFG0
	WNVSDwk4awJuO6KRl0l8x1WSFBjusblMEe+h4LuM3+XFd0lMYAB3LGOh2TGv9xQweEqh7hf/8BB
	Pu5WuOQt9UCliL17/9vU+73plK14Bi7UC7TJ9d62n3LJemLAVl1s14pf3gQGwkX3FdKT8N3YKIC
	m83PGBEMWXmmqHNdl/ejweDIhS7jq+k4KBC3pDeRJTxSAAsqxi3UutNutIRfeOTNWrfUhkb6468
	C0pifgN+k78ahNWdhnLiDrG0XdD+Xyfx1JbXbLTwvs4fWgbydTi8JSk4oCp2Wg5SOtwXFecMbRJ
	Z4DIOwAwJIGmkeMG/ZZitE7iVR6HeaFvmf+8HzbxNHOSxGEWHejIT8u+ab6SWQiQZ0ttkCVXNYW
	nC+TlHZHX4Z30v+f5c=
X-Received: by 2002:a05:600c:3b89:b0:49c:ff3c:973f with SMTP id 5b1f17b1804b1-49e7a692d5emr48747155e9.24.1789400794042;
        Mon, 14 Sep 2026 08:46:34 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7d1f85desm6873825e9.0.2026.09.14.08.46.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 08:46:33 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com>
Date: Mon, 14 Sep 2026 15:46:32 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: linux-btrfs@vger.kernel.org
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Subject: Inline data is compressed unconditinally even when results in
 increased size
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

I noticed that a btrfs volume with compression enabled (e.g. 'compress=zstd') seems to compress inline data unconditionally, even in situations when compression is ineffective and only leads to increase in size.

It is easily reproducible on small files:

# echo 'a file with test content' > test.txt
# sync
# compsize test.txt
Processed 1 file, 0 regular extents (0 refs), 1 inline.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL      172%       43B          25B          25B
zstd       172%       43B          25B          25B

Same file when no compression enabled:

Processed 1 file, 0 regular extents (0 refs), 1 inline.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL      100%       25B          25B          25B
none       100%       25B          25B          25B

It's not a big deal on practice, but shouldn't it detect that the file is uncompressible and fall back to no compression?
Also, if I remember correctly, it wasn't the case a couple of kernel releases back.

