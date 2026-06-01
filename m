Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8D33F590
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 23:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780356990; cv=none; b=L7PeysGAOadpKNIW51uRB0OK1HIi3s18jqDSRBEaXrHRfEpMMGb0zfOzIIBZRTdD+ppsWmFi+zBM5sZcDZGoVzM+baELsAEcMFePQRLsNpz238gpQkICjjhXeqd+YGQB7R7gXUqnNHubFra6laHyuzli6qNmg/S3gGnTWT0UY84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780356990; c=relaxed/simple;
	bh=ubxfeLPdcu1tVOhHcYgp2xMfaoJ97BNsAlzIcGHV6/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNK3ptUEVzZv8jh3zJBKZ3ZU6qmWwwChmMQ4H13MLJfHdWdXWN9eJyLwLiu0fR50pUfw3hCn+tdmnCppaB24TS+WNtinUuGwar++6sVknjXwoUXZlNaRqOfnaMc6ON5fO1Zjz2sSKONrQk4Had1SQLEvcnlB+YBQdLt0iuJizxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddwHSC9V; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddwHSC9V"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-516da301e64so157817841cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 16:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780356989; x=1780961789; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Auwu0u4sLco5ByZK6OrYXLLV/GCMBjlydMcsMEYP59Q=;
        b=ddwHSC9V9/TqoKM1sk0TKX+APtKM3XPoAaVruNWBXQXs5Ps+BhIKIFnJvBKhgqw81V
         6OnNpKSjlKWIAppTM9ST1L9H0hBaGBcxkM6BXePPCitpsQRzm6ewwDtmUqw96wiLFD/0
         sp1gDOMM64HA/yLiPth/HZiJEaparID8bEOwTFM5IuKAP48J4+Voh7O9IWEai+EIepfq
         pKcPaAhJUa5NaPAN6/ZcfJB4ajKEJV1FZ6ReZmaZYESI6Yi+3sX1uWQXE9lri/Tc8h55
         NR5LwTHlptvOwspP6PIw5CrtkUmLqBT7pvMVHSMwpQkNIKIDm4QsI+42iUSiIoBLd74F
         7N8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780356989; x=1780961789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Auwu0u4sLco5ByZK6OrYXLLV/GCMBjlydMcsMEYP59Q=;
        b=ZziXb+7Ipo0eSYhvJq00qz6TVjNNOc28vZ6gWQ3h+co1gHs9OXcPADd13L+26G3KJi
         0N9Kt7XNcCX9Q54uG15VZaJJaCr1UlKgxYV7GZ96QiMhQuOH/bbMXzGGmNn4h9imYgXJ
         xrp1T0ohIL0RbZS2QKxH/HrUlfhzClc6/odbjdGCOPYb4+4sFIW8jSxQkNNyXvDAsXJ6
         XoQYfsGXahOJMHIkBb+d5d2jYKNjO3A2bdGrqk/zXmT5KwV9v7xV4jNzRia0H2Oqkpkf
         K59bm1UinxwXXRkL/SKigCja/SZ1TZ7VDPqrW5Fy96Ims8UW69lg2KjbJ7Dh3jEQEYGz
         Gx9Q==
X-Forwarded-Encrypted: i=1; AFNElJ+VDxWFPbGKvunwnio/htopwA/N+WWJvmwxdcENhOX5uSjQG9dNeYYvlHUDEQqYdQOg4Ef4AD642ZD2tA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+kprZ04Ks7KY9SdLv/VKLxiGpU9YrkmXD5B+xLJ0Pt9zNfAlw
	FGyx/t4cWmsw3aD/Jq8gWesqZRC9hjw3XHnH/HE6bF/7+mHHQ5kk6k57
X-Gm-Gg: Acq92OHPLw4z09dn9KqZKojKATLfpLi6dAEBaVnu9caRBaCMb0FhfJkwEWTJnjDy61Q
	/dpLhrXdKFkh3s1weo0nGUwr7F6s7yKE5HJf0xracVhvK4fd2rTlMnZuahpq27XCWV+sqoNc6jY
	eZC3MYhIWy4Kq4C7OTGTZVsOrQRH5Mm2XiKwjnSoYA4+LKLEKvPwLj0QoRFOSn9eiB3d8ejJcMj
	bYZMiEVyy3VOv1t3E/P7IfLaieblmWRH2/JrUP/GEGQfGQe9YZJ9xNbZxbyR0gS8oWrnbLk6vmz
	t606TM1WA0ha0tScqc0fCCgfX63Vntp3OB6Hc2kap2EK1iwt2a0PkXgg4pHQr1G+3RugHq2AQ3y
	PtU/DhzOV7gpID+v7idisYwBNisox8laZ+c6xEBqlejDAGNGh/k+DeBH5/FkkbRE2ZbFa1vupZx
	S8OTeOCchIMtDJEbPP1wazWvs3qY6lNMt4J3Zje+u/tS1W1IWHNJhPoBwRsKjQgu6YQOIMl0ge2
	4kUwWx8CajWpfqe26PcyPYjTc9V7XdSHbs+iIfcZw==
X-Received: by 2002:a05:622a:299b:b0:517:58f6:29c3 with SMTP id d75a77b69052e-51758f642edmr75885911cf.32.1780356988761;
        Mon, 01 Jun 2026 16:36:28 -0700 (PDT)
Received: from fedora ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea042bb5sm105823496d6.8.2026.06.01.16.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 16:36:27 -0700 (PDT)
Date: Mon, 1 Jun 2026 18:36:19 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <ah4Xc7OmGle_C5M3@fedora>
References: <ah4EY2nhPxEETufZ@fedora>
 <20260601231731.1403-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601231731.1403-1-hdanton@sina.com>

On Tue, Jun 02, 2026 at 07:17:30AM +0800, Hillf Danton wrote:
> On Mon, 1 Jun 2026 17:14:59 -0500 Ming Lei wrote:
> > On Tue, Jun 02, 2026 at 05:51:26AM +0800, Hillf Danton wrote:
> > > On OnMon, 1 Jun 2026 10:29:25 -0500 Ming Lei wrote:
> > > > syzbot log shows the null-ptr-deref  is on WRITE, instead of DISCARD.
> > > >
> > > > https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28
> > > >
> > > > Adding WARN_ON(!lo->lo_backing_file) in loop_queue_rq() might capture
> > > > this bio submission context if this req isn't issued via wq.
> > > >
> > > I suspect this makes $.02 sense given the check of Lo_bound upon queuing rq.
> > 
> > Can't lo->lo_state be updated after the check? It is totally lockless...
> >
> Sounds good hm... do you mean it is UNWISE to not flush the loop workqueue
> when closing disk?

Quite the opposite, it is wise to not flush wq in __loop_clr_fd(), please
see my previous comment.


Thanks,
Ming
