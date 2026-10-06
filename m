Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6003A381B0A;
	Tue,  6 Oct 2026 09:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791280342; cv=none; b=iVSKAWIN7EmrhwJxHp6xgqBNQDvvMtKFCzPAmLShcLOrwKQUdMbPgB0rF6N73qKzc+bn3+Xh35MeEQNF/1cu21/Ol7KjjU9AnXcWzlpHjRM0j0LmVcUV6FBWCsAZSqYr6M/A1zPd6auI2NEnzgqUyXEPQWCuFp4XM7luUFgP6uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791280342; c=relaxed/simple;
	bh=0HBoVB16BDnNAi8bYUVaaV6qzerXSStBsyxZIDIFlpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afQxeyw6D3XeUfrlkO2Z6aTCsDOULL9WtMgNV2+7sOdIMD9y+uXuAnhMq1RLTBE9++HZO8wFo+yrGizkWx4ghU39g1wZ1l1Ruf8xzd3unt2gmANCuGQpS8oTeB4trUFTHteyDEziQL3VHTWVJT1TdqsHiFnsKvuUI5fp4ix+07o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnwWt0Zc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnwWt0Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E64C1F000FF;
	Tue,  6 Oct 2026 09:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791280341;
	bh=0HBoVB16BDnNAi8bYUVaaV6qzerXSStBsyxZIDIFlpk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WnwWt0ZcuFOHgoQKGUeI7UGOtdnZh1EK3jsSP92agtnuXLjigCM5v/M3VTXp1fjsO
	 zxKXwedq+JX5y+jjmh8+BSAMCdDTq2JHxUrZQ+w6kE2TDdwue8EVAsPHTO6ySTb+ON
	 1umoq99LyDYcCRxKD5aHjm2eGXaGc80ZTR5adR6YzwnFecP8RzVUWp3+J009K3lpWP
	 Klu2nTdMqWn4x4MWcYzNngMXoCcuB6iWjRsp9s3vFssU6Qndw+epoGKMMP8wddhTex
	 X1dpnVQCGUghwG5jP3M6BSTp3QqwgwghEgrgSdKzoUmZgFtTzxJiRsGyQJrPtaH6l2
	 ymlfSxj9elXdg==
Message-ID: <3822b1a6-28a7-4e51-af16-3880ee087ea5@kernel.org>
Date: Tue, 6 Oct 2026 17:52:18 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fstests: btrfs: add a new test case to verify degraded
 RMW writes
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
References: <20261002092135.61719-1-wqu@suse.com>
Content-Language: en-US
From: Anand Jain <asj@kernel.org>
In-Reply-To: <20261002092135.61719-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

LGTM


Reviewed-by: Anand Jain <asj@kernel.org>


