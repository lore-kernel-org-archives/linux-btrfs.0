Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF833CE48E
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774023489; cv=none; b=imZDjc4k3iLX103aUKp0VeHnEn2KPG/77y7XuYGyLxrTDMao7TQBEU4fvfYMHWAqgOW0POCjaRLPAXlL8hltSS7qa/Wi4c3q9IF+GRhTmMHvKtkv+C495lv+sulVezxhY3ZG226KVeSEJGRgWt+9AazKT0534KoM5rTwiyu8rnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774023489; c=relaxed/simple;
	bh=ZqkJvaDRNWLa7eHplLgZAK0ScmEe+vsJsDAgC0wN2mw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nym40kxpL+LyrTMmOyOJMLBFSoE+XwQjFvS34E5Isw2CKzk+uWgjfsdKCKo43x4BVZtLfP6OXn1tQ3RxKBQ+e71wo7K6ayHnyEH16J46Fsr12KRGUBtOGJ6QnGbZpjOMGprs6T5tUfXSagxaE9Gd4P8wRaKb1b1DTIP88WrmTfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bky4cnOE; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bky4cnOE"
Message-ID: <a74f3ed6-0f31-40ed-aeea-436aa20cb359@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774023485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CFE3YnLVP0YJ25aPFAEPwwW4twH0GxikrO61jIo7frI=;
	b=Bky4cnOE6lzvhRhx95GG3CA4gXhCgr9xxd5qW2Z8WDAUo0hek0gEdUzvg0/JtgkMCaEWJ0
	bnrox7v1lGUJ8c39GNV3nuT36vGv5iyt32Yb5W2b3kVljjd/OM1tQ8eMAwC2LiEgzOMfiQ
	Y5rHGUcfm6be86fXIPR4U7E8xDNmHRg=
Date: Fri, 20 Mar 2026 09:17:55 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] btrfs: prevent direct reclaim during compressed
 readahead
To: Christoph Hellwig <hch@infradead.org>
Cc: boris@bur.io, mark@harmstone.com, clm@fb.com, wqu@suse.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-team@meta.com
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
 <20260320073445.80218-3-jp.kobryn@linux.dev> <abz49WgkJ-KpmBcN@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <abz49WgkJ-KpmBcN@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 3/20/26 12:36 AM, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 12:34:45AM -0700, JP Kobryn (Meta) wrote:
>> Prevent direct reclaim during compressed readahead.
> 
> This completely fails to explain why you want that.

I see that now.

Qu also had a good point about including info on why the current flags
are an issue. Some of the cover letter text would help here. I'll bring
some of that over and expand on it so we have the relevant details here.
