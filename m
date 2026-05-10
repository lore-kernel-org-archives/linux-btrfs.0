Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D839C645
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778423918; cv=none; b=E8S168VJTNAWHj+uDlRdFtEcTrSNzhNZ5OLAck8eoQ+uBHKFuYh+RPNj1l4reoPty9bjaI0u6EILFs9eb1gzstKIBdw0NKD07FUsL1fbjdocCN7m6VdPWO5BytNFEw6ilxU0kWOrhUf1D3ixgoIZqYp4tuZyuClk2WD/2AevF4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778423918; c=relaxed/simple;
	bh=/2XL4trEbjn5CP68GA1QnO7uxOZ0ROAXXXGF/2NhEFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PrC762j/6Kntkam2jXbDIuVHGR7807KM6oasILWh6o743LreJqTFtEDmft7JdRB3XxTPy3DbWRgQwXzZeVszRgWkLrh+3mdM/xrFlES74SoDBHDm60VHqVKU0e2Fj+o48k73ErEcWA7HY3dWGKvdDXbR6sczTGAttOWkwGTujKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sAY5VMdI; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sAY5VMdI"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2b4650d5f5cso12982845ad.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778423916; x=1779028716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpDML54QKGWucfsLQOWHYTroG8j8CboapLaYLd95Gzk=;
        b=sAY5VMdI8Sq87FXZTAthT4Dw+o6XDiIdV44O79feQCzKOXqVE/Hu1nEMsm2O6q/LfI
         StveKRAuJDNl3G0pbYlgVDMeQElHP0o/PUu2YTjnrPy/AtKefsQnXo0nvzi7goZ12kVo
         sI/Wa3HieEfw6TGCMKV0r6lg2UUoe+/osZWT6oXmiQ36DpHjdfu4R3/e0jmkm8XoN57v
         zE9i4WlObJyA6+lxAm+Zi7ATMRtb+mzi3TixT0JYmjl31txFfxDSSYG7UWjTqMP2NSo4
         aSgBdGVEhbpErKthN7P4OQF0g/5yILv3fsryBer8GrJi5koZWK9A3F0lJIjixqYxHusL
         8fLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778423916; x=1779028716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YpDML54QKGWucfsLQOWHYTroG8j8CboapLaYLd95Gzk=;
        b=HjRaoStO4SqOmllUf7uaLYtL0CSz9ZPhrgKqe3Bzvk2UCrBkBfRSPRuIs3B/XDClEj
         Tjct7OqV6j7VJZHhTjZP53P/5t39MfRzA/WXGm5YsOXYtPTpmotOAtLVCpakgPN5O6kx
         cyNMTGTHofnHkqzHS5wklh9jNaDab28q9p55zRq6GbRlRJ4/OZHWu9YfcV5o8TVQnrCE
         x/gWpT41IQiagBWNxOAypmGe2zXXQuoh+RBWscnKhzhAaglj7TJ0rA53jhr3GrvhBv/R
         ttgIH9Tu3MazlB87LI6LMmQo652kUOfWrWH61g6mL2YPhEFL3NkQWKhGm3Pt51fE1283
         eaeQ==
X-Forwarded-Encrypted: i=1; AFNElJ8V7coQK+MvKOTRJdBAKPuRaXmlbx/8lfh/dtyIRGyEj5TRZottaL7dY4w4Wl7L31v2e/4FpuQsR+yb4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRbKEyXCgSJ3YQChmOawFd3DN0hlZ2ziEqneJopqpBniXBOoo+
	TUBmRNqOZG+TMWF+sygsXOWJV75MIQgbs7o/FMEOQwjulJPpw8gNSS67
X-Gm-Gg: Acq92OHWIDT089M4Q2D79NPh8e4rSrBvPppIr5LSTGo2rF9a34bnZk89uNz1KvVZueJ
	Ilm7PI/5g1T6KinFwVdFvOkFwbiZ4/Z0ys5Ilz0vRUy3Yo/+Hm7lgDTzrOTZ85mRYbm8w990Hg5
	WKJEM6sIoDca1jqzqdtufGcrfXhgJLQBBcsjkIFk3uiykJiWzrjagzAWqHpD4KQEjoN1bPp2u/M
	cgpIiuThPdjgLqu48qzOY4gJukIdaKdpzmlj9tPuo02WdZzCQaziIrhgjIAIRlCvKX5/AezlV8R
	HUP7N//nnVm5mAryPM8jqMpDtKNXTQ7BMnk9eI8G+ZeX37xUVNH+nwsEXyulIwDbwvEM8Pr8sxq
	VMmHCRMgyCstm3ljCJ7u0voL4iPtc77XlYCVSwCm2BRuqVdnOau8u1DiQxcFNcnFCTXspK5HeOC
	xdFemP8RRC9aP2G+cjL/dbRFeAwdXDjro=
X-Received: by 2002:a17:903:b46:b0:2b2:eb9d:1648 with SMTP id d9443c01a7336-2ba79c25ad9mr220978425ad.37.1778423916146;
        Sun, 10 May 2026 07:38:36 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e83084sm76129805ad.61.2026.05.10.07.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 07:38:35 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: Re: [PATCH] btrfs: validate ROOT_BACKREF name before copying subvolume info
Date: Sun, 10 May 2026 22:37:37 +0800
Message-Id: <20260510143737.3710790-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <qu-root-backref-20260510-161800@local>
References: <20260510074943.2644335-1-rollkingzzc@gmail.com> <qu-root-backref-20260510-161800@local>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 10, 2026 at 04:18:00PM +0800, Qu Wenruo wrote:
> The validation is too late.
> 
> btrfs subvolume creation only accept BTRFS_SUBVOL_NAME_MAX + 1 (for the
> terminating \0).
> 
> This means a subvolume ref/backref should not have a name longer than
> BTRFS_SUBVOL_NAME_MAX in the first place.
> 
> Such independent checks should all be done inside tree-checker.

Agreed, thanks for the review.

I'll move the on-disk ROOT_REF/ROOT_BACKREF validation into tree-checker
for v2 and cover both key types there. The v2 change will reject items
smaller than struct btrfs_root_ref, reject records where name_len does not
match the item payload, and reject names longer than BTRFS_SUBVOL_NAME_MAX.

I'll keep the BTRFS_IOC_GET_SUBVOL_INFO-side BTRFS_VOL_NAME_MAX check only
as the local guard for its fixed-size UAPI output buffer before copying the
already validated name.

Thanks,
Zhang
