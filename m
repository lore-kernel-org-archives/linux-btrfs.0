Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AE0468C02
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788293263; cv=none; b=MJDoAgenZ4pvKTyDBFQsG07pZEVvrA9UGoTy8VEdl/V0mG/+G6rCkDMEBg+7mmiHDLJC5IZ9PjPS61joW8uffvX2lOQM3p2/jXnnfKhKF+YxHpQsO6zw2/yV3jFOUmRoEE36cdwE/uUCbZtilOgnnvAunGroMQpu+s6NeI778ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788293263; c=relaxed/simple;
	bh=AOTIg48CH1YOCRpG8AzwjAK1+X4NsZFtEWsPl2B6U/c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=NolwXgoSKIbRlIs9VQ69GmIWO2u+KbuNR9Sayt8tg/FrMsYy8qshq9MBGuOAoqGIydM295uPDp9/9XgvUM3Xy2lR68FXnykIufGo2Sq5xyF5SiIT9YVPfagbmHgVtQUrYJE8rmzJRqInymV4a1EGr42XZ4fMft/gcgXzkX6LpI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUsbL/6Y; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUsbL/6Y"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b0115b9e17so190009e87.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2026 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788293259; x=1788898059; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a/idl2lOXj0jxIcy9TEA5Nyvgcai0dW3tFkm/2c19hg=;
        b=VUsbL/6YFc0wRt+xsGJJOpKeqGoqe+/SQ/G2kcc3LXS/um+rQ2ZxNVU9VK/8b6c1mx
         bHKuVR211+D3n6T622sxqKHJVhgNP9mTbTf/m/7dTwnfhNUPafCpQ1GgLysM92FDZuPH
         yEhBE/MW7g3NQAsTju2avFCw7XDVASW4+/gfCOrOmx37y579Hh0ravw1mzpxLglYx+/6
         joZ8Vg9+Awx+h/TFD6jYndWI/wMRpLXhZFD5JIMCVPRGiVB7S8HyP4qbQU5MjBq+rzyU
         6B6pYmgWHwVa4Np61jjQwf6O94MB12XYXCHbxG0ne+uUNkt3OI4wLf5JjrGL0ueNqv3Q
         q6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788293259; x=1788898059;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:mime-version:date:message-id:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=a/idl2lOXj0jxIcy9TEA5Nyvgcai0dW3tFkm/2c19hg=;
        b=jApBGi1SR8N1CUtXCwv7pzCHERM0rt5jdrN2T1TQkj5AAox6YSomsCe3OwXurxuJxA
         s+9ywqZ+/vX5EPrAkC1AGW0+54sMPI0y/Mnvh/z/hCsmVcgqhCTtCVTkopI7KuyyioaS
         QLJVLI77jmBr89gQk6g1shj5Cn4ulJmkiTRwL/6HfruyCV9vbi+m+xIQDXjU35u6jrLc
         UZaGi0Vm1c5bP+5CblVdZq3F9CYUuHTslOmyIPTFg2BdIwXFqqupNaYVoFaE1uze+eix
         zvec2wV7Ki4dsa3lAkALIadiOQnQgP+L5QdlXUvPyCPG9LDRGVexYbnBOk1KRkdKCHCZ
         ccAA==
X-Forwarded-Encrypted: i=1; AKwUvBxQSQueQ4RJbuLFLTwYV6BLO6uA/L+w3Z+wBykqW1dNyFIV9pGSw/Eos9+X0WOFZvqut6RTlcbAsG0fag==@vger.kernel.org
X-Gm-Message-State: AFuF++lr9J9v18K1dzmdCGldF7fSHYfYmPugmmloqNSbqu3v7TgYpwCX
	ZK1F6qcMn834gDCC2CYIVP+UsswdOTcX6gRf2isCKE0yJN39zpHZOiDO/po17pN3J68=
X-Gm-Gg: AYBFou1znpFRf1OQnyKTxg0AIOsuyeag39fEuPCSTzN/q6olBZpK0Yd1CeiKxrZvQQG
	TM9snDzXycL/Vsb4jNr4RqzVZso5ES9W4nT+Tvy8Hu90rzbS3QBxB0lkD8D9dC/3FH/gXcn79XG
	YxVKPNXwc3kp9q/krhTL+F+2HTEkMNmD+/PlxxpODcB7khl9pNVWzChRr6DXO/Z3FmyvbkJDnu5
	vA0oxdzArEPYrMLkECtg0hu0FM1tZG31lUcnQrE1fnu03gX8my8dgs1BT/okZQcvR2QKSvlxuGc
	mb9OcWBlX6xz/ThaBkWybUFPZgb3moOxtkQ9IvetX1hvZ3Y5GIFD/tOAbFo8pMRcMDfCvp2eeOg
	i1PMSZaD2e6DGlyjCvpzk/3ZKp30+Trebu88dDKMEyDIiikOR4N8mFG6RkwKwWXv7qvHJjgl8SE
	wY84Kg5I74eUK1gXCHUIhjBsEj9MFoWziUiGnKkn+oFzJehNONulrcDEm18Ug7aL1gTH3OGQfiP
	KgCtf3v
X-Received: by 2002:a05:6512:3ba6:b0:5b5:e8af:a5f2 with SMTP id 2adb3069b0e04-5b608696fd6mr75132e87.20.1788293258999;
        Tue, 01 Sep 2026 13:07:38 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b606ba1481sm82322e87.61.2026.09.01.13.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 13:07:38 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <018a9738-1d4a-43a0-9352-a56d1e541364@gmail.com>
Date: Tue, 1 Sep 2026 20:07:37 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Subject: Re: [PATCH v2] btrfs: fix a lockdep caused by path resolution during
 device scan
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
References: <49654338e775adb4b40124ea5a3abeb0dc6fdb42.1784027853.git.wqu@suse.com>
Content-Language: en-US
In-Reply-To: <49654338e775adb4b40124ea5a3abeb0dc6fdb42.1784027853.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello. This change introduced a regression for me in 7.3-rc1.
Device for root volume appears as '/dev/root' now instead of the actual '/dev/sdX' device, but the '/dev/root' path itself doesn't exist. That causes confusion for userspace applications and leads to variety of problems, like

udisksd[1728]: Error statting /dev/root: No such file or directory

Interesting that the 'mount' command doesn't reflect that, but you can see it in other ways.

$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/root      243931136 3044560 240085792   2% /

$ cat /proc/self/mountinfo
21 1 0:19 /@arch / rw,noatime shared:1 - btrfs /dev/root rw,compress-force=zstd:3,ssd,flushoncommit,discard=async,space_cache=v2,subvolid=256,subvol=/@arch

Reverting this change (mainline commit 108cc873398932af589c295f78c348513b8d70d9) fixes the issue.

$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda2      243931136 3044336 240085984   2% /

$ cat /proc/self/mountinfo
21 1 0:19 /@arch / rw,noatime shared:1 - btrfs /dev/sda2 rw,compress-force=zstd:3,ssd,flushoncommit,discard=async,space_cache=v2,subvolid=256,subvol=/@arch

