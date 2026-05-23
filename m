Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12BE319617
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779559091; cv=none; b=RLVlzqCbo8/i0w54bSTOeVr31wbTtAtUuqoOkC8WuLpcMGv+QkUEYVkRq46fmYDA3cJLRITX8agMwTDrWlqHidCbwl8gr9D8yFKvvyuuENG6+LvdVCNhNxfYv//DgYlA5IQaPlfKz39TcOs6jHP4NqV8q21m77v3rAfe3q9MScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779559091; c=relaxed/simple;
	bh=MgC/P/gEjTjIokqDD+Kf5/VzgFtZeIVwAhu03Zek9HE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hf/Fw/NQZq/u6EMGT/+MdpPtZiNDpRyHeGiwxwN6YF6NPmq3HHBwUtbecooxFL7L0+b42IAveAmF1L4hTHqzLUSZnYNxXjd10N+iRAhwnxO9rCG9Qn8ObZxgRT00aQcPc/dpeICLHr6pVvRR76c5amBbzqX6umdMn7RqmTVPxig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A++4JHuk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A++4JHuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2F81F000E9
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779559090;
	bh=5lkAkW0ltEaIVdNavBP/bdAIBP2xLPX37ePPsSUl6FY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A++4JHukAUEpo3CkVPiHqTmkaaOhrUSy/Y983DsCGzRISGIDEc6UroUNelh6dYXKt
	 5FueZJ6TM8NYOVC3sm/3oQr+8he3zXOOb6opKfaAvGZ8qeEqIXZMgAxCk3XYbrWdrn
	 1EQZjI8fdDMzqClh8Dr+oBvsLa6W1DM5POuet9cZ3fcdF7X055IXGqRdETUsJJ+tHM
	 rBouasu60JYNydT48KWSEPj2u5SvKrlC5fY5P5WJHY0qigXZoO8TdcWkdRzDawoXVz
	 IZA1HkeIdUWrTCYHuWhMcz6M8Dr0F2il9IIXqw8zG0NGMSWxFP/Dpbql3r3YaM/pSf
	 0BkpcwTBBmVTQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bd6460b0d11so1481576666b.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 10:58:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YwJPFcDQHm5tmHpy0xwxTYUqs1lnptBI04dlg3cFKo/D9A3AauF
	sGu+QBCP9+M7D7VDZwMYKEset9RnWKvzSonVoFc/wqIbvLcHOFUdaaVh228XjUjRJnkK13IZcZE
	oEY515/NsptWqspYo3K8bPeLbJO2TqQw=
X-Received: by 2002:a17:907:c003:b0:bd4:7bed:512a with SMTP id
 a640c23a62f3a-bdd2580bc63mr539590466b.30.1779559089136; Sat, 23 May 2026
 10:58:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778776706.git.fdmanana@suse.com> <238c79ed66ab85e05394448aeddf91899839ca22.1778776707.git.fdmanana@suse.com>
 <20260523175114.GK183694@twin.jikos.cz>
In-Reply-To: <20260523175114.GK183694@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sat, 23 May 2026 18:57:32 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7g4JCCw=n0DDq-tRNiBuiOAO=Pc4SZxQZyoemOMV26Yg@mail.gmail.com>
X-Gm-Features: AVHnY4I7Ji24j1WSNmP9nTiTBu3_K3TihVYLIEe94vBb8xDNJ7SzLVHXhc20938
Message-ID: <CAL3q7H7g4JCCw=n0DDq-tRNiBuiOAO=Pc4SZxQZyoemOMV26Yg@mail.gmail.com>
Subject: Re: [PATCH 19/28] btrfs: tracepoints: add trace event for add_conflicting_inode()
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 23, 2026 at 6:51=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Fri, May 15, 2026 at 06:00:16PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > +     TP_fast_assign(
> > +             TP_fast_assign_fsid(trans->fs_info);
> > +             __entry->root_objectid          =3D btrfs_root_id(ctx->in=
ode->root);
> > +             __entry->transid                =3D trans->transid;
> > +             __entry->ctx_ino                =3D btrfs_ino(ctx->inode)=
;
> > +             __entry->conflict_ino           =3D ino;
> > +             __entry->conflict_ino_parent    =3D parent;
> > +     ),
> > +
> > +     TP_printk_btrfs("root=3D%llu(%s) transid=3D%llu ctx_ino=3D%llu co=
nflic_ino=3D%llu"
>                                                                  ^^^^^^^^=
^^^
>
> This looks like a typo, "conflict_ino" as the variable names.
>
> > +                     " conflict_ino_parent=3D%llu",
> > +                     show_root_type(__entry->root_objectid), __entry->=
transid,
> > +                     __entry->ctx_ino, __entry->conflict_ino,
> > +                     __entry->conflict_ino_parent)
> > +);
> > +
> > +TRACE_EVENT(btrfs_add_conflicting_inode_exit,
> ...
> > +     TP_printk_btrfs("root=3D%llu(%s) transid=3D%llu ctx_ino=3D%llu co=
nflic_ino=3D%llu"
>
> And here.
>
> Otherwise no other typos spotted in the whole series and the formats
> look consistent. I'll fix the two in for-next. Thanks.

No it's not a typo. It's intentional to call it conflict_ino - as ino
is too generic to determine what inode it is.
So please don't fix anything in for-next without confirming first.

Thanks.

>
> > +                     " conflict_ino_parent=3D%llu ret=3D%d",
> > +                     show_root_type(__entry->root_objectid), __entry->=
transid,
> > +                     __entry->ctx_ino, __entry->conflict_ino,
> > +                     __entry->conflict_ino_parent, __entry->ret)
> > +);
