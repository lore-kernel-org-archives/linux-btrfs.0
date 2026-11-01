Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793518406;
	b=cc+ZcJYyQfwrRmwCt/1lAGwcgCtv+RBGE/U0+zr/5h83l4SB5/+2ZcPsTorU+2GQMbns
	 qElTvlY7qM+cOUeN1xYrhYUrX8DfixujiWEmb+3Z0TFAXevKpPHQ0GtDB9V6lXjHdkhK8
	 bMkUeT3/bmJIZ8m8yApCmOEXFp1THZObiEB6Swm7Atb4ku1r/9FmabwlpvcmOZAVsH4Ew
	 gMfzB933mO4mmVgrnM8KtwaaGaLJbvsCshXxU4bWlCD6/UUDUeVZo0+yUqbuBApRFblu8
	 T2aCbixXYK5XhLWzu7Fy4JwlAYUY/pU4icMNbCPp12L6TjhPoTSPDv5+CxdTG8c5dyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793518406;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4Di7NHo16WqswM1423JzZNastXlol+kDD8J22e7BNKM=;
	b=mdwPtnUxqhE5KEBartMQuO8dQiLKpKikWdsXt1khdeCpTuVz2yAh76BQ2maWzIMRGOrv
	 0IWC492FyKdJJt0Dc82q5+tR+62j7YN3lNEAvG3tEgNWV1yDfsf/PmsKDJEjF1GgYYGn5
	 wLSP0hxGxgTjwoguBmD8mN6GT/uHP8wGr9GSeozW6kLEGUyteQ275868T9mjUj9konuio
	 Km9qjCE5RgBDk/uEUaN9BYLAX4q2KDd+SBvszxEUYPBA0AdXynsX376J5vUxjjfymhCa5
	 2udc+IBQ9HPmcrqeW9dFeyBXPjUnwaWFEEMBejmN7/HVI1744gIsdCP4rmJ9T9F7qig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KS9LywDO;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03616606A325
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 07:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03616606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KS9LywDO
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3514b90bb89so4018538eec.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 00:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793518405; x=1794123205; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Di7NHo16WqswM1423JzZNastXlol+kDD8J22e7BNKM=;
        b=KS9LywDOhprJjBk3rdcUFLUiW566TIVVtXMIGYhSuxMoOU3XVf+qrxGWAqQx+2TUf9
         xT+78gmXf7OQXJH7Qp+O5KbbSarbWX3j6ZEjiXPl6DCNU27PwdEl3gINavm0PKPnaiTy
         yc5k0pwmkv5haHZuB9P+zAWZYDEOZT201VesyyvWwv8CveJ8UlCKQsBZ3l3ZoAttL0eL
         dz4fSFxPDdDBPDVppgaWYB4bQ/fatLWYEo9kpPsSHHg/8az4/qhSw7F3oDNIv2Z6oxKz
         aNtqqq/D+0t/Nod9CquAXSXpsHukLnKfuARDumN1XfsyEH7/TspLWv3POwJO7lYVCBhc
         VQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793518405; x=1794123205;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Di7NHo16WqswM1423JzZNastXlol+kDD8J22e7BNKM=;
        b=GTi1v8YmhWZJ4ZYOoxZ5iQsJ2oV3014cI4t4RyqkwRZleukyQ2mC3RFgeBWurPiT3G
         UX9/RF1oqYoZJr/7NJFoJdijn3QwOMOrrLJE2iK8+po2xzWcvKYhv3UoYvzJu/OC/wmp
         cIpfuYyZnd+tHsa2N/MXzszpEXPQKRr9kzQRFfJFJjchWPemuZxFe5kTb70eiePQDUuy
         OPmiu25hH8jdGJvapQkgF7rIUoiusW6v1D+W4vNkrASpjNiLJe3oWRmKfKEUq8BsSJto
         FXAHiPZl9cYdlbtB5AW0i5KFDkuK+BotVDhEnK99zaAjv6LgEOB42a0HlLABCf++1AID
         LEUQ==
X-Forwarded-Encrypted: i=1; AKwUvBwnxIs8JtA5KziiUqZs6HgT0pt0imTUpEtgl0fL1MD2Arnnur08cBkFrbFTPzJQhM3nRw0JDLuaoBAvfQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9f1wAIldZGSt4caPwSzu2QW91Z3qBqwl1ScBEWTKQ6dkaYt7EL
	Wd5lU5E4btGhDsRKSMJx5qzW4ZZ+bVxb65SgPU/Udhbjx+QqeJOE5C70
X-Gm-Gg: AYBFou29Uc8fOgiB0oolFbOcfkL+zgpd0C8WDnrJD96yYq0nBUv0i8/KxfITzt6pLuZ
	HmKMR5hDxPB+n7knG91fA9uXI661FDkhu2pTr+o331gNTYbwnk0WeSjXRWm/NVgoBQmsnUNRESO
	sI5Rvb8tijn/GFj+vOxpprfq8tTRFlat138Sj1LtVwSP4tXcgpl/gGeO1cHRQuh5L8SHbv9VoUp
	Qtej4P1f8ABs3iVFRbraOTY4RhGXSw4A4v75nEiXsmSkJ9LedVBpVe1Ho/w6y45QlqScYvdKFrv
	tyb2zhy+tPgJsCDhP8hn2ylhSXOtVSPPa+OYWL39buHzaQNXkCoQiOUZo9rbY1KzZJGE0ArqpGt
	BMBBrKfabr8vg5MBtQVBd5+6jKlzr/xY3ySBet331FpMAl6yWFfxWAQ4f/9L+5jhEyriZLGblQn
	HC3+qbTos6q0lljxW7mZxEG8NG2RPWTbiQRvjxjNlAa45Tee0WuSMQiykntZsg/+0sC2W2/KHFe
	F1e9rpQOcS2pmqfs/PwisxpCvXQnl8FzOLAcmT+XFkSQJaLJNw4/r3Wj8Xves1lX/ANIH9HpHg8
	xf0flsxMM2dlpqpmFxHGYNd1bGfxsbzfTw6ULIdY1MPYWUZeGjV45q4o13S3ztpoEtnlGzLnr8L
	ZJwrrG64D77vGVQ==
X-Received: by 2002:a05:7300:f285:b0:367:50ee:f7e0 with SMTP id 5a478bee46e88-36a4244116fmr9613331eec.39.1793518405017;
        Sun, 01 Nov 2026 00:33:25 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a5eee0f20sm5561223eec.17.2026.11.01.00.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 00:33:24 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: Cheng Yongkang <teel4res@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT
Date: Sun,  1 Nov 2026 00:33:17 -0700
Message-Id: <20261101073317.1867816-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
References: <20261101062539.1744605-1-teel4res@gmail.com> <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com> <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Qu,

Thanks for taking the time to list these.

To be upfront about where this came from: I work on automated bug
finding for the kernel, and this ASSERT was one of its findings; the
analysis and the patch were LLM-assisted. I sent a fix rather than a
bare report because I had the impression that reports without a fix
get little attention, but I'm not the right person to rework
SUBVOL_SYNC_WAIT and add the btrfs-progs support and test cases you
describe.

One data point on the return value: in my testing on for-next, waiting
for a subvolume that was being deleted returned -ENOENT once the
cleaner had removed it, with and without this patch, so the success
path is never reached.

Since the tool keeps finding issues like this, I'd like to ask how you
would prefer to receive them:

- Would a [BUG] report with a reproducer, the tree and config, the
  trace and a short analysis be more useful to you than a patch I
  can't take further?
- For low-priority cases like this one (a debug-only ASSERT in an
  ioctl with no real users), would you rather I batch them, or not
  send them at all?

If the ASSERT fix alone is still useful, I can send a v3 that only
replaces it with -EUCLEAN. Otherwise I'm fine with dropping the patch
and leaving this as a report.

Thanks,
Cheng Yongkang
