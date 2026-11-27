Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798959;
	b=QsjapfWyjpJ1F7v2ig/yhYzmNUgxeZwQjwmLLN02pICHgYsDGe2TkCSjzTYaaUpMMdIw
	 wRZZqoRMukcNdUolmqbEvkI0OmJdTRiLJLgSDW+31mdu9dnSHJNupL7YcvlRBTtSWuGu1
	 ma/OkhnWaURrvQLzyfYc/BXGgE5JbH7GZFPbqsyMjTa2oUkkrZISNKNpbjPH9ZXlUD8Gq
	 oMuhW2tjm220PZMsK7RmNrBBaI/xc5uJ93xicI6iKMX9pd2doSv68M08B6L+q/2M6aOE3
	 NdRWQz1Euq7Vu6X93L+SXuum18w+aKMnrqdbEyBMMhPYICkPJhM+ooJ4qaN8H63lmuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dikDF/2m8g8zDjsFYIwd62KHX9mHhADlAje/gJZBzbk=;
	b=lsqEEbm3KHw92wtubluCayJxIn0cRD9rFFjj0OPPjRietXtqUuWRA/5Hk465JhfR5oSL
	 uOe6EklIPFz1kWOjt1gvbiHDkD5EAyQL9DPBXjxiVv8vYlM7+fVhK48aGhlYSXgEDlTEv
	 qIa+/ylSQkUpEeraOvZ/JG5QwMy696sxtnIhJ2tejavqUbVvoB9mw6lprDLuvVDYYvl3b
	 VMMtVXAf00u/CBYoBhTRZVfN4OCEY2diflYEf8jDrnMpeg9dDnw6F6IjQFqrei4fIFAFg
	 xjF1ssSuxmtsB9L4IAzmmSuvB/nRJ0iDM2xxuk1Y6WTe3URf1loZOp2gzIePfSGT8gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI01cQia;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22245606A336;
	Fri, 27 Nov 2026 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI01cQia
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DBD1F00897;
	Fri, 27 Nov 2026 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795798958;
	bh=dikDF/2m8g8zDjsFYIwd62KHX9mHhADlAje/gJZBzbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VI01cQiaUYOZ9hlb4YSuKjIb8OxY1OVm9L0E604eiNuYrKIMdks3vCcVCAUEnKN08
	 OgugpKxNXZiGoxWdqJAbpK6X2lkr6Kt7rYQrAKnA/d3x7ru6LSav2jMAmajx+b1cb6
	 u6T9JQ0zoP234JjMHUTsGL49eaJ8zc+VHa6kulKNmpEiuQEsZ+W2Yl+pfcJojAUTAK
	 WFqyK1trkwmaKyvKp6i0kf4S67RUlPlA9FW8nVzCoDFTUoXMlnlOdYluNCPt5AVT1b
	 f5eYRxxiSJ/AsKL286jIjhJTVDZ+AruMFBHP1wF2duXTke4urtmhxsPUYP0nrDIKPd
	 VgtwFMgUb6MUw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>,
	Dickson Wu <dickson.wu@certik.com>
Subject: Re: [PATCH 6.1.y v2] btrfs: fix xattr replace when multiple xattrs are packed in the same item
Date: Fri, 27 Nov 2026 12:01:25 -0500
Message-ID: <2026-11-26-1-daily-reply-0037@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126-btrfs-61b-v2-1-aad130df1845@certik.com>
References: <20261126-btrfs-61b-v2-1-aad130df1845@certik.com>
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

> If we have a btrfs_dir_item item that packs multiple xattrs and then we
> replace the value of one of them (with the setxattr(2) family of syscalls)
> with another value of a different size, we end up not having a fully
> initialized btrfs_dir_item, resulting in a corruption that the tree
> checker will detect at extent buffer writeback time.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
