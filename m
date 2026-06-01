Received: from r3-17.sinamail.sina.com.cn (r3-17.sinamail.sina.com.cn [202.108.3.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E727F19F
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 23:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355879; cv=none; b=bAyqDoAaWiMdi8j1hKxSBeBvBTlrC8SLdRow09vWpd4s3XkZoYTnovpgs4mDrlFm/prOGcQRP3mCG/xx5efDdUQKbx+/mxHlOFbsiuAyC66l2lFM3y+sZoYiY1kMp0lrWtIPyYEqO5zw5BiEznbBI9obExi7UvBLTE7yHdX8BAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355879; c=relaxed/simple;
	bh=Po0H4PhXpZB4CC0ZmuVH8OSxr/lv1Ed3Id5JhFMl2mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMTZNQN9FfRTKihj+o9lJwqCzWWBxk16cbnXARol8ygKoUTdKcEq8cg4TwnysHGmqT1jL9PF3Tc/5XO3p0K9or8Bwu6T9h+oIRBpxckRMRbjK5aGGZ33I055jrOEAcF+eOFYdyQyfInggdi1vVbdq/iZXeptB+Ry8WMQ1XldTZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=ObOVlkzb; arc=none smtp.client-ip=202.108.3.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="ObOVlkzb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1780355877;
	bh=3OCVMiVaoAQ78KSjGPxA9tbJTpAysnsv+Uuid0f3YZE=;
	h=From:Subject:Date:Message-ID;
	b=ObOVlkzb5fa7C7FVj86QQJVbF37CxvnEdFcQfKOFQOCAHxFWqyKS9sYRLDflvI3hp
	 kV54kotPcuHYxfGGhFMaKLabRKpCXXeQuQvZQe8gvwXw100q1Hz7djKRTnGRw5YW7L
	 3hoJuBCCjIXXsKqA7z1+M9/S9E09JpQRocajocJM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.34) with ESMTP
	id 6A1E131500002077; Mon, 2 Jun 2026 07:17:45 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 3043906291827
X-SMAIL-UIID: 704A31F544FA422892316E3CA446A8CC-20260602-071745-1
From: Hillf Danton <hdanton@sina.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Tue,  2 Jun 2026 07:17:30 +0800
Message-ID: <20260601231731.1403-1-hdanton@sina.com>
In-Reply-To: <ah4EY2nhPxEETufZ@fedora>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 1 Jun 2026 17:14:59 -0500 Ming Lei wrote:
> On Tue, Jun 02, 2026 at 05:51:26AM +0800, Hillf Danton wrote:
> > On OnMon, 1 Jun 2026 10:29:25 -0500 Ming Lei wrote:
> > > syzbot log shows the null-ptr-deref  is on WRITE, instead of DISCARD.
> > >
> > > https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28
> > >
> > > Adding WARN_ON(!lo->lo_backing_file) in loop_queue_rq() might capture
> > > this bio submission context if this req isn't issued via wq.
> > >
> > I suspect this makes $.02 sense given the check of Lo_bound upon queuing rq.
> 
> Can't lo->lo_state be updated after the check? It is totally lockless...
>
Sounds good hm... do you mean it is UNWISE to not flush the loop workqueue
when closing disk?
