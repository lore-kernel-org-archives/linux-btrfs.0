Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0E238B140;
	Mon, 24 Aug 2026 22:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787609302; cv=none; b=FN9xNy69mFP2LOaiXJqPhCRsKdKTvEPW0wOw7Bpi0SYkSt8UtrqMZCegJ9u12zThGlPooQdLvLBmAoOzAJ5MwjcDZQFcDcvROWDCq2VPWrEKn47Nt4D00nDEX8/2qQg0OTmlz1+zy+mrW4MHrbReHps6bUpiEUY4Oszikc81Xlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787609302; c=relaxed/simple;
	bh=0y7MOLS3KRJrVhig+cuqm2xT/M13wl0wkQvEnOAoSww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fUeXQpe8l8nImhqMdkCyBD2fHCgxlroQhlZbO+5J/KHZ8ZcdnaUf4GC5d0KG6J5AWhwoE4cznG7nXnTlx5ZNgyjqFCItIJBu4FQ84ALaKkYUSQtBX+vnCj6jS0zEpoUE4zzO4epMAryDjPZHNO0W2U842S6GtQSK1A9DQ5AwKeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67OM6tEq059496;
	Tue, 25 Aug 2026 07:06:55 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67OM6tDC059492
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 25 Aug 2026 07:06:55 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
Date: Tue, 25 Aug 2026 07:06:53 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
        oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Anti-Virus-Server: fsav315.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/08/24 0:57, Markus Elfring wrote:
> …
>> Therefore, this patch introduces a grace period for …
> 
> See also once more:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v7.2#n94

OK. I can do "s/this patch introduces/introduce/".

sashiko did not find problems with my patch
( https://sashiko.dev/#/patchset/8dedfc40-9cae-44ff-9960-e0eb1825e963%40I-love.SAKURA.ne.jp ).

Bart did not like my proposed solution and is making a series, but 
sashiko found problems with Bart's series
( https://sashiko.dev/#/patchset/8330ca0e-b4d9-451a-bc0d-a50178194ea8@I-love.SAKURA.ne.jp and
https://sashiko.dev/#/patchset/2efb1032-34b9-4c31-b6fc-4aa9b1d60895@I-love.SAKURA.ne.jp ).
I still cannot catch why Bart's approach can become safe without synchronize_rcu() and
drain_workqueue().
