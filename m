Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007361;
	b=CsIGgZqWxqPBnTUg+8KdIOfdY4pQWpmpa+fSJLcJ92kRvTfWH2MmJZI5Ad1xFcOtNnc1
	 9is/AchdegFGpOV9ku9KJuaXcKslTRHR6AImO4zZrkZlT4QzcIoUQ4fNw5lEl2AUNZPTh
	 hlhYQ1B47V0TDAAKVXhrUcQ2aCQL6YSTURNUaaW+lE8R4OTQ5hZrQQSX8RliA03MVsS5N
	 5G87lhc8Q75MaaJzwDDs0bwsa/PCPwqwjWkR2Kb9IhTxkVDdGJfy2JthTXHzjcljxtEp5
	 ujC5pSzT7vFd2suHUDzBqn85EumOXSBH6h8zOlqtmijpyU6AMaK4sqkfiXkiCbuB9vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007361;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=QBWPcIk2yb+Rjx4igUAX3tzSdspR8fO+7sumq5/4FD8=;
	b=13DnTJpc4jeS+tGr2hcji4fRMnaGUwMjYBgyhVDtltJdcWroXGDSeoZSOHHsnig1e2P+
	 bzjioRYXinTvFTaek2nqwfDXSxgBpDZ0yVEbo+/Jx8wm9+pou2vPlg6sPCtGCa0TPwd02
	 OrPB30WzuznQeJlDag1IBtV/KFxr/lZQH725eUSYYnBSVlxzlGJcv48vRFO6IzFH7H2lV
	 oL0vZ7Dvyyqkb6PLOhRFqNW/lReBOZA1iARTpHCDA+yrpSVnNZ+VhoeZA+6X4eCscN63u
	 FV7JAth/lo/pOa3schF5a7m41MgdwJCYfnIXKzihufmuZh9qlDcDvpcDobKu/5FD3eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bKoI18cl;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FBE606A31D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 09:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0FBE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bKoI18cl
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-35f1f76ea84so4678239eec.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 02:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793007360; x=1793612160; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBWPcIk2yb+Rjx4igUAX3tzSdspR8fO+7sumq5/4FD8=;
        b=bKoI18clcW989lSoWCOrBiU0gh8DpBEdntpdkTtHaGUUI0xOunFzIyYgRa4UCrh9pV
         TXZJ2SCToAAzF1impa+9znjKATtgWtVqoE7ueSq9o50jTXpOgbskWCu+hLJHBn0xbqlM
         Z3VrdF3w0sLnAN5SPwJ00+GPAFvs91XwikOoqbfGzAu58kkJNlX1U5lOyFdXcECN/lxa
         WjVBiM+l9MSga2fSFwoo+CM+vqrMxOvhsmy2bQdMS8DPyPHBBUIeF2F+eCyeYRjSCOF3
         e6WYCxxKpFGplPP+tIoMBe6HJM9uvK08imXSelP8HfxCd6D+jzeccUx8gZPt36dNwhNJ
         SF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793007360; x=1793612160;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QBWPcIk2yb+Rjx4igUAX3tzSdspR8fO+7sumq5/4FD8=;
        b=gK4owliQ0d0i0Sgm9yEJE4Ee9v9fYXW8EyeFE0RI6RkNT373MkcefjzYSCysJm09pQ
         LHPMpjI88NrjabgoJI/agfPxK2Ay8hABWqcA/wXkemj7eg1PEtUzg876TPATAzkX2Vcl
         nbuz5lea0K35RslVHJJbNa9t1HIsKCLp7eKQOYyTE8epzVmy2UpAKKjKWYpS+bBOqkdx
         KnpyA3Pka2V04I9jMrpMdpCu0xh5lg1vZ+76pXMIutNgSeuxjobJ5VAYeOMrVwLisSkI
         0Oa9lYUTmhRmsbRwrnxEghAO6zfto7bZK5VZO5vNbSRA5owkoI8atTYlFPqItTOAkJ97
         etfQ==
X-Gm-Message-State: AFq9FYIW22l5djQgmy3u8ky6KowlYgZv75QhgshRJnOb46w/N6ffhrgG
	r3qbIMP3EJjcxkXqeOyCA0VpINCAfLUI3JGJuwhWOnVupcqEnOFJ4cfnIKAUBJI7qsI=
X-Gm-Gg: AYBFou1eoKQWbGslODGSRk9GX6MCCkJk62oPt5IXxIsvc5G2/qQ3w+XrDHK+TFCV1/m
	njtMTreZ61V9W6ApW+1twAS656Auzo+CwYdSioABEPsLLqAJJItB6oExVzF+k1XXBxnbBbC1h/B
	i+CpL8iHOr0QA/m5S7X360XsCMzocKmQZrmgXo4chtMo0QmehBrA14s0CnFrAo+h4+HCAYB/Cxw
	RwBgzVsU0/gXjpxWqvnnIgP65/HFlY7sR9+umiTePSTGrDpizLbv5gPd88D/MUxbVwUR2Yhf9tf
	3vBupvNgR9DUg7CoU2tng1EWe57TujHGSLGtZNP29Bc20xpLWZaGOPwLYrqZB0OKPwJBmo7+lR5
	Q8OsoDFqA6wNrUy58ycRcv5GpXB0AmEUt7jh+UsgZPO4nvr3F0VueXQnF7alLkDNTfo6N/s7E0s
	snazys3P3zdCKiaJrITYcJ2bFuOwMDqGzFEJnv5Z2SYcEElve5+6T4lcYtNrNB7vKU5ROzTk14t
	5UsSQDZcIXCFWqA3cUbWY/lYaZXgyWTsOql0S5N9lAL8eC3vuYagMCP8198bYaaK67jMIDziC7P
	Zp5Z
X-Received: by 2002:a05:701b:271b:b0:18b:ca6a:5e70 with SMTP id a92af1059eb24-199291fa2c7mr7512732c88.6.1793007359593;
        Mon, 26 Oct 2026 02:35:59 -0700 (PDT)
Received: from [127.0.1.1] (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a32ff780sm22505800c88.22.2026.10.26.02.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:35:58 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject:
 Re: [PATCH] btrfs: return an error for unrepaired RAID56 scrub sectors
In-Reply-To:
 <CAL3q7H5v8Q-8Be2eRKszfmi4Rh4oLmuOP8dWWfTprRb8VbHxdw@mail.gmail.com>
References: <20261025180304.349254-1-teel4res@gmail.com>
 <CAL3q7H5v8Q-8Be2eRKszfmi4Rh4oLmuOP8dWWfTprRb8VbHxdw@mail.gmail.com>
Date: Mon, 26 Oct 2026 02:35:53 -0700
Message-ID: <179300735304.1078505.8885402861467820350@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Filipe,

Thanks for the review and the pointer. You are right: the fix is already in
for-next as

  ec0795c045c3 ("btrfs: scrub: fix lost error return value when scrubbing
  raid56 parity stripe")

with the same one-line return -EIO change and the Fixes: fab0c0f03cfd tag.
I missed it because I checked lore and mainline but not the for-next branch.
I withdraw this patch; please drop it.

I will check the for-next branches before sending the remaining patches and
add Fixes tags where they are missing.

Best regards,
Cheng Yongkang
