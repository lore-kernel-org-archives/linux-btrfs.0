Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D541925BC
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 01:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779844817; cv=none; b=jCzdT79dxn53q3huOmU9XWaY5gZtVmD0ioTVJCAP+WEmgkTIZXgs+/GDYiMGoZCS5PS7uZCe/8yHIEerGAzUce9E/Sz0toXw+VUe/hBCfAkQx9CP1jNtTrrth1gFTDJLQHAiJ9N50mim+x4kKe3aBbJ7MkYMOJnrmQrI7E2NS74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779844817; c=relaxed/simple;
	bh=zZFnGIBULEQhg8FFEYFwPaffueN2j/MQSoOCifUrvdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZwXLbnrP/YZFDK2+Z9rgDq33d57Maa/1xqwQj+ya5FozDzOf8386rTUA027eeB3YvwOJ2iRNICOWnYkxvn3/OX9M9648SnYde6KQZX17QXXrIAmU88VP1UVssPuadcLjiVispr2HOhgIId/xY5nZxLoN+ZtmEXCRUXsNfkAenM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WLZ1PPS9; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WLZ1PPS9"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50e5dbd8e0eso130830931cf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 18:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779844815; x=1780449615; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mlmC4XR4gxPVFC+3IrEsRTTaSk3Dm8cvG0pTcfli6zg=;
        b=WLZ1PPS9k9IZrVn25H8e/ZPMAKqINazlPctdkjlpPnSayPqfBE7WGPuIKzPx9d0bio
         8W62l78jxUQCBctHFNX2b9ASP2/8TWSkMyhYYX/MwMs9t9TiAsl/u+IG0IXlQJf3DDhM
         S5Q1u1yRuzeRCQop12INnlvBMnZh1f16IAOo4YgWJYbHHNi5iEi3JI3mlsVQ5Cx9M83p
         v3IbJAoadO/1bDkWt2eCkPrpr5pO02zqOOL67wT5s9I3ouniIQlkhyrUs94N3ZiAaqUr
         RgpGIMGHB6Ev/UQktUX+3jG8u67iELUNX8Ntb2YaX1CqZRVvLbjMFELXP8b40rO1zzCh
         nXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779844815; x=1780449615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlmC4XR4gxPVFC+3IrEsRTTaSk3Dm8cvG0pTcfli6zg=;
        b=BGNnJd7C9zSLb2QqavysvaQoWLJLuaILh6p6JuVD9beLxyv04Boe/PHcK3Rf+EGLnU
         ea2RJsRz30cb77dSHH/A59197Di4/N0p9pLuhSNWiCIZ63y2g2bAiCDoWgn7SwAppYw9
         fnMUA4RBrj8XbjE5XQIdIr3p3xkbHzwwy7eQptO17qJXvLrZFBPVqfvnZGVG7AZezZ1I
         fspQAqSWuT3jwS4CSpuDVHAjY02M9qbsSlunPuseTGrPwtaY3IlrXghXuF5KnUNneTd+
         4tUeDjVQ08FDyeVXQMFrq4kInRhTIQVu5gIJwxrAdxPi/HiZfSm8RNtcstTtcMcwHYrB
         HCBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+r9NDR9WQ1f9JeCjfXxmpaHFdB2z05fdGJeJ924JLV5hmXAhPvkDAOF6SLtN0Cc52B/+R/Fex7bxq5/A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4sSFrL0i2oVixt9FapP62rxELzP7DnJBAXuLdJVFv6Mv8Dn/6
	f+zUoYLQkBt94h3wWlfRkfXZvP3lu7rlL22NDZIPcWw/mEiXGm5CvpXR
X-Gm-Gg: Acq92OGkJyc4QSFTAIC7E8XRzCthzBg+OJaPG0Trk9uiAL2APa0W+jGsdYccSQwFDBi
	6aV6BiApxwvcPkVOKSKjpHhHspNgnAlD6uB5F2U3wI1PkZgWMg9OMNC8buna9fhzmFzzxpuocpc
	KMYM/aPjisQLD95J36cyzWnqm9I7dvC0wjKIyUmG6YdqxA18uKdowP4fqZInoimpOGYkqeVf+s6
	sgMqvIYzLsLWGr6ohLI9MfL60UKK0qn3L8mfSbos6ap2RtGYX5l5kqubSJ9OHvsOgYPHRhmg8Pk
	6/pvVqn5wYhdP+rI9pGdBM6Es7Me6RxKsqcNHKp1w+6YUdoIsbm2nsXgNh60eY/qvZuX1lZw24W
	jQR8qk4KtImuRketUvIlj3uK6uI7EL9Vcf7s4IgUJj3345/FGRHAPsgNJJthLyYMy8FaMMWH6xQ
	oUPThMwmz/L+mAPpgFdCWFOUGxqkAFBwmaVYBRMo1MghKGKQYWxeJFV+ir4iy0iFe1Ap2waWO/g
	DxwCcbXDti6PX/TZZX2yOEpJ2QKWmAHWcj1Ebx+MYs=
X-Received: by 2002:ac8:7e93:0:b0:50d:66b6:1564 with SMTP id d75a77b69052e-516d42e4250mr296025671cf.14.1779844814473;
        Tue, 26 May 2026 18:20:14 -0700 (PDT)
Received: from fedora ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706af1328sm35061051cf.20.2026.05.26.18.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 18:20:14 -0700 (PDT)
Date: Tue, 26 May 2026 20:20:06 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <ahZGxoI6oHQ_vSrx@fedora>
References: <20260518174013.4b72dd50a5bcb89daaed1f62@linux-foundation.org>
 <d43125ff-cc66-49b7-b16d-1b2650c68c23@I-love.SAKURA.ne.jp>
 <ag0lS_CbKO9R5CV8@fedora>
 <94076bc9-2c09-4bb6-8468-b6b8af419cb9@I-love.SAKURA.ne.jp>
 <ag1nfIFcykmQHbkk@fedora>
 <1ab8c579-eb76-4227-8a72-6ec819135219@I-love.SAKURA.ne.jp>
 <ag1223nAa0wZ8ALC@fedora>
 <fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp>
 <ahRocb0Vs_m6RF_O@fedora>
 <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp>

On Tue, May 26, 2026 at 09:25:30AM +0900, Tetsuo Handa wrote:
> On 2026/05/26 0:19, Ming Lei wrote:
> > On Mon, May 25, 2026 at 12:40:19PM +0900, Tetsuo Handa wrote:
> >> Some commit which was merged in the merge window for 7.1 broke the loop
> >> driver; a race window where lo_release() clears the backing file via
> >> __loop_clr_fd() despite some I/O requests are pending was introduced [1][2].
> >>
> >> The exact commit which changed the behavior is not known due to lack of
> >> reproducer and timing dependent behavior, but it seems that we need to
> >> solve this problem in the loop driver despite there was no change for the
> >> loop driver during this merge window.
> >>
> >> To close this race, try to flush pending I/O requests. However, calling
> >> drain_workqueue() from __loop_clr_fd() with disk->open_mutex held causes
> >> lockdep warnings [3][4]. We need to flush pending I/O requests without
> >> disk->open_mutex held.
> > 
> > No, please don't workaround before root cause.
> > 
> > No proof shows that the issue is in block layer or loop driver, the IO isn't
> > expected, you need to figure out why btrfs still issues IO after this loop
> > disk is closed by everyone and writeback is done.
> > 
> > https://syzkaller.appspot.com/x/log.txt?x=101e4702580000
> > 
> 
> Of course we should try to figure out the root cause first, but how can we do?

Definitely unexpected write IO(after umount & loop closed) from btrfs is more serious,
which may cause data loss, so CC btrfs list and maintainer.

...
 
> Possible approaches for finding the exact commit that is causing this problem:
> 
>   (a) Revert all changes in the block layer from linux.git and monitor for one week for whether this
>       problem is still happening (because linux.git is more frequently hitting this problem than
>       linux-next.git ).
> 
>   (b) Revert all changes in the block layer from linux-next.git and monitor for two weeks for
>       whether this problem is still happening (less reliable than linux.git but a candidate).
> 
>   (c) Let sashiko review all changes between v7.0 and v7.1 that may cause this problem.
>       (Human developers have no time to review. But is investigation with moving baseline commit
>       possible for sashiko ?)
> 
>   (d) Any ideas?
> 
> P.S. Since the loop driver is a critical infrastructure for testing filesystems by syzbot,
> I want this problem be addressed before 7.1 is released.

syzbot is for finding real problem, here the real trouble is unexpected write IO from btrfs.

So please do not try to paper over real bug by 'fixing' loop.


Thanks,
Ming
