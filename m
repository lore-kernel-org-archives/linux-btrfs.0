Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790C43822A6
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 22:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780352113; cv=none; b=YOrmI55r4dkrVLVLkCN/32ib0EIuSoWjYl2rfIthzK8XrSVzmjRJnEM+lZgPwKboXA60Q0TaXnfKSSa0W8sESwOil8NNEGCmnBjD0G1W7rSM+kuMTIXz74hj3YDIuSmt3ZAAdAlkP0Fkro7GmF96gVTS0b+pZRvUtGZ4rhp4wU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780352113; c=relaxed/simple;
	bh=/gVb9fcgCocEtzC143LuvTCFiEqmzkG9HTHCEdEVpEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONTvBdZJu21Erc9YYcQGONK8NXuP7H72iheuFEpq3XOarcGhfY6FqPMY2G7nIjUB0JbiDdw5wfY7MD/kCyHp+Wo3Qqy4Mo3RMH5jxL4u20yI8gVYjufIlGTIgFTVuA8cq3c2sOOV5DFIfe64DuN2YmWsVNRjb0VeiVv7JCorQz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OVxcY53S; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVxcY53S"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-516d0db9372so95101481cf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 15:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780352111; x=1780956911; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1HquVhkpS8yFsVoW4Qr9xr3pJd62muz8BoFdSfaaUUY=;
        b=OVxcY53SgENpNhl+8RIar0HAixHk6XnR43Fmd5kl57tGF1+xfICJHKzalWeJBhciBZ
         lEVpS/QOwQE0hHCjDIlXS40J6W1j3pnvKUM5N5KOXxMBDpxHlrwlF1z9Zg+/0dgJkxx6
         7mhRKPh1+tRcfeQ/eTEDPfPvhjO29vE5sOCxnHgHc+v/FPERKnT+uAoOvYPcBQoAtVmW
         LhV7f+TqaNgKwJLLHQWpwmFrDMEt2733QKF0bf6kkD/6eMYklvKC3EnLQ7V2xxgXJVHB
         BUj/VjTALzz8ClM4zQHYMiYA7pbxRBZ53xrTUoEJPTUnX4uim8hovB/96s9qNDtsbNGv
         YO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780352111; x=1780956911;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1HquVhkpS8yFsVoW4Qr9xr3pJd62muz8BoFdSfaaUUY=;
        b=agxl/O5BUnHkIJRk9/ezng3d1Fd/Z8yvoOk3XC5PwX4ABmriKFJb9C33gn9N6sKlyV
         2CZ9cLFK+FR3gVklwMmcisceCG4W8LLmUfAAG2OF8X/TYeFv4USy/2KgAOS5DVw0w5Ps
         JzRz835UYrZ5iRd9diUWWJOLr7fNDs9QmgP7pT6pB2Ogyuties6UsLWS72LlhUQTJV8F
         uRI/dSzWN+NmqX1PGRLKQTsEYGb7Ng+Oh9ipQesu98YReDuePA83y7FugckOr+krxOm+
         G/0i3m5WvN0krcU/wIJec/Hn8sMEmX/psoMcy5m3m8jrzet11dGsWG0vAFp1bij4GOn5
         RsSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/X0/QWzC4CHZCZgVhMNKcDO26lECkK3xJl0mOPUxqTVf2L2mhnEd6KXlD9ZBqv4c57YV46MVG62Hz0Tw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGQv7VE+q2lyAlkjR68C9jB81pKQDfE45RQhVr/Aqk6rROfAbT
	2RuUEwQzEKs3kIhFfavV/Np7CAKIFu7eIb5pdoIrsbiASvse1VkcdD9s
X-Gm-Gg: Acq92OGt5IqgLYeA9mjpKwa85+RrLc4CVmVAgRK+sGXElR8yQo6Pikuy4akTDRTmUrO
	pHyhqalf3beXmyJNcL7Vz8esG+1IXZwHvLWZ2p7MLJUvuaW0c/oby4OzQ+gacE6LAta58PVLYwG
	uiy4iLN77tlrpGUxt6+qRhYxwGSDcLk5GXi3DuRx8VzF6NdniCPb5xQHhE2GRhswvNgogQWocHp
	FQi597XRK2HUesr66JfgmwxTBC2c5e4EJv7McshvJtUl/icRy5pXJhRO2o7qRraBkmuRqpDlj+T
	plk64L+W4g/Y2kAYqm2iK9XwauTbFoQKT3KCKHVJ8z6cu81PeBOc5JFhdOCJgkx0mzxA+G5CgAF
	r/IthmIj+M131okyOFBN0FZzp8/QQTvR4251iuR4DwvnEWls7JmvVbxtQFz1ufl6yg9JtfbfvDi
	0M5nz2lq3cgGbzlQCIGFaet9xtEKXq8seypFBXxMjr/o4zXcbiWX0wPWiQkmITdZ9+w/HkBf9nV
	IPaOsy8oVhSYn3TANJ8WSypW8sFxWtvHjseJKcp/A==
X-Received: by 2002:a05:622a:5a10:b0:50d:7c18:c66e with SMTP id d75a77b69052e-5173a6f3826mr199228551cf.13.1780352108144;
        Mon, 01 Jun 2026 15:15:08 -0700 (PDT)
Received: from fedora ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517417ecb11sm66209661cf.0.2026.06.01.15.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 15:15:07 -0700 (PDT)
Date: Mon, 1 Jun 2026 17:14:59 -0500
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
Message-ID: <ah4EY2nhPxEETufZ@fedora>
References: <CACVXFVOSm=VpYfxUEpYk4yC2N1uAoK=vbg_A=h51GXeeArzCpw@mail.gmail.com>
 <20260601215129.1375-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260601215129.1375-1-hdanton@sina.com>

On Tue, Jun 02, 2026 at 05:51:26AM +0800, Hillf Danton wrote:
> On Mon, 1 Jun 2026 10:29:25 -0500 Ming Lei wrote:
> >On Thu, May 28, 2026 at 5:16 AM Qu Wenruo <wqu@suse.com> wrote:
> >> 在 2026/5/28 18:08, Christoph Hellwig 写道:
> >> > On Thu, May 28, 2026 at 03:11:05AM +0900, Damien Le Moal wrote:
> >> >> It sounds like the VFS unmount call needs to have something that waits for
> >> >> sync() to complete. Though, it really feels very strange that an FS can complete
> >> >
> >> > I don't think this is the VFS-controlled VFS file data writeback, which
> >> > we wait on, but some kind of fs controlled metadata.  And yes, it looks
> >> > like those file systems are buggy in that area.  We definitively had
> >> > such bugs in XFS before and fixed them.
> >> >
> >> > e.g. 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers against
> >> > unmount")
> >> Considering the xfs fix is pretty old, it's before the fix hint thus no
> >> such mention in fstests.
> >>
> >> Do you happen to know which test case is for that fix?
> >> I'd like to adapt it for btrfs as a reproducer.
> >>
> >> This syzbot report doesn't provide a reproducer.
> >>
> >>
> >> Another thing is, if it's some btrfs bios on-the-fly after
> >> close_ctree(), the most common symptom should be NULL pointer
> >> dereference inside various btrfs endio functions.
> >> As all those end_bbio_*() functions are referring to either fs_info or
> >> inode/eb, thus if the fs is unmounted before the bio finished, they
> >> should all cause use-after-free.
> >>
> >> The only exception is discard, which is using blkdev_issue_discard()
> >> thus has no such reference to btrfs internal structure, but that's out
> >> of my understanding.
> >
> > syzbot log shows the null-ptr-deref  is on WRITE, instead of DISCARD.
> >
> > https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28
> >
> > Adding WARN_ON(!lo->lo_backing_file) in loop_queue_rq() might capture
> > this bio submission context if this req isn't issued via wq.
> >
> I suspect this makes $.02 sense given the check of Lo_bound upon queuing rq.

Can't lo->lo_state be updated after the check? It is totally lockless...


Thanks,
Ming
