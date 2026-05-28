Received: from smtp153-171.sina.com.cn (smtp153-171.sina.com.cn [61.135.153.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C582D9787
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 23:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780009308; cv=none; b=H66SeEdzwTuH2SqHcg0tUVp377xqxelLuInqK2224cWQ8Nyx+bwx5dzhxIT7rytRMtV5PlI6hX4oVJ7GNbT8VieRPQOHK0IX9EMloCyp6e9npmgZTzSNbmRPZYgf+Qxf0kATitY1Nh8KIyn8gObtxVlbhFqWSIQcgNJYkD++U5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780009308; c=relaxed/simple;
	bh=1T8/I6TvjiS18ZZDLJG7k3gfStyk9dmBa1e4cJe4Qtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oziePcXtoQDj/GgR+wJKUVX/3VLVnlUu+Njmd5ewUnjcMwhl9xokx9f+8RS50Gxn8v1NFYHAY4aHjFpr8KEZ7YmM1EUZ+QtfTgkkBLOB3LgAt0g6G3dhpABbbqIpxI4owxY6V5lJC5cp9WmXeBfBI4G5URaKTRXTK8TizT0JUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=j3bh2zBo; arc=none smtp.client-ip=61.135.153.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="j3bh2zBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1780009302;
	bh=ew4LKtHTQRw4JU9dPbT+Bkxy6WAebg2DDIpNh0S9wiE=;
	h=From:Subject:Date:Message-ID;
	b=j3bh2zBop3s2UXi2eDER1j43CzZ/29e4XHtwAYmjwhjKvZeEqIzphlqymomc01ngi
	 4jCg+4P9hs922NMUn9M9R1voKlxQhs9xM7gjHV1NH7cUiIQa9IQYVEeSimv4lgKWrs
	 A1bpd2LRG7Xu5pmTTQpQca0h5g+JtbXzAhTqfUxM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.34) with ESMTP
	id 6A18C92B0000506E; Thu, 29 May 2026 07:01:01 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 5580266291955
X-SMAIL-UIID: 978DE95D27164842A9C09416F2C93710-20260529-070101-1
From: Hillf Danton <hdanton@sina.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Fri, 29 May 2026 07:00:47 +0800
Message-ID: <20260528230050.1185-1-hdanton@sina.com>
In-Reply-To: <20260528054334.1159-1-hdanton@sina.com>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 28 May 2026 13:43:31 +0800 Hillf Danton wrote:
>On Tue, 26 May 2026 22:00:49 -0500 Ming Lei wrote:
>>On Wed, May 27, 2026 at 10:35:56AM +0900, Tetsuo Handa wrote:
>>> On 2026/05/27 10:20, Ming Lei wrote:
>>> >> Of course we should try to figure out the root cause first, but how can we do?
>>> > 
>>> > Definitely unexpected write IO(after umount & loop closed) from btrfs is more serious,
>>> > which may cause data loss, so CC btrfs list and maintainer.
>>> 
>>> Why do you assume that the culprit is btrfs?
>>> 
>>> https://syzkaller.appspot.com/bug?extid=bc273027d5643e48e5b3 indicated that
>>> this similar race is also happening with jfs.
>>
>> I just didn't see the above report on jfs.
>> 
>> It doesn't change anything, the same question still stands: unexpected write IO is issued
>> or crosses umount & last closing of loop disk.
>>
> Given the loop workqueue that triggered the jfs warning, can you specify
> the reason why the workqueue in question is NOT flushed while closing disk?
>
Got it, the loop workqueue is NOT flushed to avoid deadlock, see d292dc80686a
("loop: don't destroy lo->workqueue in __loop_clr_fd") for detail.
And the deadlock can be reproduced by flushing the loop workqueue with
disk->open_mutex held [1].

[1] Subject: Re: [syzbot] possible deadlock in blkdev_put (3)
https://lore.kernel.org/lkml/000000000000ea753505da2658d5@google.com/
