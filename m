Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91084EBAEB;
	Fri,  4 Sep 2026 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534858; cv=none; b=H5+lqp9eClNuveRZ4+B4RnCgcsZa2bXCVNuVkbvc8iovigJ30/NVIBtdjVOvg1ccb2F2hDqCWm3RX+dRG+CHlViLTuZAng8KgS1yJfPgiklLrhUrnpUszgFacRae8eKxX/kwiLmbQdyYgabP7kX1HCSfsfVaiI87I8uhc+lJg4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534858; c=relaxed/simple;
	bh=A93PyV8Ku4pRVQCF21zpJL0Wct1LHUTtdd2RKHStkhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlnljrbMhaCnL2MKbdyBc7mo1GznwWEwuDhkWfoJpePJYOgh+tA5WDJs4Mp79Va3U3jKI5fbaYAys/GayLNJUNTlch0nT5DOdBGCBL5Q5qI1C6bcvMnzXvETEBvGDBf9Z2g+vFDldH/XLorLvcayNVhRuMgJ7+vGnbFLCNrVTcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=G3BX6yu3; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="G3BX6yu3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=We4qH7+B5B5S9aGBqZjtepABNgouZfkXtz4+EaeaWds=;
	b=G3BX6yu39sSD8Rv+Ji3//W1ngCocNacHXF6iZyko59Vjug1wKzNUtOhH9k1uQ0
	pkPtrtkgIGhqIhNz4d2+RzeEo5z4PvZVRbXA+L7g2Q5mswjPaIeyBvSLjweA8VKA
	YO3DQNdck4k0c/pDb4IF/xTBD+V0g9o6sq2K6QL/xQsbM=
Received: from localhost (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB3DPss4JpqOjmCOg--.59808S2;
	Fri, 04 Sep 2026 23:13:50 +0800 (CST)
Date: Fri, 4 Sep 2026 23:13:48 +0800
From: Melon Liu <melon1335@163.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, clm@fb.com, dsterba@suse.com, 
	fdmanana@suse.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix deadlocks with transaction commit when
 cloning inline extents
Message-ID: <dwbfev763nkhdhnrghozhutmloduv3mtyzeysrcyddhnpyynsu@mxofgp3xhzwf>
References: <a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx@eeof6sjb3xdc>
 <bbcc2791-442f-4bf5-aabf-40eb2edc0165@suse.com>
 <byfdpkxktwidszfv3yss7nxajjioxq7nhcmnxrzrwkvvzqaejh@ovl6qwbe6du6>
 <9a5f0b52-a363-4b7f-a207-677fa6938cac@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a5f0b52-a363-4b7f-a207-677fa6938cac@gmx.com>
X-CM-TRANSID:PSgvCgB3DPss4JpqOjmCOg--.59808S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWrKF45ZF4rAFyUuFW7Arb_yoW8AryDpF
	W7Ca1DJr4DJw1Uuw1v9w1DZFy09r1kJrW7XFn8Ww42vas0yr1kKFW2gryY93yFvr1kCFWU
	AFWjq3savw45AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U3wIgUUUUU=
X-CM-SenderInfo: ppho00irttkqqrwthudrp/xtbC4w6EpWqa4C5-PQAA3w

On Mon, Aug 31, 2026 at 08:05:16AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/30 20:12, Melon Liu 写道:
> > On Sat, Aug 29, 2026 at 06:25:11PM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/8/29 17:09, Melon Liu 写道:
> > > > Commits b48c980b6a7e ("btrfs: fix deadlock between reflink and transaction
> > > > commit when using flushoncommit") and 532085d00eb5 ("btrfs: fix deadlock
> > > > cloning inline extent when using flushoncommit") moved the destination
> > > > i_size update before btrfs_start_transaction() to prevent
> > > > extent_writepage() from invalidating a folio beyond EOF.  However, two
> > > > deadlock windows remain.
> > > > 
> > > > First, after the folio is dirtied but before i_size is updated,
> > > > extent_writepage() can still see the folio beyond EOF.  It calls
> > > > folio_invalidate(), and btrfs_invalidate_folio() waits for the destination
> > > > extent range lock held by the clone task.
> > > > 
> > > > Second, if extent_writepage() sees the folio within EOF, it proceeds to
> > > > writepage_delalloc(), which also waits for the destination extent range
> > > > lock.
> > > 
> > > What about letting the agent to create a reproducer, trigger it and paste
> > > the lockdep/hang calltrace?
> > > 
> > > Also an ASCII chart showing the window between involved threads?
> > > 
> [...]
> > > > Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Melon Liu <melon1335@163.com>
> > > 
> > > And AI disclosure.
> > > 
> > Thanks for the review. I'll address your comments and send a v2.
> 
> And also check the sashiko review:
> 
> https://sashiko.dev/#/patchset/a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx%40eeof6sjb3xdc

OK.

Thanks.

