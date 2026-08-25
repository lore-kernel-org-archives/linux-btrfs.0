Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2BE44E055;
	Tue, 25 Aug 2026 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787670873; cv=none; b=dPqbeCy3LQKKbedg4JDd77uRx6gPHIYslcZpQWzx2ZcLzNfsESXd1weksq54B0xlc6KGXEYQ617UC/RitPuntxyS7dH5B0+0NXEiDBS81QOOSFdWVA/A3tKACJ/d0Jng8b7sWXaP/aHnZQjSkhEO2bO+GxWYC8JpL3c4Mf/YHoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787670873; c=relaxed/simple;
	bh=3RZDchxNIKlMF+YZZY5dokjhg564AFEZHqUtAa9+kZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CDDVNhKl6nx4dckeW0I8Z55sBgVsnKM+TCSFZnIapOYvhOShSwlEil9ENL034RIfUb4XP5V2dQGnByspbMCffje6ojV5vd3FvVFq4vJvqq/YPol1nY/nFNGLEVQYth0FEQ31zfVjGYCLSpY4E2ff43hJesFVvEHV4REjWk/WA/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67PFDXrN052354;
	Wed, 26 Aug 2026 00:13:33 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67PFDX2t052350
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 26 Aug 2026 00:13:33 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c41e9198-86a8-4bcd-a608-6f457b24f345@I-love.SAKURA.ne.jp>
Date: Wed, 26 Aug 2026 00:13:31 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Bart Van Assche <bvanassche@acm.org>,
        Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
        oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>,
        linux-btrfs@vger.kernel.org
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
 <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
 <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
 <27bcb147-bead-4432-8cd0-981489f36228@acm.org>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <27bcb147-bead-4432-8cd0-981489f36228@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav412.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/08/25 7:53, Bart Van Assche wrote:
> On 8/24/26 3:06 PM, Tetsuo Handa wrote:
>> but sashiko found problems with Bart's series ( https://sashiko.dev/
>> #/patchset/8330ca0e-b4d9-451a-bc0d-a50178194ea8@I-love.SAKURA.ne.jp
>> and https://sashiko.dev/#/patchset/2efb1032-34b9-4c31-
>> b6fc-4aa9b1d60895@I-love.SAKURA.ne.jp ).
> 
> Thanks, I had not yet seen this feedback from Sashiko. My conclusion is
> that two of the three Sashiko findings are wrong. I will fix the third
> one - the finding about the potential wait-die deadlock.
> 

As of commit fe4c990e6a30 ("loop: Add __guarded_by() annotations") in block-loop branch,

  modprobe loop
  losetup /dev/loop0 testfile.img; losetup /dev/loop1 /dev/loop0; losetup -D
  sleep 1
  losetup /dev/loop1 testfile.img; losetup /dev/loop0 /dev/loop1; losetup -D

causes lockdep warning. This is a false positive, but we need to avoid it anyway.

>> I still cannot catch why Bart's approach can become safe without
>> synchronize_rcu() and drain_workqueue().
> 
> Agreed that drain_workqueue() or flush_workqueue() is necessary. I do
> not agree that an explicit synchronize_rcu() call is required. Waiting
> until the request queue is frozen includes this call implicitly.
> See also __percpu_ref_switch_to_atomic().

OK. You recognized that we need drain_workqueue() or flush_workqueue(), and

On 2026/08/25 8:24, Bart Van Assche wrote:
> On 8/24/26 3:53 PM, Bart Van Assche wrote:
>> On 8/24/26 3:06 PM, Tetsuo Handa wrote:
>>> I still cannot catch why Bart's approach can become safe without
>>> synchronize_rcu() and drain_workqueue().
>>
>> Agreed that drain_workqueue() or flush_workqueue() is necessary. I do
>> not agree that an explicit synchronize_rcu() call is required. Waiting
>> until the request queue is frozen includes this call implicitly.
>> See also __percpu_ref_switch_to_atomic().
> 
> A correction: it is not safe to call drain_workqueue() nor to freeze the
> request queue in __loop_clr_fd(). I'm considering to modify the comment
> in that function as follows:

you also recognized that we can't call drain_workqueue() or flush_workqueue().

Therefore, I chose to temporarily drop lo->lo_disk->open_mutex in order to
make it possible to safely perform drain_workqueue().
