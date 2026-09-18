Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800D238330E
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 08:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721954; cv=none; b=K/D+ZVjrOcAkCfC4IL3H6FUjOdVG26gxlBSF2TB1zBSqF7VF5QNZLzFNVUnfXHhTdEZP3Q92gBYhWv2Ihllv3D3bZtJS44dKY/0PBB8dHP4uqLY0C3UOtDjVo4h3phSgW52MgVSOGUv6QZkiU0+CbhfVMyelNYuwYotRLeNG2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721954; c=relaxed/simple;
	bh=Xwb9EcmPvXIIW+1t5sEUfKA+ZcNG7Mhv1JmQA+gtOik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DB8Z81y+eJEg4cuQMLhZfGPvoW6m8kw7Hyb9/DHcd8M3o58bI+cyupfGg9Wmb1ihm/LG1XFD4NG2TNyZ/kYaFw0zlOtXNon1XQ1UwQwYNH26VqzzQPy8XMF1SWQxWnxkT7vtrriYftnfn4cXKzDP/BK9U4Y3u4JHyo4gAQVsGN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8sTM0oF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8sTM0oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1104E1F000FF;
	Fri, 18 Sep 2026 08:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721952;
	bh=Obgf80DSeMmfO6Kr/qByW7WdZ4ZdN27x9znWsLAlR1o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z8sTM0oFcuP4MadR0sKNhuJYSTg8kTfn6Png8c73YLzQFBqtCOB43y3Rm4kKnkrJY
	 WvMY6iQUh9zuT2vEHLobsC7eqsIOoCcqMCbuX8Ee6kuXppHdzRSislLtjRrynEoNe6
	 OdibdjGQgOPtkse0AIfHxDv4RlAwFNFNSLI2NElBChtZPRU77Mf6RH2phu9/A4bFgc
	 +n7k7G3x4SkJ89Zxrvdc0zh0lfpVAKiHwBgq3t25tA/gIVAMGquT8WA5HnYyxLsZE0
	 oiAMHbNBvUj+a7jK0M7HwFkz1YUnexyTywouhAV2INYD9kIL/+LGtkpD+NfwQGfDkz
	 R3Va7+L/hT5nA==
Message-ID: <b18b4324-6bd6-4231-bcb6-1f1f136222e0@kernel.org>
Date: Fri, 18 Sep 2026 16:59:09 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, dwmw2@infradead.org,
 thiago.macieira@intel.com, dave.hansen@intel.com
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
 <20260914164617.GN54722@twin.jikos.cz>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260914164617.GN54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/9/26 00:46, David Sterba wrote:
> On Mon, Sep 14, 2026 at 11:42:51AM +0800, Anand Suveer Jain wrote:
>>
>>
>> This issue and its current fix (below) have been on my mind, as I wasn't
>> fully satisfied with the approach even though it works.
>>
>> Now, I think I have a better idea.
>>
>> The core issue isn't that the new f_fsid derivation is wrong (recap:
>> f_fsid derivation changed from f(UUID) to f(UUID + dev_t)). Rather, the
>> problem is that f_fsid changes unexpectedly after an upgrade.
>>
>> So we need to address the upgrade behavior, not how f_fsid itself is
>> derived.
>>
>> My new proposed solution:
>>
>>  . Put the new f_fsid derivation behind a compile-time config flag (an
>> incompat/opt-in flag).
> 
> A compile-time change should be only something really significant for
> the whole filesystem. Configs rarely change and except
> developers/embedded/custom builds it's hard to change, speaking about
> distros.

I'm responding to other emails collectively here:

In that case, I think it's better to revert the commit c2a74ed0494c
("btrfs: derive f_fsid from on-disk fsid and dev_t"). That gives us
consistent statfs f_fsid behavior in the new kernel and for
temp_fsid-mounted filesystems, f_fsid will be the random value generated
at mount time, and it becomes the responsibility of the use case to
change the UUID (and move away from relying on temp_fsid) if persistent
identification is required. btrfs(5) is updated [1] in the ML.

 [1]
https://lore.kernel.org/linux-btrfs/20260918084612.ZxGVtNO9DAJfevT0EwV5BlMy-4qgIyRKK6TAZ5oNLtU@z/
