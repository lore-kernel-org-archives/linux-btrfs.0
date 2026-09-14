Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739BB45FFDC
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388896; cv=none; b=QDKZLA/W4kpiJpFcKY/FJA+CUe9tHbZtVH0M1DtU5zbFaGdezaD9n8tRRspzu8i66ke041wpg6dafcL6u3ake5dp1UdgaVkA9TQFVRGYLByzSLu6dw92pdcqWKjZVptJ9WLc3SRR9REgY569tCy2/POU0jziKd1Xq5JexZFUfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388896; c=relaxed/simple;
	bh=KIcJWp2l8aBpcwfXDmcPkwoC91TRFDdqgyWuaPmjioU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jApK3AaUiBgOphgvnst7UHbBFRnMfxNzHzXs5nJvRzfdYZMlTjpiV4GGeRC1tWwA+QJX+lOAx9KYv94GcQ83Cean+upz/LTyVkwokCQDLGNBFZW3kGfBSK2Xyg+7AAzQ1g2MRW8LJGnpMWivk/C3ntB7YI1t+dtusSs1MudrTPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLx7tVPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLx7tVPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399261F000FF;
	Mon, 14 Sep 2026 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388895;
	bh=KIcJWp2l8aBpcwfXDmcPkwoC91TRFDdqgyWuaPmjioU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hLx7tVPRCZ3qyOX7P1luZNza8zPx8XW6MTWVFS2oXPQ+lThEOwpFxmCm64KnhYtNu
	 gyRJQXWHU/wL7kSu1y3c2SMJo1yTRrYVw7tEzw/FmBBMYZEt+yWL+KHx3qmVJjK5D/
	 C4dCLtXFGbS2rYjYhdjDiLWtn0VpZVVMTT258wCd6fggo1Dz4GxW7X0CL2XqylOInx
	 68BF6bsoSUcKrvuUQB70EcNV1L5P+TlHZA0Tbvd7TdUlVKrIlUMN44Nxdw/Ad4aCcR
	 d4l/VeEvj+SFJYqLHoaWLiDJ07kla7Sfm7KZnIbZ2vbU/M22Ongfw26QgTwAPNiTVX
	 zdYKW7z0gSasQ==
Message-ID: <6e78fa81-3bc1-4821-b41c-5c18d9fe8a53@kernel.org>
Date: Mon, 14 Sep 2026 20:28:12 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
To: David Woodhouse <dwmw2@infradead.org>, dsterba@suse.cz,
 linux-btrfs@vger.kernel.org
Cc: thiago.macieira@intel.com, dave.hansen@intel.com
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
 <91E0EA5B-BFD2-4B8A-8408-4F561D5E0777@infradead.org>
 <c04f73b1-cf55-40ef-bb47-d518603bcd8c@kernel.org>
 <f130860f8e12c46688a7fcc158f3f34fa042e47e.camel@infradead.org>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <f130860f8e12c46688a7fcc158f3f34fa042e47e.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



> The documentation is fairly poor, but historical
> behaviour and expectation is that the FSID is supposed to be *stable*.

It's definitely messy.

Statfs f_fsid was never strictly guaranteed to be persistent across
reboots when derived from dev_t, filesystems like XFS and F2FS share the
same design.

Historically, the documentation around f_fsid has been ambiguous,
leading to different expectations across filesystems.

Breaking tools that rely on a stable {fsid, ino} is a real problem.

The idea with this patch is to restore the original behavior as the
default, and an option to mix in dev_t when needed to avoid collisions.
