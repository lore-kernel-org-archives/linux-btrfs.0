Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EA0372EFF
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 03:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787888041; cv=pass; b=typ1HyekY8nR3kl7vLPCioM64HTxRye04f2hjL+scR7UvFpMyGKFf52ZLbie44svwMajuIcISudjav1C+mOH4jkgqgYfsVBLYIU5smoWdncQ3BoV6mRysPkMLEys25/Fq6Q8sM69rMD+Z0pnFYE8gM6cj2k6xOaNrKQmPwPjtgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787888041; c=relaxed/simple;
	bh=eVCUgnuZPY9rp4G0hxfWBoh/8wdCFKKRU8Eq9Q7yXbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PBGf3o9+i0YMtxIBw9Axi073+IgZpGtKBYGgIChwL+TYETV9J59S3F4eVs5L3L4HfkYnM0MnMM2nRg1hEJuh++lBPbd7AwsuYuKqueAVqVciK0ihPjEKxmwRM9AzjMysO9j42Xul7q8izUOpVAk7lcaPO7Up9VUNB59//uJF5Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qoJ0brIm; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qoJ0brIm"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7f0167e59a3so241421a34.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 20:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787888039; cv=none;
        d=google.com; s=arc-20260327;
        b=nGycYUooU4DxtN34F4sHefuQMXf04exF4TWNF+VLjrIzRPE7oXN1Xv7t6yK1sY30TN
         E6wneXv686Lfi6c1aSY3LZH4HclpmuRM/1/UKzH0Ci0f5uuvO++FBcxld9TPohzMCp1W
         etZBHtClCiSntpXcyojKaGvUlDXJ9H704Ki0OSmOWCdCcp2EiaVAEUJf/IQBBsLjgqQQ
         G4Gl3Ef4YNNScQJLkSyjSt+UFFWa1jdzoSc3KbvgLmwVWlHL0g0Xmhgi2G5adJhHZFnA
         SS4jy9uYMu/4hcQYBxGGpc+UhbiMROdJq6xdFtS+sL+kF8aapc9pUPgcnayqsFzW1XeN
         sIBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tJ6GRA/2LwQW6/jDEIjrj/TZS2ZKHOJ3XYsZbyYACDw=;
        fh=J4MyuEjtknxj2sz/GVIB80vwj7o1iDjPy+UZczbtPpA=;
        b=gpLf/tmzvT1zzmbXfR3Lv9rZykyMYhRthhUCuFES1ZVb0b0uYdJWrUvi3F5X+1iIyI
         9y6de4fCJFllc2+N7vgTlCFGNXOczzQ9AdEpN7OH0KWuzk3yR7mIId/WGJax60kaHEa+
         u3kZEd5AsYyWMC4npPPgjBn8kb/pO7+2Z99G5nR2Z7D1BsVJmNPQqeW0CEkKqM5KfEpE
         ybtEDbOIJoB0jKDRjgojB5NMtmlFVhJdCfBOtlE5IHNeFinEMb7ZRU9Z/mkcn+4R85m+
         HgbcKY1iA5LHR12a9rECscn/EnnmgjjV46+M153W4A5Nzk5YvsXZ9x8LRh5tgvwA+SdN
         sGYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787888039; x=1788492839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tJ6GRA/2LwQW6/jDEIjrj/TZS2ZKHOJ3XYsZbyYACDw=;
        b=qoJ0brImXYW2jxuJ/+X9STf16jjXZ92rLmZ4786e6MVSpMWvhHnkJ14DzuZd++/cjq
         iXnv5vvRllyON65+nnXaCJ/b6+YH56o0zedDj/zHvJNlAGDchuDSruVJyLQBrV8WAXWs
         SravIim8345TcwwvXjYeU75tQ4kL7jLhRajFS1OSDokJJV/2VK2hrLyNHeytc09YbPBE
         jM2IhEqSV04jlyvKp+lPOuB2WYY9aatRDk+LOTBeBnMlDt3YlDDVrTb0oSdatP/JD6YQ
         IL0Ud2rj4HI2GkkPVHkPeM+vv4EnsEOhUTSW45cOfdJ43h4sIYmtFzLdciJnJMx53rpl
         0bRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787888039; x=1788492839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tJ6GRA/2LwQW6/jDEIjrj/TZS2ZKHOJ3XYsZbyYACDw=;
        b=sS9Z7ymaJ4fwohFtNuvR7jWgFR35QbuU1abz+kZ2X+iyKxAQQ4+q9CiHrPfiWHYBQ+
         qfGJ+97GQBXZlCRjI22gWJQtXuknYurxJOcGB6wqZ7MgT6xnsUdKindAv1v1M37UWxeZ
         83xHWNKyj1juIERi+4xqVr64hDiuOx4ORCfj7cb77r8x1fgBBzXvtjKZkZxJyhP0L09m
         ESEtvtTayZYAiDApAS4gKJRL5X7RGp02rRn4THn+0X9R6aps89PB3QZZcniK+F9X5Py2
         AomQwLgVWe79F7lfRE/9LkoOqHh2VdnGyuEaTg1mT2XfBvxRVP+xcGz6m4OvTIcg4qhg
         QI0A==
X-Forwarded-Encrypted: i=1; AHgh+RqShhSmxyWZBoE9NLYxaIi2hSgxG0xvh+NEV5NyxaHg1yJXgCpGiZPAuo8SIPf+f+AvBzoDoz1z8ZJCtg==@vger.kernel.org
X-Gm-Message-State: AFuF++n8PTbcQlLTugbMkim/BDybeRS9oQvwEsQ8MyUKuB5/2cQbJmjl
	FvqPT6ZMRViNBOvoLqry+uBx3/Kl+uhb39k2pzxqDe5ANAanhPEKBgtRbGvifbng2RXG7DGyKW4
	299RUjrE/ftfaLjto898+7Tfvc0oHJBM=
X-Gm-Gg: AR+sD12yt7QN3+eYxUD0mGSLmp3MOk8Amc4pvhYWWY+nXRcqYvLfsRGZK++4euLhjyP
	x6Be11Nf/CTkBe8R/COOH1WeR3ewZb2z5pXp2XjSE74dU/v+G/5CQHZix6Nbl53mT+SQ2BfLUHU
	P99A6PvFml0q44Ui8xBj/HmlWa8v9g49OdOurNlXzQaULwaWlbSyPfuVtZ1mORl021hE+KSRFPR
	1yPGhHm+AkugcAPewYEFTTqg/NL2W4zrfIHwluYdZjxcvaREv5NTNBdSkZaon0RN3AV0e57K3jM
	X20APt+tGRwJ+DF1M3E7IkDuJaYRoBT1Xadg3I4VoBmLPy15sBkDcrwaed4JbzayBbsuTj/Qm/Q
	wvT3BgNVI4poQvCGSTEKBSabApQAAHavrTY/bAGuqNFel
X-Received: by 2002:a05:6820:340e:10b0:6b1:67e1:fc8e with SMTP id
 006d021491bc7-6b1c66e6ce5mr2559540eaf.25.1787888038951; Thu, 27 Aug 2026
 20:33:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com>
 <20260827185722.3234622-2-csander@purestorage.com> <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
 <CADUfDZoEosgMMQ47BDWBskTOZrYZpg6VUT5c4kwczDLRLXYk=Q@mail.gmail.com>
In-Reply-To: <CADUfDZoEosgMMQ47BDWBskTOZrYZpg6VUT5c4kwczDLRLXYk=Q@mail.gmail.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Thu, 27 Aug 2026 22:33:46 -0500
X-Gm-Features: AcwNN1V96G10EnqkMmlBEbQoJ8ihVOlJhML3SIuW3TsrH3jrmu0CBU7aGovmtII
Message-ID: <CACVXFVOLBVVGwfo+mbn+4jnGKZS66dL_2ghsKiaT6buscWJg6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 4:44=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Aug 27, 2026 at 1:05=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Hi Caleb,
> >
> > On Thu, Aug 27, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > In preparation for setting the io_uring NVMe passthru CQE results fro=
m
> > > the blk-mq request completion rather than the task work callback, spl=
it
> > > out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}=
().
> > > This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
> > > consolidated into a single CQE-size-agnostic function with 3 fewer
> > > arguments than __io_uring_cmd_done().
> > >
> >
> > The conversion looks logically correct to me but the interface feels a
> > bit annoying / fragile on the caller side.
> >
> > Is there a way nvme can get what it needs without changing the other
> > callers? Would it work to just keep the existing
> > io_uring_cmd_done{,32}() as is and add a separate API for special
> > callers like nvme, eg:
> >
> >   void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 re=
s2);
> >   void __io_uring_cmd_done(struct io_uring_cmd *cmd, unsigned issue_fla=
gs);
> >
> > where io_uring_cmd_done{,32} would then just be inline wrappers over
> > those? afaict, then only the nvme callsite would have to change and
> > fuse, btrfs, block, ublk, and scsi_bsg could just stay as is. Do you
> > think something like that makes sense to do?

Yeah, this way is definitely much better from a driver viewpoint.



Thanks,
Ming Lei
