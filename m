Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1943C13EE
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 04:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776920136; cv=pass; b=G2yJfZVWeG0EuvC+P1Ny/0IemxViWLxYqp9h7MdPxBRhKOHDksIRtEXhRjXJmlmEPQauxEt7DSCHHQDNS8oGzNRDT0HoSGl2LvfdVbSg/tFyqSMQTLFUDatWemBiWBfZbCadlTf8/t3jWssivU73hlgM3+jlekolgC0sMQyhi+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776920136; c=relaxed/simple;
	bh=cLbxpUCOAdFoH5UrLjw6vhKiZNmE4Bf9rqT/fkPZqiM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qoOvDQ7hED98hbP0TICWZCkAcqOxBuLUd6LXfjdz7J9b9rRGWDNk62scP4Bsi1RbNSkdzIE+fpLSj453hy03kgpDsc1H3pxwUF3Ct/06sUx6aFLBj0YIiPgSe4M51mbrOQ48fv2R3X8eB7AjT3kh/6asM5ynd6yuBZ16DwqH7/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSfKy5V/; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSfKy5V/"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79a46ebe2beso64300267b3.2
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 21:55:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776920135; cv=none;
        d=google.com; s=arc-20240605;
        b=O+Pu3j9eh25xtnmMP6/aNfuM5cPpWGH/IOvwzSABueCcaZJKNcmVm9Friy6S63wSkU
         8XvoLUnWAhmxf59K+s2/0ej9cwTx+DU9iPNpgOwpLgSlLTIa+zWOPXJbM5UUdvV7YA7l
         l2CqOoDD3Ms5Mz+vEiEibIjgrSueCsTaiZiYWm9kOXIZIbwISDvI4346U0vYuXCrCYwv
         kESU2WzxCgd9PJ2DW39ctSqhIrpCDo+wro0+PeJ0Z8M91Ib6wAtahNsxKm02HW5mm0Kx
         jZ5qrgCgzfFdn+K9W+H8PJ26EX+R/NgFfn0+gYDOpX2K+3AHsfYhpBUiiaqn3yhUm5jG
         DqmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xPj4sIMepcrIbxgd21wcMJP4Qy9v+v8Mjg6dgXSTFm8=;
        fh=C00GNRpLvtNFrEwPgY+We6S9RDUl6MyUDzV4zbX98MA=;
        b=jB32A3Dzfi7T6FnxjLA7Zit33NB2MkJFAsVMHmNq2LW9dbEFaq4ipMr+dd429P6KP+
         L41xQih4wihn11aO4NIkAk5mMX6Datem1mg62iSKFbaMsEFPSlxCD1YW4LPb0tTteqme
         LgaIEn04WHTSXOWJehv98ffhExexGijNmPryrD0vFO+f2hNnnHmmY7mqTukbItuRsE9I
         1CYBhwUmAbdvJrqOhORXTR930o2YqL5fR1UbqIJeMuIdl+WGlQ+DH6VpwamT3fHTbEFL
         ri4Uz5IIZO77tm6aas+05x3dxIi4WXf33Fxz7DecFltGm4Lt6/PRKhqVNfsIEtvLMQIY
         2ANA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776920135; x=1777524935; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xPj4sIMepcrIbxgd21wcMJP4Qy9v+v8Mjg6dgXSTFm8=;
        b=fSfKy5V/XIwlmmyZaK/PHbn1r4cuNbNX6vBdnFymr0QzyS5wbvp0S5TpHUR4EJ9EtK
         fr1L6RJAP6ZXOQ2GBzPbtNShp9ozo6DEp/oMc5/os5385taDr1NSn048+e5ZPUL0gaxw
         JaHvW/cR0p7Jq92kUk5C3pjc5tHJX6lmpbQtIA7YS1Ga9a3B1Ua00TgaLAEAYwZuF/UV
         B/TQJH9cwbYqnTBB0FhvDwB6fdrUGX4tz3+BGXi54o5ZiM00caFUG+521mRl2XIM8516
         Ylzik2aYbJZeOi75cyvStHOPKiORKlsLWABV2LXq76d4AuvP8pcmUzPz00vwiVjGRUQd
         H0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776920135; x=1777524935;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xPj4sIMepcrIbxgd21wcMJP4Qy9v+v8Mjg6dgXSTFm8=;
        b=ATN3zkPJl9NzEWBX7c06jZ3XC9wNGSnELBPdq1zQ8qfXjmpEXn9KlRK7/FEyXsxflu
         McuJTTNMQlxAVUJjBk16DJES0xgtSlM+zX25iDzZ6qXUkrrPP4vj33zPVsCf4Ihifm07
         LELPsrLYSWuuhiZSaLucGPZ83h6kVzhUOPn2NghUq32zCgxkXZiRRPtIcIZruExzznr3
         aFkDgwmz7dG8cuuqW6tQgoz2KsK+P3o48XFzdBiToo2oKlS/vUhWNmpgvebDg7rdWTn2
         OHB7yNrd7lPWOSZhHcdzvgtYXvp4nxAZyHhesPrcdyh/abHgsj3v5Mj16F3Wvk/65INT
         arjQ==
X-Gm-Message-State: AOJu0YxdEKfLaTF8kerP3FPlKOxO/l2p1PMiHjCDKS4K/Jg/3TiIPgzg
	SzgxqdnFPgCjaZC3jq7PGvBLZgpEhfZ8FHN4jCOxCQXVFmgopF2rcXGkCtyBd4DCPCZtIfKSMe6
	EhAQ4pdBSLD6ZjmIy+NV6uh1HVDNsp0VjBB89
X-Gm-Gg: AeBDiev/qpMbQTA1rWFbH637dCQ13QzbZK0eyKEgFITvR9qakBp7PMYGmV0HuvkW0lq
	d9IQVAMKsh2kZwMgBmFh4aRoZ2+q1ZTBiNR4CtDZqhaZswlkJqlkCrK8F+MXzghdH1UhbKX6umO
	ItniQUPSTspyahUmYuGGgczgBWkeQBmUFBX8GkG4NZ04COn4Aa8F/bbyXPOy/xRZD8MHoI50HdR
	ISZ10y8puBRPkyFHzyXrq7DyYCE3Z0BYiNhSRgits2LiuHE9xGdIuFz3Ys9jwEkGoylIwr1Ek5g
	kJyis9FHasEpfCao6UMB
X-Received: by 2002:a05:690c:6d84:b0:7a0:17f4:e761 with SMTP id
 00721157ae682-7b9ed00282amr266678797b3.45.1776920134706; Wed, 22 Apr 2026
 21:55:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ginger <ginger.jzllee@gmail.com>
Date: Thu, 23 Apr 2026 12:55:25 +0800
X-Gm-Features: AQROBzAKxz8ruvpdL8guwAQanLEVM53viZWGhQC3LV0LGhSIvaY24EEFLF13JJY
Message-ID: <CAGp+u1YSz4vO_zOgY63Y7bw499Wtez++HuNLZVnjUGkwLihQTQ@mail.gmail.com>
Subject: [bug report] Potential atomicity bug in fs/btrfs/compression.c,
 between btrfs_put_workspace() and free_workspace_manager()
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel maintainers,

My research-based static analyzer found a potential atomicity bug
within the 'fs/btrfs' subsystem, more specifically, in
'fs/btrfs/compression.c'.

Kernel version: long-term kernel v6.18.9

Potential concurrent triggering executions:
T0:
btrfs_put_workspace
     --> ws_lock = fs_info->compr_wsm[type]->ws_lock;
     --> spin_lock(ws_lock)
     --> list_add(ws, gwsm->idl_ws)
     --> spin_unlock(ws_lock)

T1:
free_workspace_manager
    --> gwsm = fs_info->compr_wsm[type];
    -->  while(!list_empty(gwsm->idle_ws))

In T1, the accesses to the idle_ws are plain memory reads and writes,
without holding the 'ws_lock' to protect against potential data races.

Please kindly check at your convenience. Thank you for your time and
consideration.

Best regards,
Ginger
