Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FF554DACE
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085972; cv=pass; b=VijvybKW2X6FBoHLvx0FAKpiBLp7kkquRNG0qOBkfq+n9doDQOr9wN/1kL/y2ZjjIKRKxqpg0qsSnaQn+wP9bXXlsBIKPMoCQyF1j92vsze49MUQC0M9TCTXOg2/JX2xAyvpr4+NbSL0vVNZj6Ip9dO8YDjqnkNiAfBud3R0gaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085972; c=relaxed/simple;
	bh=6V0JdsZmrDPONncSpMZX6xqR02M8d8On8QjmlhG5X+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2H+bK4uTCQ/LbsdheNAqKxaOwTsdruHqQ5k83XEFbuKDDdnMmJGosGWen/dDe0z420JrvQAN77gVppKJncC3WORdrAS4uWj2uNRXwWePH5mvWLQx+O8a8ZrYYiHV5H57udAcCwAUVpYKrjnMYsHh2qgMlWTXvDSWEVdh5t7/8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ET408zLj; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ET408zLj"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so29222515e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 07:06:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790085969; cv=none;
        d=google.com; s=arc-20260327;
        b=IxV8jJ+5l119EB4oQNCiipQJ9Niw4TwbjVuCfY87uqc9QwkLdSI03q3Znhpk1HfmJm
         KAHTo7zzxM/xamymkNAxrhu5cYuPL+joGeo6wZUQdfJvyakObM6L6NrsSkYm5u9Kep5R
         keKVAfo5KHC23/01HSnOHdDv1MJza3Lt/l9Fi1W59yUjh0BHum5tM7GQybuCNtResMRi
         p7bc/jRd9UMWCc/AXED//rdx9R+JSPFwNgOn4avg/2dv14by6v/KpomgbD1PVmhpKzVg
         NsOlCCAXOhHJ+I9CSSY2opv/2ysdBgI5wE+ignTe5SZhjjMzNLQCXN0vlgTHtqhBlfaA
         VFAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=99HU+/JZi5dG2Cu1dueoA580pKUbZlE9+G71ugT35kg=;
        fh=SDyiORj8NFH/1EhiMpAHAcu0EKk8Kd1Ynxl0pt9k+tk=;
        b=LR4b8B7vhb06FngGFOGM0MneDS1Zwt183fVUpG3x3iSO1dIpcFeAATVzRNYHe29yhU
         y1cmordWyiJ21S2eOJb+565btlLrSRJRM9HWC6y+ft7J/CWRjjNpkq6cShZv9OjAD/Ju
         hM/qV5+Y5ZqAVC50g0MwvThEFu0uYv2x5ML7AHEGz4XgEQcsBHFjg5bP9pgzvzRoHF+e
         ZFCGxOUmdMVOs9UoyT39jUtqYKhJgRY0zKB1mxXtHqRs1EsNfMlC+09ynNrDzc6RCeve
         tbKu2w26J5SWcvOaUA61CaQTP69jA9SprXscZs7JA5DyHeNZabCyO19gwhoUXq/sReoS
         lSzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790085969; x=1790690769; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=99HU+/JZi5dG2Cu1dueoA580pKUbZlE9+G71ugT35kg=;
        b=ET408zLjAzvCPY64foMxS80uN54uNuNIF6r4skc1oJu90iQbUarD8nhoXqWzkmWAhP
         OzdJ5SUo1qsNughomVYW4y3WageEMhf7g2TKk7Pj7NBIGWZITCafBLL445mCuVOYthBh
         A1C3YWvlMmt70ZJWhzmwhu+Ea0Pm26tvuWp/C7AOQ5B4sMwZGIZnuzK8qYiVQrcDyL5T
         YEZOVdbOCy31oUw1NwqNUH32rEsc4Jl0wWhKRxmhEld4/awf2LbVbWGX/sAXj9+262pr
         NqfMsnnyQ+k6fVEiZhuySOc6iy5v/62FKHzsDsmw0nFaS6lIAYqhPSt7wyRiAYiAFcfl
         ruGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085969; x=1790690769;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=99HU+/JZi5dG2Cu1dueoA580pKUbZlE9+G71ugT35kg=;
        b=cj5rTCCFSjltNdpwLxmdsL5eB+jbe8IFtYocRcVQIWhRmJi+1cLxAs1b7tCuEDnfbs
         9YjFUk04uO1JU/3ZPbSRtOckklOGwzMEd5+K5G6MwnoJlEUdyVT2Tr46o++NgU8iPK2f
         DfxEfR82zhdQ+WPBjSNNLHkru6LKq1VpOeWIBWuuF5FLDhJyZ/7XEtJ0VCDG8Quf24s/
         dIpL2MreN7jYdbZX7SNEJ8yzmUfDsfuSFA4dzWvKuFOAId7wvxl0QFxwZ2kr+rN4bINT
         6zyCcCOiQR5cXBsynPays27d68QqDxcgPiBZy1QeZPE/K+pzOkBfSa4oBcpwE5GqvEME
         EO1Q==
X-Forwarded-Encrypted: i=1; AKwUvBzAgmWnRvF+Ns/uK9Ts/qlIduOJlkeXY8PsiX4iavzeAmj2baH1PJrubvkwBKLB+1MEuchNq9F9MdGvMg==@vger.kernel.org
X-Gm-Message-State: AFuF++nMPOEMs1AJq7K4y+qU0nSskh48xLQYMC4DzC688x4Ww79V1CuT
	KZV1mJ3gOpFr0lzxg95X2cnuMgDuWvchFx63E6dyBE2HohWCFEr9SWHFBZrRtJdzngokf19jOrq
	EIBcBoAu92bnvLXKzzJBzCneYGYqZKyzDGJ3yTdABQg==
X-Gm-Gg: AYBFou0RH+u33UHyCL6csjQMPBjVpzNnBNwoGEcOx+Tf+DmPZexFaTAWEKkyX5tNX66
	6xwU72i4xJ0kCW3iVGCwXeTp7TI1SYML+CVP8hoj0AiliNrcxIAq/hIB6bWNz5Ygn1Juwvsix4r
	JQD0FTguBeIHvck7NtmwFkaN281mMW+pIL8bhUolvf6dYMtUqofSKmJ2Z4K4JjRjFLVn49IJcg6
	btSeR6CZeGgbxyxv5L0d3evMNqLoupRY+UosOzJVK5yEsO3NeOWTHPenlIV5PWH9djtbHWkqSgE
	ED6ymc0/DfI5cfQcsg/n0ZsZy/HirB1SyxWCrkG1Cvm/iHD07qC2ZPNFoqCmidhNH8FAj2JQdGe
	d6rFPBEpoqT8805gdXVcU7QlAEf9jr9Wcv80NzCUGORGAEe+tFM7i
X-Received: by 2002:a05:600c:8b81:b0:49d:15f8:2bdb with SMTP id
 5b1f17b1804b1-49fc568125bmr178646965e9.7.1790085969364; Tue, 22 Sep 2026
 07:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-37-neelx@suse.com>
 <20260602024253.GD2295@sol>
In-Reply-To: <20260602024253.GD2295@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 22 Sep 2026 16:05:58 +0200
X-Gm-Features: AclHuK94ZowdPkv8oLMNoMqk3wQaTqmzoE8-Amh55RA3X3wy5PPxpE6ut7cEYZ4
Message-ID: <CAPjX3FdyCWLszDifMeEuT=x=QScr8K-dKsHCyD_bJOxOSQEnMw@mail.gmail.com>
Subject: Re: [PATCH v7 36/43] btrfs: deal with encrypted symlinks in send
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 04:44, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:53:10AM +0200, Daniel Vacek wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Send needs to send the decrypted value of the symlinks, handle the case
> > where the inode is encrypted and decrypt the symlink name into a buffer
> > and copy this buffer into our fs_path struct.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > No changes in v7.
> > v6 changes:
> >  * read_symlink_encrypted() reworked from using pages to using folios.
> > v5: https://lore.kernel.org/linux-btrfs/4d97f35d6f85ff041b09bed33b63446a92b7a20c.1706116485.git.josef@toxicpanda.com/
> > ---
> >  fs/btrfs/send.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 42 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index 89d72d8cb85f..d5256c22fe7a 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -1701,9 +1701,7 @@ static int find_extent_clone(struct send_ctx *sctx,
> >       return ret;
> >  }
> >
> > -static int read_symlink(struct btrfs_root *root,
> > -                     u64 ino,
> > -                     struct fs_path *dest)
> > +static int read_symlink_unencrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
> >  {
> >       int ret;
> >       BTRFS_PATH_AUTO_FREE(path);
> > @@ -1764,6 +1762,47 @@ static int read_symlink(struct btrfs_root *root,
> >       return fs_path_add_from_extent_buffer(dest, path->nodes[0], off, len);
> >  }
> >
> > +static int read_symlink_encrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
> > +{
> > +     DEFINE_DELAYED_CALL(done);
> > +     const char *buf;
> > +     struct folio *folio;
> > +     struct btrfs_inode *inode;
> > +     int ret = 0;
> > +
> > +     inode = btrfs_iget(ino, root);
> > +     if (IS_ERR(inode))
> > +             return PTR_ERR(inode);
> > +
> > +     folio = read_mapping_folio(inode->vfs_inode.i_mapping, 0, NULL);
> > +     if (IS_ERR(folio)) {
> > +             iput(&inode->vfs_inode);
> > +             return PTR_ERR(folio);
> > +     }
> > +
> > +     buf = fscrypt_get_symlink(&inode->vfs_inode, folio_address(folio),
> > +                               BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info),
> > +                               &done);
> > +     folio_put(folio);
> > +     iput(&inode->vfs_inode);
> > +
> > +     if (IS_ERR(buf))
> > +             return PTR_ERR(buf);
> > +
> > +     ret = fs_path_add(dest, buf, strlen(buf));
> > +     do_delayed_call(&done);
> > +     return ret;
> > +}
> > +
> > +
> > +static int read_symlink(struct btrfs_root *root, u64 ino,
> > +                     struct fs_path *dest)
> > +{
> > +     if (btrfs_fs_incompat(root->fs_info, ENCRYPT))
> > +             return read_symlink_encrypted(root, ino, dest);
> > +     return read_symlink_unencrypted(root, ino, dest);
> > +}
>
> This just assumes that all the symlinks on the filesystem are encrypted,
> without checking the actual encrypt flag in the inode.
>
> Of course, looking at the Sashiko review for this patch, it already
> found this, as well as a use-after-free.
>
> I don't know why I'm even reviewing this.

This is unrelated to fscrypt; it is internal to btrfs. Btrfs
encryption is experimental and under development. Not all features are
ready.
For now, btrfs send is not implemented or supported and it returns
EINVAL with an error message in the log before the code even reaches
this point. So far read_symlink() is never called on encrypted FS.
Yes, it can be improved, but it was not a priority right now.
I am really grateful for your insight as I am not familiar with all
the fscrypt internals. And don't get me wrong, for the next version
I'm also addressing the points Sashiko raised. I am sure we can all
work together to get btrfs encryption into a usable state.

--nX

> - Eric
