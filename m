Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794949735;
	b=MhKgikQVSkK4+j5aUYLuqZDRCHOJlDidi1fp6/ZRwoFAEQYPOpAJLQpPRyjgv6YCEV5f
	 0C2Xl14kANvcFsqBx4DWtyEU4fvMOmfnYfZACcMUhEN1B6Q82hgy3xXAiGztK7O0PKAAe
	 UOzIF+pNx/tw16codfoQCp2oe7VRy6sisRYaYzfuQlbv6SLcGMT5mZ51VgltP4gjK6+cw
	 0AbijVLc9M+wmjUumA9mpUd3nfSLbxqyG7HQTxv256d8j9i1wyqBbpPwDgCN+EMLR1Ici
	 S8h3Ufaa7mJZW8t162OILPwxPjgdndojv9kF91FoDUyVB6wsZkCrq1noi6jMV5Vt22w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794949735;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0Ndhc90zXNExJm48LutUZidmJvLlQI09JQPmp2Mht7s=;
	b=RRRoovwPmSvynGXPq8zxCM3sg6CwoBlK5bC3JlyXz/2VjFjH87F1v/HNvG7RQdyEupqZ
	 4g53Ly42QMbiSRb61cF9lI5NKa0H+5HtjgLH9cTpzpTxlG+dROvW3przCNXonLUvQlsPV
	 pcu8pROt64QMfmg4RwM6S5YnuoSnPYatoNgpYykDyIdorUdEi3RXnlpIY+/jhTLWYXTqi
	 qrHG0Rn5jHc9Qg6D9HdKcqZdCuTJS73TJ5Iz2Glsvvud/EptMM0p70J93qaEpVtnephV5
	 d5s8Mmk0p2Gt0QA9jYfh1yBWoFrBBNg2CHO+xSSwkd09NgV02YYxIZfQGIq0SL34j7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nXECS4A/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88862606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXECS4A/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C081F000C6;
	Tue, 17 Nov 2026 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794949735;
	bh=0Ndhc90zXNExJm48LutUZidmJvLlQI09JQPmp2Mht7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nXECS4A/cCjjLtr/g6rqHETd2+dQSEEVIxO7s1ao85VCkkp6BKEkbvsxEa5gp+t4O
	 ZyHQ2FQCTGWBQxIVUV4LVFg3R/y5IdLntf/2S/+364vuLSPKi3iMo42MR625yPIv8T
	 cBXxirb0lYkw3n+1ABb6hgGj2D9aeLdvKIUEVE//zLDzz0IjZ+VBsbBZvb8Mjl2h6d
	 RABsVQRXY9n6zJDWOqfR9+cnBJ9TtmlI4+yBYNjGZeJFKUcdOLpC/7M63saC38QatJ
	 Oxue+1ecj6QxkPeOPWyqUnJjIHNwl17KGLDHiZZgu/UHpC1/Ivwfqw08vqBtzBUi11
	 zHbykhgTjfG9A==
Message-ID: <a18517e8-ee63-4227-9049-57dd1b477624@kernel.org>
Date: Tue, 17 Nov 2026 13:08:54 -0800
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/27] btrfs: zoned: reject dev-replace onto a target
 with different zone types
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
 <20261117185850.4128157-3-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261117185850.4128157-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 10:58, Johannes Thumshirn wrote:
> BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE is set when a block-group is loaded and
> never updated. Replacing a device whose chunks live on conventional zones
> with one that has sequential zones at the same offsets, or vice versa,
> leaves the flag stale. The block-group then keeps being written in place
> on sequential zones, or written with zone append on conventional ones.
> 
> Reject the replace if the conventional/sequential layout of the target
> device doesn't match the source device. Missing source devices have no
> zone information and can't be checked.
> 
> Fixes: 7db1c5d14dcd ("btrfs: zoned: support dev-replace in zoned filesystems")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
