Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667781514F8
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 12:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775909413; cv=none; b=AW+4FQlosFwJ5tek/8pH7w2oPoaFQiX09GhQ2qRtWqFpPUvwHWGvONYKh7+US5cafBKkkdQCr0YCIuLPNl7iFGP04OH7hftC/AfBkINZU7VHvcdlLemvUb5IhaI69E8RIVY3xgJbfSEemlDyT6th2dnvUwCT6+WhNa9FDK76Ghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775909413; c=relaxed/simple;
	bh=M+4Bw6nHH8mFNrJrEGKPfrQCyXGWmc/RjHxFsxhHhWY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HaSJowDAjq67X7UgK3EkPs+VLqKrSuRjXj12+BGyF8BCxR7LQjsNtPe63/FoZiKx+sTzT7JwaNJOsF20FT6zqHUP1+lHWl6jslcqJojU+RD0nvMVYAWIEHdLYgj6g9OO042xR8RGjhp7K1FSGaHjLzNnF4cY+K8tJVEfvn8Cp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 282FB40589;
	Sat, 11 Apr 2026 12:04:54 +0000 (UTC)
Date: Sat, 11 Apr 2026 17:04:53 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo
 <quwenruo.btrfs@gmx.com>
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <20260411170453.7bfe9b1e@nvm>
In-Reply-To: <adnBhWfJQ1n3hZC8@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Apr 2026 20:35:33 -0700
Marc MERLIN <marc@merlins.org> wrote:

> I had btfrs filesystem on top of raid5 with 5 spinning drives.
> I mistakenly enabled discard by mistake which caused a crash when the discard thread tried
> to run (no discard on those drives)
> Kernel 6.12
> 
> I worked on recovery using gemini 3.0 pro, mounting read only is fine, but I need read write
> or will waste days (probably weeks) recreating this entire 20TB+ backup over the internet
> 
> I'm not qualified to say if everything Gemini said was correct, but I think summary is:
> 1) discard can apparently kill a filesystem when it's hard drives below (it did for me)

Although some SMR HDDs might support TRIM, if you are certain none of yours
do, then issuing the TRIM command does not alter on-disk data in any way, and
after a device returns ENOTSUPP once, the block layer usually knows to stop
trying, it will return "not supported" to the upper layer right away, not
contacting the drive about that anymore.

As such it is unlikely that discard itself caused the issue in your case.
There is also no discard in the presented traces, and it is unfortunate you
didn't capture the initial "crash". So it might be just a coincidence, or it
might be not. And like Mr. Qu, I am also skeptical of the AI fantasies in this
case.

Be aware of the write hole issue when running Btrfs on top of a multi-device
mdraid. In case of a system crash, some devices might have stripes written and
synced to disk, and others not. This is can easily lead Btrfs into the
infamous "parent transid verify failed" state, from which there's no good way
out.

-- 
With respect,
Roman
