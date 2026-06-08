Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D933876C1;
	Mon,  8 Jun 2026 06:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780901359; cv=none; b=nW2rl03EiWRwpkXY6TUGfIMCIosdYJgMmJ9X9ajvEynbQ9Q7Z9yX1lN/Y51A3qf7e06rcwyU17yl32PeOiopJIGBZRG6YPO8kk+x1+qq082QRa5O/2Z9TeEI6Sgbs5ZR6rAQ+XaGkkXQq/O9i4+yl1qqjsMB3y9b3MAGyssW588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780901359; c=relaxed/simple;
	bh=WhhmgIw66TK+WBhkMsZlbIksShGYf+LH7SgNLe4pFHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YYwB6F/DbiSgSrIb8wlIGEpUBxFeh7Owd2BMka9olau+M/OlVe/sA7eHD9ldQ5zCNYytmLQoKIRK4QqkG8lk50YLGblx2rMe078SG+iC2F+kXT2t4yx1mbm9x3BUnppcAmg733jfRuND7og373Rw8Gdov8IJH6bAGCCB5y6i298=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CS/H3Srf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CS/H3Srf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDD21F00893;
	Mon,  8 Jun 2026 06:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780901357;
	bh=WhhmgIw66TK+WBhkMsZlbIksShGYf+LH7SgNLe4pFHY=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=CS/H3Srficyd87oQJfXGMRQIduf0rVyfKj8tpkbnsY87WsE/XvS64JvuVxc/nmUE9
	 DqzKA2C3rWcEDgAqQDkkpnqz9dR5xFRRZkp738GyPmJN59t++peI2BMMw2R07cRdYj
	 T2lHIgG2iRbGbIALXVxTWqP8lUcIoLUiloYhOclBb3HE7p+hZs1H+b8dNwBRZauVw4
	 EEwz4vZjEkbRuPB7vTSJRc6MaRU0lfKVCZP2R6dDQOEcf5qW+2ORaQ95zSVlMRjOmh
	 giZyyjut8GBbujnTkLiSy+6hRUNtVU8++k+DW1msqqha9/vjX8hOMs6/48wZcvKNxu
	 jq6yGYsJn+iYw==
Message-ID: <43f292ae-7a88-4b9e-bf2f-d4cc302f9cff@kernel.org>
Date: Mon, 8 Jun 2026 14:48:57 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: btrfs/138: add requirement for datacsum
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260607233801.18453-1-wqu@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260607233801.18453-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


LGTM

Reviewed-by: Anand Jain <asj@kernel.org>



