Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCB222FE11
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 07:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772176629; cv=none; b=dF2zUA1TKu1D/PMBEYfl+H0soURYec2eJWfCOSfbOAnRVgwlUNgqEdfSrqYTj/puiyG7lH6B6XmeFUARW/rC1fBfD+8cZyGRtyZiQmH1ULsTL+f3VqPkJ+kO4a6UP9azV1KIz6ZHObu/bqGv0+cTEy+lTs+Sj6GyprVKscbrDVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772176629; c=relaxed/simple;
	bh=vU2dhpg64sB2B1Y5E7BVrJiaUN464m8AB7ekhDv/73E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=c3Ta8/2+jXyXnrOznl30oZy/wjm7ibW6UXgt5f5mHFSDht0wcLSRhpJVk5pE6Fy7qZ0e3fZhVyU7mcsMaQ+b0S/K6gss9PkcqYjkoz6U3dFrJ8HD/h2NaFRAncT0GFWr2+H9bmvWUWU+e/XpDUCwdjkTwjE+ONMjMj6fu2/uyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=e4UMGggo; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=e4UMGggo; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="e4UMGggo";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="e4UMGggo"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Sr7b6qe6J8riWNogESp7eMaTnLZAgDmkNcEzZi8C2S4=;
	b=e4UMGggoP+o53Wdvx0n3casHz7iaMkLQhHLCPHEcgEOM+v6/dsF43Qg1D6jeGHcU6URKQWNJw
	rqqgDtJWdeOLQGnuJCnRvf9GwFuWTzwPxGw6rfEFZu7VZ6uWByJF4NY5G/nahrLqk6j0WSECxOV
	uaajqFd1QNmOcmXKpPe4CQ8=
Received: from canpmsgout01.his.huawei.com (unknown [172.19.92.178])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4fMflF55fYz1BFmb
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 15:16:41 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Sr7b6qe6J8riWNogESp7eMaTnLZAgDmkNcEzZi8C2S4=;
	b=e4UMGggoP+o53Wdvx0n3casHz7iaMkLQhHLCPHEcgEOM+v6/dsF43Qg1D6jeGHcU6URKQWNJw
	rqqgDtJWdeOLQGnuJCnRvf9GwFuWTzwPxGw6rfEFZu7VZ6uWByJF4NY5G/nahrLqk6j0WSECxOV
	uaajqFd1QNmOcmXKpPe4CQ8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fMfdq0DCpz1T4Fq;
	Fri, 27 Feb 2026 15:11:59 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 8556F2021A;
	Fri, 27 Feb 2026 15:16:53 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemr500015.china.huawei.com (7.202.195.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 15:16:53 +0800
Message-ID: <262f6108-35a8-4db0-b1be-c91d14651811@huawei.com>
Date: Fri, 27 Feb 2026 15:16:52 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6] btrfs: free path if inline extents in
 range_is_hole_in_parent()
To: Qu Wenruo <wqu@suse.com>
CC: <sashal@kernel.org>, <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>,
	<dsterba@suse.com>, <josef@toxicpanda.com>, <clm@fb.com>
References: <20260227064414.2314529-1-lihongbo22@huawei.com>
 <2a3587d3-f131-4e19-b7fd-3c14e8d097f6@suse.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <2a3587d3-f131-4e19-b7fd-3c14e8d097f6@suse.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Hi Wenruo,

On 2026/2/27 14:48, Qu Wenruo wrote:
> 
> 
> 在 2026/2/27 17:14, Hongbo Li 写道:
>> Commit f2dc6ab3a14c ("btrfs: send: check for inline extents in
>> range_is_hole_in_parent()") is a patch backported directly from
>> mainline to 6.6, it does not free the path in the inline extents case.
>>
>> Commit 4ca6f24a52c4 ("btrfs: more trivial BTRFS_PATH_AUTO_FREE
>> conversions") in 6.18-rc1 fixes this by accident
> 
> It's not "by accident", it's the designed behavior, remember the fix is 
> after that commit introducing scope-based auto-cleanup.
> 
> It's missing the dependency, which can not be directly backported, and 
> considering the scope-based auto-cleanup makes is much harder to detect 
> just by the patch context, it's indeed a problem.

Thanks for quickly reviewing.

Yeah, you are right, the commit 08b096c1372c ("btrfs: send: check for 
inline extents in range_is_hole_in_parent()") is later. So I think I 
should update my commit message.

In addition, the 6.12 LTS may have the same problem which introduced by 
db00636643e66898d79f2530ac9c56ebd5eca369.

Thanks,
Hongbo

> 
>> by converting to
>> BTRFS_PATH_AUTO_FREE, but we cannot backport this to 6.6 due to many
>> dependencies. Instead, we choose to use a goto statement to avoid the
>> memory leak in inline extents case.
>>
>> Fixes: f2dc6ab3a14c ("btrfs: send: check for inline extents in 
>> range_is_hole_in_parent()")
> 
> With the commit message fixed it looks good to me.
> 
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/btrfs/send.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 6768e2231d61..b107a33dfd4d 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -6545,8 +6545,10 @@ static int range_is_hole_in_parent(struct 
>> send_ctx *sctx,
>>           extent_end = btrfs_file_extent_end(path);
>>           if (extent_end <= start)
>>               goto next;
>> -        if (btrfs_file_extent_type(leaf, fi) == 
>> BTRFS_FILE_EXTENT_INLINE)
>> -            return 0;
>> +        if (btrfs_file_extent_type(leaf, fi) == 
>> BTRFS_FILE_EXTENT_INLINE) {
>> +            ret = 0;
>> +            goto out;
>> +        }
>>           if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
>>               search_start = extent_end;
>>               goto next;
> 
> 
