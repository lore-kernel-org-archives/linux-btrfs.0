Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79143B83FC
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 09:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912735; cv=none; b=i9dJdb7/eFyg2VFjfpBTlUq48rYQi088fqqWAzLPfbe0+2lW4mICh9WpdDmW1Db/F7ZetlsWEdJX6hx8i6vrfnhyueI1t4QxSldQkS7yMLzxu9qdIRrKBtJzosPP+QGBk/ftNrKEgIbQax4XyrvrGIyohsHlSzpTEv7NVHQrYnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912735; c=relaxed/simple;
	bh=Y0bB2bjPSwC0UVSg6HxaNMmsn1zRs5dQmKRY2/rbncw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrRLroWCrJvE8o2ydzBlVr2aEmTiul4fC5YtjdQr/otOJVNJ8XOAZ5xKkpNGp4dImLHljpuoygim0LohEDkU2CYRTbtsae7wNcAVUasJG7fmNA/MV5k7flfPksmWtbnORfGupAUmAyBaX5TdUKb5JP9Ui9gGWW+jpUQDou8XsDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=byOuF8dt; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byOuF8dt"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c0b9328c4aso28598465ad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 02:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780912733; x=1781517533; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=apLs5/2KkZjh2Fow0Nx9QliaxL3FfjRjk2c3CcoL0k0=;
        b=byOuF8dtiRythZTOiRb5zxvMuYarJwXumBEKOOQ2XmJOtxB3GLWyNKxOMtVnBgdqqb
         lkrDzokshaC9onb9GS9Vs+FJkmXU2GESs8IGsCocXwmI6Ivvrse07mqT+4XBze6lWCYi
         MpqgcVrc206+lVj3/TG0V2lrgBn8Qwavh7kxWw3/vY7/QnRvviuUFx02qjEfZrnUgLZ4
         mjA5NKu/yFiXKjC7jhdQdq2WIaOrRbqcVW08PGg+0lSefH9+mc/Z/UBaW/kb43Tw7+ZK
         OOuTQMIztcSWhHKKccVHTzFN8MoIa4qfvN6btTdMLOb7dJKKroSpbpyS85md8OihI4Ku
         z7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780912733; x=1781517533;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=apLs5/2KkZjh2Fow0Nx9QliaxL3FfjRjk2c3CcoL0k0=;
        b=O9eTRR8admQQnBc9bp614d0yGhamPAD9csCydTM4kvKOnXVNmBjlQEbIxexZB22IvC
         Yp7nUSVoAui0eZeoDSTx2jcJsq2BQUX8+Pi8+6RMS9fR4707JtzyLMhbCooj1hKGcpSD
         UE7s+Z6kNWGGdK9U9qhg2zXXSzaRLRFcwF4FysUYWl+3knBP/xVyiR5Stpn6xkXkzOI5
         OcaxaHLqgm4x+jftINzv5KbXGfxgKKfdF5qNuOT7RBcrcMTtqeqxLlr7uTS3yEI8eB4E
         alvDtXqF0Jqb2lOtWatE11OAop65OZqdD3KKY2yqZrZjw47oAbh5ERUcTzic+Fl8LMKt
         ycxA==
X-Gm-Message-State: AOJu0YwLoyBQ+mNzyfG+M0/UlPQ/NgXwy6URhGU7tmGQfyeyJ5nP8DDM
	3swbzggrhYe86b/opE+zYWcaMNPyqEX7hY42yfYFbwMwmJc5JqcX560n
X-Gm-Gg: Acq92OG+Sxcxu55r57Op7ESaUpsiXeLyRJMv4Uike6UlGAvqimK0+iWP85A4cGHG+Id
	RJbVOivhTO0eaB6K4VGS5Car1C9w0rDIIjNazA/6YkdsrufgM9wcoWRIxfc3OzzHlDrv5EK3GUX
	7fC3d1/6st6dXFlZL43T/pQYFOu0ntFhfDpN6cCGRPOyNO0fEQn0N8zTeh+84HwvNEYyafg0I2G
	uUgWOKzNqI+jHXvU1/TrPmS3QzvfvJBJdPJxBUFfK/mKd0wWR7wCXojlCvC/qw7KHTUEAJDPwju
	N5VRXGzqP7bQnfx2zErNQFJvSa3JUmFDzj9RiL4rosf107JcFe5WmHejaMeQH3QTUhuR8EQvYVd
	DOu7YU/yoWSxMB+cbbq4d3vbvJ6tJ2tzIBLjBg/gpngyLlVdG67kR/mcqsBbwKROEX5I2Y5c7SS
	Atu8CwxiSv67sZnmMRV5OyMTUHQYUGqUHLo7L6Hhmrkq3XrVER5HPqA+opcmsBIw==
X-Received: by 2002:a17:903:15cf:b0:2bf:1e37:a2ff with SMTP id d9443c01a7336-2c1e77d8648mr156709615ad.0.1780912732991;
        Mon, 08 Jun 2026 02:58:52 -0700 (PDT)
Received: from Air.local ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164fa3a5fsm187168225ad.36.2026.06.08.02.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 02:58:52 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:58:45 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, josef@toxicpanda.com, 
	clm@fb.com, xmei5@asu.edu
Subject: Re: [PATCH] btrfs: reject names longer than BTRFS_NAME_LEN in
 btrfs_get_name()
Message-ID: <aiaSQCNDztx47xlI@Air.local>
References: <20260607121429.2091845-1-bestswngs@gmail.com>
 <a9a18bff-520a-4a8d-bdd6-d36fb41c2c43@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9a18bff-520a-4a8d-bdd6-d36fb41c2c43@suse.com>

On 26-06-08 07:51, Qu Wenruo wrote:
> 
> 
> 在 2026/6/7 21:44, Weiming Shi 写道:
> > btrfs_get_name() reads the name length straight from the on-disk
> > inode_ref (or root_ref) and copies that many bytes into the caller's
> > buffer with no upper bound. The caller (exportfs_get_name()) supplies a
> > fixed NAME_MAX + 1 byte stack buffer, but name_len is a __le16 read from
> > the leaf and the tree-checker only bounds it to the item size, not to
> > BTRFS_NAME_LEN. A crafted leaf with name_len = 4096 therefore overflows
> > the 256-byte buffer with attacker-controlled bytes. It is reachable from
> > a mounted untrusted btrfs image via open_by_handle_at(), and on btrfs
> > filesystems exported over NFS.
> > 
> >   BUG: KASAN: stack-out-of-bounds in read_extent_buffer (fs/btrfs/extent_io.c:3742)
> >   Write of size 633 at addr ffffc90006c9fc40 by task exploit/5192
> >    read_extent_buffer (fs/btrfs/extent_io.c:3742)
> >    btrfs_get_name (fs/btrfs/export.c:289)
> >    reconnect_path (fs/exportfs/expfs.c:222)
> >    exportfs_decode_fh_raw (fs/exportfs/expfs.c:473)
> >    do_handle_open (fs/fhandle.c:230)
> >    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
> >   Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
> > 
> > Reject any name_len greater than BTRFS_NAME_LEN before the copy. Such a
> > name is never valid on disk, so this only rejects corrupted leaves and
> > leaves valid names unchanged.
> > 
> > Fixes: 2ede0daf0154 ("Btrfs: handle NFS lookups properly")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >   fs/btrfs/export.c | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> > 
> > diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> > index c403117ac..a54c6e8b3 100644
> > --- a/fs/btrfs/export.c
> > +++ b/fs/btrfs/export.c
> > @@ -285,6 +285,16 @@ static int btrfs_get_name(struct dentry *parent, char *name,
> >   		name_len = btrfs_inode_ref_name_len(leaf, iref);
> >   	}
> > +	/* The caller's buffer is only NAME_MAX + 1 bytes. */
> > +	if (name_len > BTRFS_NAME_LEN) {
> 
> We do not play the whac-a-mole game by add random checks ad-hoc.
> 
> Do the proper ROOT_REF_KEY and INODE_REF_KEY verification inside
> tree-checker.
> 
> > +		btrfs_err(fs_info,
> > +			  "corrupt name length %d for inode %llu in root %llu, max %d",
> > +			  name_len, btrfs_ino(BTRFS_I(inode)),
> > +			  btrfs_root_id(BTRFS_I(inode)->root), BTRFS_NAME_LEN);
> > +		btrfs_free_path(path);
> > +		return -EUCLEAN;
> > +	}
> > +
> >   	read_extent_buffer(leaf, name, name_ptr, name_len);
> >   	btrfs_free_path(path);
> 

Thanks for the review. v2 sent.

