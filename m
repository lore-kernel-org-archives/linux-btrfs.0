Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220601494A8;
	Mon, 15 Jun 2026 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530915; cv=none; b=J3cDzUixAcPXj/de2ueMbcYdnTqkujvu2LEcNuqhGo2sFM07CIRHitr2ZQYuOeObq3I+pmj/bQyTQ4isRcNWqBl0eHiIAWGjClaC3WT5OqUhV0iK8NTOOQiymqhwJHiL+5gNwuydnHgBhaicGi4H6ed4F2+HFUgH0GIdIY+fdM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530915; c=relaxed/simple;
	bh=ZVEtlPIbNaMZuU3UkfHuPzXBHos9B1wGlGKzdnWW7Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzMRhTSLG01rq4h38yR+DwAcpZ2tzWjSM7Oh8shV1VDy3WgHwGbyBHcoHw+/e9NZnKJCFiRITg7BGuGsNS6Rels6a2QzYd0FMpRIkAtIZY7oxWLbZv2WTwINOzNqDXhXMHi1phXBL1wK+H94NdhE4MpF9XqK2H5VYns9yHkWFz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZR2DM75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZR2DM75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB711F000E9;
	Mon, 15 Jun 2026 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781530913;
	bh=ZVEtlPIbNaMZuU3UkfHuPzXBHos9B1wGlGKzdnWW7Fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gZR2DM75YykPorj3Ep23dOyN4iRez39Y1ZQmCTK5D2mAWlX4Z40+tjEOyAgm0YTbb
	 zb6EHasEUSUIU03oDs46R/emo/Ngplwq2KLf/1da7e9Q9JqPzKPz8OzxgsLMW5hw0F
	 Z8u9w5XhdHVaMYSVwzrIBtmbtXtk7gukk9gnzkVaY3g6wvLaPvxENc3E8TYFCw9b9T
	 0YurMfJfR3iUhTWPRnuW1NDhlQwAY6XUb+A6F7ArOYuzPCHxfiscShZ0XhRTu6ItJQ
	 eY2oMXvaXIreFdEG7NriRZ2ItObqx4Mil1FC75axACdQSDbVt3YhVHJwplJPc06kiV
	 8wn9toafl/BUA==
Date: Mon, 15 Jun 2026 15:41:49 +0200
From: Christian Brauner <brauner@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 0/6] block,btrfs: fix frozen-superblock strand on
 device add/remove/replace
Message-ID: <20260615-hermelin-weltfremd-anrichten-cee9417f4f7f@brauner>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>

> FIFREEZE on the bare device - resolves that holder to freeze the filesystem,

That's nonsense ofc. FIFREEZE only freezes the superblock.
