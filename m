Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7413DA7FF
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780327784; cv=pass; b=uVw+KlAl8lroeVqNrzq3CKFotgk30KPUX40bLcA2XPt6zPNM0BmttdCQbEY9T8Nb/p80T4MRZTCZZqK1jqaFzvlCpRMazw+H7v1uliU0a8yXh4cfmlfbZTb3bUZQ4DGrB9GQFXbVOk3R77NYAnyQee0yLK6QwSPkNA1ePsImJ90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780327784; c=relaxed/simple;
	bh=oi0Ow0XDEAtBt8RurlGOIpfeSQVz3W7XDL/R+3Ddj+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxaTZTK7NCe/btfi+NfXwXsM0fNaeLtPvTMZxXaG+dsUHYWdCMs4lfA1D14jAcmJ8ibvm9CXv4aD9qSQAdqClyKGcdeMYWJQmLSURm72Z1P6NSpbMJLHa9QWExd6cTZKQcjDlDeYygxnhG/LheOwuTdKrXkOhxyHlJCzOv+2Otw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JmZLuySf; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JmZLuySf"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-43cce34c881so1042454fac.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 08:29:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780327778; cv=none;
        d=google.com; s=arc-20240605;
        b=Gjuh2dN3tG1EH9eXLSCV80FgrJJ6tzmKTjIEntxyztnrzinjJbw1R13IttPNXu2NmH
         Eif7/4lukDWF6a+06ajbkzeWey/brHusSCmXTcZ/uXIJuPzYJSTHLsellraBeQ7YmfRW
         xohpNns/zsGjqfLdWT8CbyLWOt4J9MR1cTJgCN8GVpKjKGIyZIfuXfZZxMrcO4Mdk8zg
         F7oc/LfNqGBkUbTMi4Mgnd9ISl2AIM6CZLjjpfPzMrN0UvtW4yCjm+iTVY7ACjypMqoz
         Ftkyx3hRLH6fFNbLAs9wouihCP6bsuvHy1FqYOhpKmNRYxgD+lXzZah3A+BVqnx4DH7G
         O3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rUPzckO9AMpnkkxRCiU7u4+L0pp2JXYyq4zdqyU3+88=;
        fh=JoK/O3rXUUEz2VjdfcDhNzjL8UqwAQRukw6j3+rvIg4=;
        b=ZUtK1pqCsB0AU08Uk0b+0fY4ZFp4j/UP/8PwQJmFah7wcBwiLV0kEaheSzkw3MruYC
         jZ4QaGznz7grkRu7CDWxTTAqSBHLsirgyMYrXO+S+NpisIOcJ/jcX/sxe538/QPWifMT
         HHQauYU3YPDJc8rRGx+Y1JUO5vr1FQdOogQMUuDz115fy5uFKC/RZNrKZWpdCpp5G/MO
         6Ic7whkyvb+YKc5O3X2I6diZqbe84gn5DViK+2RGr1BOrgMn5ZQYBVJJ+6E+2cP/ChnA
         ZRF0xgk4dxd+5CVoVBfy6KMJoWb9CSGEh5Zjd9npOz1buJKlhx4y3AswOfVRrnX/PQ4g
         1Pag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780327778; x=1780932578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUPzckO9AMpnkkxRCiU7u4+L0pp2JXYyq4zdqyU3+88=;
        b=JmZLuySf1jxWK5iDgOUg/KC5wpk4YcTA4iHLvu3SPSE6bQSgAc/uzq/xgRbv1H9GNx
         jX29mDcnib861fKIHDOztT1C9J5hKrp56xQwMKnFZSG9MZ2K4BKW95lLf3VbLQlRAITb
         6L6p248QXgPCy070KkpSC25fdw1D25He37dIruTaI9ei4g1N0p1vtyPZa/fem+Q+Cr4e
         hexmIDrKKR1LzML5Axq6NWW7A0Q1OR2JYMMutEM0sjOrz4E9SuQSQXE0tNsTI7bH4k+t
         asSyLZRtVrAP+Ad03YBGvDtgn3bphgeBTVK3+I5flNNT3KAejHZb1WkkA3k4Qn7fpefh
         SZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780327778; x=1780932578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rUPzckO9AMpnkkxRCiU7u4+L0pp2JXYyq4zdqyU3+88=;
        b=NQnUwVnHr9apGxYNa89k4TjTiUyZacvIRukFSLjW/28u46PA4Cl7s2dPBF6JRvsEuV
         L75/7EfoB1k8CFE7quAUftq5LwOw0SB+XHiq9OJvEPaYcBFnCo4a5o2Tt7nRnZaGKZUe
         LJurG6IZGdCc4+3TtcAJPYKzMwQynpAB3nx/iw8L/j23bLwIIT6sXezKFkSyBWlv/Nxv
         cGzMhH354KpJCyTKMfscudsAyIkEgLRWGNFJqS7ux8ARps9Ac1ixgXTLiT6tvt0iYqMG
         CgssH9yNsLlscgvWBakGjGNMqVg5NFRmWyi/b1rsNcwp3N/f37aS2lOlGut2pwGPGqq4
         Vd8w==
X-Forwarded-Encrypted: i=1; AFNElJ8c3R8wr0qzxvVQ8VEy2IwTJtBk6eLo6l+9O08wjoAetAyFX0ves/S1T9opiO2Ht9jmSrSdI6MiTzvsEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFZ0waxeuGll/i1CJYBccFamKYJMcmJ/Nij/OkNG7IBnbcsiN3
	C6l6IzTmyeuFvW5koG7riSCC779d3L3ULmfzcTmC/e3n/wbJ2r6XyWjvXUzka3WXgE8uEQcqGO/
	Yp4gs1cAO8l16tpqtrVmpg3IQUtHK9xM=
X-Gm-Gg: Acq92OHmB4ifKAM/gnNtg58BIoJV6kiE+m276qB4IUSu0mPlCsD0ZW1JPfmTXtuBrM9
	uQ+R8gDjcYPfd1V4gO/X0v+H6JCYwwACffI36yFV/QonOdokwQfysmJQMKMDlz+6XWIlSCq3qLP
	a8ocCQlp/D8aFu0xwLh170KZzluVZttGGXmemNHXn4i0BOM/BX+PkmPbRT7vBt3jaP0rbFbQQKA
	v+zT4f89JB2d0J6wLSAtsztUGQNWfBRK40T33onzlBGC2WaDu4TTXHFapNHGdPNtvnQA3YRn0r+
	p38IvTONYvc4nxnuFmua2+NkRmQWu1L6bxPYT4sg+4/pgjK3tmUI5SWB0qNIz+1dikdsL6yK2bY
	/k+N9czwsfX4MymkFUg==
X-Received: by 2002:a05:6870:e393:b0:43b:4e42:9867 with SMTP id
 586e51a60fabf-43ca40b19a2mr6888184fac.15.1780327778175; Mon, 01 Jun 2026
 08:29:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ab8c579-eb76-4227-8a72-6ec819135219@I-love.SAKURA.ne.jp>
 <ag1223nAa0wZ8ALC@fedora> <fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp>
 <ahRocb0Vs_m6RF_O@fedora> <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp>
 <ahZGxoI6oHQ_vSrx@fedora> <d1b5a737-f0e3-4927-b762-430b37fbb2f9@I-love.SAKURA.ne.jp>
 <ahZeYQ0cLE1i8TGs@fedora> <fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp>
 <ab5492b6-a053-4e3b-8c59-2e836ae85bc4@kernel.org> <20260528083848.GA7694@lst.de>
 <36571f8a-4df8-4152-b078-d82dbff4ad7e@suse.com>
In-Reply-To: <36571f8a-4df8-4152-b078-d82dbff4ad7e@suse.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 1 Jun 2026 10:29:25 -0500
X-Gm-Features: AVHnY4Jo-naNphBnmCUZCCUNQGptd23v8VZulBU6wmiaiHgGY3TyxDIc_hpXI6A
Message-ID: <CACVXFVOSm=VpYfxUEpYk4yC2N1uAoK=vbg_A=h51GXeeArzCpw@mail.gmail.com>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Jens Axboe <axboe@kernel.dk>, 
	Bart Van Assche <bvanassche@acm.org>, linux-block <linux-block@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-btrfs@vger.kernel.org, 
	David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 5:16=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/5/28 18:08, Christoph Hellwig =E5=86=99=E9=81=93:
> > On Thu, May 28, 2026 at 03:11:05AM +0900, Damien Le Moal wrote:
> >> It sounds like the VFS unmount call needs to have something that waits=
 for
> >> sync() to complete. Though, it really feels very strange that an FS ca=
n complete
> >
> > I don't think this is the VFS-controlled VFS file data writeback, which
> > we wait on, but some kind of fs controlled metadata.  And yes, it looks
> > like those file systems are buggy in that area.  We definitively had
> > such bugs in XFS before and fixed them.
> >
> > e.g. 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers ag=
ainst
> > unmount")
> Considering the xfs fix is pretty old, it's before the fix hint thus no
> such mention in fstests.
>
> Do you happen to know which test case is for that fix?
> I'd like to adapt it for btrfs as a reproducer.
>
> This syzbot report doesn't provide a reproducer.
>
>
> Another thing is, if it's some btrfs bios on-the-fly after
> close_ctree(), the most common symptom should be NULL pointer
> dereference inside various btrfs endio functions.
> As all those end_bbio_*() functions are referring to either fs_info or
> inode/eb, thus if the fs is unmounted before the bio finished, they
> should all cause use-after-free.
>
> The only exception is discard, which is using blkdev_issue_discard()
> thus has no such reference to btrfs internal structure, but that's out
> of my understanding.

syzbot log shows the null-ptr-deref  is on WRITE, instead of DISCARD.

https://syzkaller.appspot.com/bug?extid=3Dcd8a9a308e879a4e2c28

Adding WARN_ON(!lo->lo_backing_file) in loop_queue_rq() might capture
this bio submission context if this req isn't issued via wq.

Thanks,
Ming Lei
