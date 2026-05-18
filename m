Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA9F330B10
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 11:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779104500; cv=none; b=SohzKwOAs0zzc5pEosBrvp1LrWcmB2pdAzLBi1dp2CJZ/NBFtgyvfIsfa69YVGTFe+p9uM7GJsYD5s8sdLyT3W4BIqwoUEt9o5HY5tRgCJN2sxDZYW2GwahlZk9Yc7EV7hGq6clisYo0i4MX8Uyrp9KDR9vnh6qxe9MuXHt5wW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779104500; c=relaxed/simple;
	bh=0h4TOTeZPosMojjox/6kvOp1fbefvJ8EHeiAGlRHhbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NbDItFcRKYYrv1tLvm1A7j8Xt4UqM/clFRTS9yvuISxkkCgJ4bSI1YzxnkqnnBiOIDpX5zpZiQFDcpS8FqPrHl623BQ+iEtphVStlR546rgprx2/wfdjkc3eaTXPyk3WdZh6WVxoDEz5AO99Y2nA2GNSsY9KDUNYIPVy4DEXqDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5iJaV2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5iJaV2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671FBC2BCB7;
	Mon, 18 May 2026 11:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104500;
	bh=0h4TOTeZPosMojjox/6kvOp1fbefvJ8EHeiAGlRHhbg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V5iJaV2dNiTvSTxfvUEc5W6rVN0A7zNkecy2dNKkOMrlQh4CWPgEMEGin1rXXT/A3
	 2aSLgPXLwCp2sVeZ/p4AzeWTYekz9JaDdtnSa6mwpkI+yFLs3Q5zGWZmZjBR5el/bC
	 ps2BXfVMeKQbYB62cWX0vqUKP6FF/RVDLDscHvHTuD3Yxe+9NmqoR2eZl/ptq5837E
	 +XV7FakWDJOIQp7pfkil3nQQ8cYQFx0tRexob19u1A29fruGn59KUncqbMbxc0oyXs
	 6RlskeEhvmK2idmonmS5kPKhAbxPO0KmTY7dI+Fxs/dz03FSIWDmEM45wB5pOlMKW0
	 DQ8Enk+ZUlUVA==
Message-ID: <a1bfb4a0-9050-428e-a96e-9d62188494f0@kernel.org>
Date: Mon, 18 May 2026 13:41:37 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: always set max_active_zones for zoned
 devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260518095503.132430-1-johannes.thumshirn@wdc.com>
 <bd7d1f30-a6f3-4497-b584-8b81db6599e1@kernel.org>
 <1b9193e5-47d4-412e-97d2-08a718f73111@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <1b9193e5-47d4-412e-97d2-08a718f73111@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/18 13:16, Johannes Thumshirn wrote:
> On 5/18/26 12:09 PM, Damien Le Moal wrote:
>> On 2026/05/18 11:55, Johannes Thumshirn wrote:
>>> When a block device does not report a maximum number of open or active
>>> zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to the
>>> internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONES
>>> zones.
>>>
>>> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
>>> internal max_active_zones limit will stay at 0.
>>>
>>> If a device doesn't report a number of max open or active zones and it has
>>> less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES, set the internal limit to the
>>> number of zones on the device divided by 4.
>> I would rephrase this like this:
>>
>> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
>> internal max_active_zones limit will stay at 0, even if the device has zone
>> resource limits. Furthermore, if the device has a total number of zones that is
>> less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones should be set to at
>> most the the number of zones.
>>
>> Fix both issues by changing max_active_zones to the total number of zones of the
>> device divided by 4 when the device does not report any zone resource limit,
>> i.e. when max_active_zones is zero.
>>
>>> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>> ---
>>>   fs/btrfs/zoned.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>>> index 0b80b498fb85..bdd6fac93c93 100644
>>> --- a/fs/btrfs/zoned.c
>>> +++ b/fs/btrfs/zoned.c
>>> @@ -426,8 +426,10 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>>>   
>>>   	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
>>>   					bdev_max_open_zones(bdev));
>>> -	if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_ACTIVE_ZONES)
>>> -		max_active_zones = BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
>>> +	if (!max_active_zones)
>>> +		max_active_zones = min(zone_info->nr_zones / 4,
>>> +				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
>> zone_info->nr_zones / 4 could endup being smaller than BTRFS_MIN_ACTIVE_ZONES.
> We do that here actually:
>> +
>>   	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
>>   		btrfs_err(fs_info,
>>   "zoned: %s: max active zones %u is too small, need at least %u active zones",

But with your change, max_active_zones cannot be 0 anymore, so this test should
be changed.

But my point was that we should never hit this condition since we always need a
device that has at least BTRFS_MIN_ACTIVE_ZONES zones. So this entire test +
error should be removed.


>>
> 


-- 
Damien Le Moal
Western Digital Research
