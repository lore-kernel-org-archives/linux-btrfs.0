Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E764A1DEB
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438347; cv=none; b=dvFdI1KUAi4p5ZGu25EEsK5yIzuwM8hqozTjZOlAGwH76+Qb2gpXyXP43xKwcX7lItV6YmdWL5e6xSbs0G3kAiNXtrge4AZLUtykqjitXESsTQ0O3cLpxGSu2Z4xO80kgcQCwBAw4Sb6TpAE9bGIJ9uaecCbRPVoVcE1Yjg9lOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438347; c=relaxed/simple;
	bh=gd41sQqJcTrgpwAAVhj+jO74Ye+0frNhGfIV3VKF0Rc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=LjR819A/tDvaf4eq/jt2nR2Noxq6RuMXJuf7qbPb0luxgHRZZ8U93vntLijitbN+xi633+TSdRUHCGenDJhv/wDH+1kglUD9aa88ZIbFquxHUirRewzktd6NbNaXvelrNhS41HoO8B7S0lIO0r4doSwogq25I3kfil6z+aXg2tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wc0p+tUN; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wc0p+tUN"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b4ab40d839so2068638e87.3
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 05:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788438344; x=1789043144; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from
         :content-language:to:mime-version:date:message-id:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=d2HR0o8c/ywsuqBG66RS8eeDgIixsQrX9fGRzaSM8rY=;
        b=Wc0p+tUNVn47IPKpUfLS646s+wU1NJyKyRaTW5b6vyGx6JSYiaLSJ4hI0DkPx1zU+P
         bkayrByZGNg400ehzDymg/xB4q1nijIlbyR5LfEWviVc5R5HoK/bzBz6rAHO140E+QZn
         okzs6qmucAjJ2ypCwc+3fxV0ky2kZsTslVQ31RAtqb0yjDuLAMtyYQn7yjmfktGm41j4
         MzuXbOBfFwN+gOP/vvsth9a/XrPdUBeuyd2gNV5MDsyoUAj515nC1cISCcObu4YLelTV
         KtZ+n0pVferi5OZl4v5kvVzn+BKiTur5QpZL+64BRS9NKKD4jVDdDWU7ScVMOD8Dj5GU
         GW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438344; x=1789043144;
        h=content-transfer-encoding:content-type:subject:from
         :content-language:to:mime-version:date:message-id:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d2HR0o8c/ywsuqBG66RS8eeDgIixsQrX9fGRzaSM8rY=;
        b=rrsTFhDcqDZoBunvbCSs6I36v0viDPptXn4lInlvZ46qrErE/VsDMi6AC2hZaXtsED
         AWt9aevfnYj72JL3EZyReLQDR9ykJKRmJ8B/wjerjMsH33kgztJwxD25Jz/P4T9ow1YI
         W8bVNLKcOUyIMsQ34J3ACNn35VPaE3b49rNjZyzIuv5CJt6Kxa28j+8RLI7qpZ89QYqf
         IieO8oHkJ5Cos4vvhzBpDCnEXyWyVt9l4KYNbzBaiNSe4ZpyVBpp/KYIx6SUxaCyix2i
         uVtBqkcC0sAwUDV0FttXRMsLDVQ4F+ahPNxPqrPTrX+hztcN35xIevHoWlwk0rPHKSwB
         U7kQ==
X-Gm-Message-State: AFuF++kR7oj0s86tsMep+jZRF2gGuq0pU8n3+DGKmbqJ9Q/4wJSlqj5u
	7MsRkVk2XOx+50S4gW0AYo82jAxo6Hq7lKSim2+H93XlLgwPFUf8DHu/kkRDHR14tZE=
X-Gm-Gg: AYBFou2ysrhL1vjBT3Hb36HG7eX/OrNK774VUQUOBiFwGu3qYYDL0AMRq9qNgGxc5u1
	1YBaNyeoL1xqkveZq1UK7taTnG0cqxOhTNGDb9gmsQIdtwiwyvJt0phl/SITEE3eAyS+1nw1Euy
	U2zoON/Li5XqJ5AZ+BH8RF4NWmyObpyCkaU6QA+d+fNjNs/1wj26C3FDQdy+K3Z6cId+Bh+Tpn7
	dlFejNdIWAFB+aI+vp+GbUdTE4q8hhNhPYT/i5GDqqCOivHa4v61XYIuedxFgl7YKtPpxR4EwKE
	JhyjU4nQHe5tbH9LF5YvslSVnTv/pxvSAcNf7rYF/sePDzALkgx5p0xcPHrIY4X5jleCX6a8YH4
	9Bri7NWkxb/8voCE1mSiU3isPscxdk0QObMi5yLTXlnzWc2ihVUWqGvor6pgzaWrVIub1mgTzSZ
	wNtPC1ob60woue40An1NMySEXrJBy2X6cVyHsakGfrUw0/rxHnwUMKVhwnc2HNHcPh81P13UsMG
	Q3wK/FW1Ly6fIZDDBA=
X-Received: by 2002:a05:6512:159c:b0:5b0:1aa5:b869 with SMTP id 2adb3069b0e04-5b6086aa389mr3156756e87.25.1788438343889;
        Thu, 03 Sep 2026 05:25:43 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b606ba146fsm1262576e87.62.2026.09.03.05.25.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 05:25:43 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com>
Date: Thu, 3 Sep 2026 12:25:42 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Subject: Device for root volume appears as '/dev/root', 7.3-rc1 regression
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

I initially reported this in https://lore.kernel.org/linux-btrfs/018a9738-1d4a-43a0-9352-a56d1e541364@gmail.com/, but haven't got any ack, so assume my message was overlooked.
That patch introduced a regression for me in 7.3-rc1. I'll duplicate full report here.

Device for root volume appears as '/dev/root' now instead of the actual '/dev/sdX' device, but the '/dev/root' path itself doesn't exist.
That causes confusion for userspace applications and leads to variety of problems, like

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

