Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7C4A8A0E;
	Fri, 11 Sep 2026 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789149960; cv=none; b=Jyvy3ly/J8YImXWYZGlbTaP8cwoDeJ3xaxyOacotbLRt2ZWk9OjF2cSzcxBVmypmITS2S1uBc7zeVMUmTVCDBDJfvNYo4A2qH9k8H+jEhl7M/0ym/9cLi5gJhzzbbVEJjldlJCw6yg6Sx8Sv2Xwr2VtOKTEhwy1aoU14XleMdUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789149960; c=relaxed/simple;
	bh=Qs6O7PXqBznC4i3Vlx6BYRYgKKWUS+pIw6YYz4wAYXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivZKC7wBOSoJnHTwu3zZCnS+vjZGO5YOcDTSm1Hsr0ZdvIcGrA5BbeySAI8fnHrfPsoCqC5urSiuM4IOMNAZOaquVp5csvFsDmJL+6EHxN4SDsgAavf/ycdr1uO3M8xyOKJzR4wdOgop1Nz+o59z6ypoeAT3FkoTod32fClQgks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIK8f+NB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIK8f+NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE611F000FF;
	Fri, 11 Sep 2026 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789149958;
	bh=BY+zKUQwS0ort6EcfWhMLF0gHo9lYJJVsWolWTGeqZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GIK8f+NBXVKRaMP/CcDNHAuCLF+E5UdyemW8v5j8UoOjax+hBGj7oo807vuwk/D/a
	 dKTHfRKqk3xJZilQnXey5Mz22UC6ePMro+5quhHUz4Y/GfxHyL2mBi9lGblvdiV0f3
	 SGPF6OjomnAhWo5nakbdQ48qjVwVy8rzFSqZlEHLz+IZb+uYwcN/u/cR+EhZMwEJCL
	 iNY++sn0/ypOM/f7g6dqToIY1NLA+MczNp1+NasqRlElWqTBWm4Ni9PUSWpTo2cjT5
	 LEzkys3B+hfFvhgGS12SV4WxpcVMnDt9rOmUrAbSrPhiAKWaZ1EmN3ryZUTPDamwJj
	 OOHmgXQlCLu1w==
Date: Fri, 11 Sep 2026 14:05:56 -0400
From: Sasha Levin <sashal@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Anand Jain <asj@kernel.org>, David Sterba <dsterba@suse.com>,
	clm@fb.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH AUTOSEL 6.18-6.12] btrfs: derive f_fsid from on-disk fsid
 and dev_t
Message-ID: <aqRDBKUf1jygT38P@laps>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-164-sashal@kernel.org>
 <d6b8e4f3-93e3-454d-acb4-7ba1f49044d8@intel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d6b8e4f3-93e3-454d-acb4-7ba1f49044d8@intel.com>

On Fri, Sep 11, 2026 at 06:39:19AM -0700, Dave Hansen wrote:
>On 8/31/26 06:23, Sasha Levin wrote:
>> To prevent f_fsid collisions between original and cloned filesystems,
>> this implementation hashes the dev_t for single-device btrfs filesystems
>> to ensure uniqueness. This is limited to single-device filesystems as
>> cloned mounts are currently only supported for that configuration. Note
>> that f_fsid will change if the device is replaced.
>>
>> Additionally, since the kernel cannot distinguish between the original
>> and the cloned filesystem, this new f_fsid derivation is applied to
>> both.
>
>This commit is causing some real pain to end users that use the FSID to
>encrypt VPN keys. Could we keep it out of the stable kernels for the
>moment, please?

Ack!

-- 
Thanks,
Sasha
