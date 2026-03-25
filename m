Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723533D523E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452444; cv=pass; b=nbaQ2lKiC62Of4vxffW5LG/fZMDJ6pN+LLlnR/2d649FE6EUgOCSGYkUlMqW/O19hN3mY58XBitRSTOm8NY1H9koJEgguADcIc6IW1n07ZtXL7cBrzwfHXLOtkj+hKrBf58fsppWxHmA9GiffPocHGCMbSF0ZNDKRUp6sli15I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452444; c=relaxed/simple;
	bh=gvTYV6danPBvrbbKycCsMx9z3+3xksJLdC9fppoaH9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ASIJkr93bahNB1Cn/X9knlol29G6FmwdKBnP2znkW4n3nFUg/DHkzOxNeafw9DPhwBkVCaTwxbsGmZOBlaW8qUeEw7wGEMes+yyGkVXI24lKHK9MJKHoJkxUp1l0GOa+sT/b/o4gvU09rQOI12EPjTsViAyzFSLKrwK0AcjIWrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AEXc+gia; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AEXc+gia"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b4915161fso4998191f8f.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 08:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774452441; cv=none;
        d=google.com; s=arc-20240605;
        b=N7497CrgfRMNFEe9nZugJCv2MFp1Tw9Cu+LxI9tgsSC9xRYn7KmLKBfqbkhSV1QH9i
         Y6VP8Ej6QXuWABSrU98OSJMoeizpqZRec7G6t4JDgxo/JyVcvQSgeebkuDfG7RxPFrVQ
         YC8JG2iYqaruF9eHds3fa+Nc3fMa4j9LovRhLN6T+ZpP9x58QHjZ2OugDLIMK+nDlx/H
         l5IraNa0orcxhSEdzq6TI7Aa71em1suoI+ciFYPEEByS4/JGXbFFkp666jPcKJ/Bq7kp
         2WXKuzhWsB1aXiogXDlW4d1nnEyqJgssMzv2gu0dzisBV7rRR0vTollXwyv9rPMME866
         UuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dWX1QioYHvYuj0Wi+UEogcC2o0+HVIkdhxi+oA65LkU=;
        fh=0mHG8dCXc/aMaegBZeI8Gf99mkHYa7iKY8WHYVAMHZI=;
        b=N8VPlfGTBGoYI4MjiFGROyVr7zQ01hN7kzG4abbPI5Bbg0Wa1xrR7oXkwXIvr6sGA8
         5sGUlRqT/tVBNB38mYyqFCTkEwfVk/5dDGrObfNrdkpA+n+SLd1rhfP3f7a7Gmf+om5/
         UK9nYUVzDChpTS93anUoRI7QBwM0wNIbcSEt9UNJTjdYmTIKipdbHLGnuH0IQkQY/TIQ
         IaMQybP/scyanRP61JI5MpfSoxYrgmJxYiGCiUDy4AFwqrWWnDisYIeIXXX1s1SunDcV
         O1+MX07tikGefoFbusQA75aeFT3tWJVDdEwZ6MKc2OBZ/XSpldfcqP8SqbZUpHdmVad9
         0kvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774452441; x=1775057241; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dWX1QioYHvYuj0Wi+UEogcC2o0+HVIkdhxi+oA65LkU=;
        b=AEXc+gia4X2WLrsXhq+ccPCtrdadkzFqLhLeTTsWZF8bpUj/GXTEskGg0mLZrNfkSQ
         JTxIxfwUUtVmEkTp+p/XdRf4aBQHw4dLLa7VD9I+xhqdI8OMhDNA6wRxa+ihrFtfAyeU
         tsW4DPcoTLmEdeMUtBlR6SaGNeaW0rFq2MG8tLlXqM2mwX17jVnCDc0bXFg/KuXzAstc
         lDQGzmI36TJyyp1W0K3qOmq3HkVkfhOIlLfaN4I1aGCQ7IPpZ+bLP61gGiUgEPMVEpgB
         41VZEns+2sSHjOjGbE+ZpQgSW5dSlgsqz/N3j1WAUMrxdtUqMh93KP/qMfB/7yZnyn/Y
         cLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774452441; x=1775057241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dWX1QioYHvYuj0Wi+UEogcC2o0+HVIkdhxi+oA65LkU=;
        b=eEyiJWObZsjIvqafBABOPtJtF0ii3hYb0DLfwkxaDu1zUXgRkxZvdBqC6tpj8lhkz2
         sOIb7vvYjHOWYOYGVaOFY4wLXJAnaUBd115wrgGZpbHU6njBOme3vfMwQPIWwOgwNrwW
         HFLrQn4o6y1xW14pDNSaaR7mmb/FHvilZXRP9r0y+xC4lO0Hg7Vq+C3lwr9tAkKY0m63
         kY9Rg0jC7c7ps0TSkilqTWrkveU6N00ekYkALgNO+OwEDH9JlsCRUPoIw+NadI9zuuUj
         5dEVfs0kQymiGXKiR8teSBDoy7vCrkHyHXpDnmR4OHaHXQAv8S14HlTT7t9QAVEqas/C
         gfMA==
X-Forwarded-Encrypted: i=1; AJvYcCUDS40rgca3to6rG7V5+KwUCNR1sMbJwaKkM+uEITtoE/ZD/JTZmHnmt35ZHDWMsRKL0PVwGxlSKYs1zg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5Idv3IOABmUfodJ6ZmnBR9ds6Z1t+Xz6qGNAz1Mg/hYko4LZd
	nNHJDuhDrvy/4YP2Qq89cmslpjbjEnv5G43w/09Nu3uXRVbIRXvPrTPgusSQyV7UcGKyikbf4rk
	U1k4z0WkJJVTIYmTMItZRdwoZrLuvUe8SbU9oyz1EyA==
X-Gm-Gg: ATEYQzwC9LW/GZ7AuJgDhu8fwKtcsfY+mcCwNsrT4S7K8AFXf+H8XvN5PjJKYAuNjm5
	MJGY35FLRJBT6rTG0awFW1ua+9bQ6yPHQoQojkXftNCH7f9YR693TlLneQunZwZVNUR8ZuHpe2b
	XWX6tRZvBr5Ly5zVDgzRPW1w4OrDRkUVgarxk9lA6wtMdT2Y2crcMSFx8sQ29DAOTrVnhShjNhw
	EkKQwsnkIj9lFL/Ekr4W6cDIBaoU4D1MWjmLxIU03ufxgl0gF7qw8vi16fLAoQR6YMrolcHzqBY
	EihuxDd1mvN8atu9Kbj1ae+Ee2AGmR38K0RWl6lDkXR4R8TxB4eodCpp8mA29P+RKnZ7o7mIltu
	J+12d
X-Received: by 2002:a5d:5f92:0:b0:43b:47bc:c147 with SMTP id
 ffacd0b85a97d-43b88a1d79emr5535228f8f.45.1774452440680; Wed, 25 Mar 2026
 08:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-36-neelx@suse.com>
 <20260208150339.3021113-1-clm@meta.com>
In-Reply-To: <20260208150339.3021113-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 25 Mar 2026 16:27:09 +0100
X-Gm-Features: AQROBzAFWXwvrixpcNfzyjbXsLbgIekQDOVglJXPaG63xqqZ-H6T96gnhiEXVX4
Message-ID: <CAPjX3Ffn_Q1mPs3-6ZpdOTrp6i=2c8ZiJSyR9Mu_MTe_=OQjnA@mail.gmail.com>
Subject: Re: [PATCH v6 35/43] btrfs: make btrfs_ref_to_path handle encrypted filenames
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 8 Feb 2026 at 16:04, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We use this helper for inode-resolve and path resolution in send, so
> > update this helper to properly decrypt any encrypted names it finds.
> >
>
> Hi everyone,
>
> I'm running the btrfs for-next branch, along with the encryption patch set
> through my AI review prompts:
>
> https://github.com/masoncl/review-prompts
>
> I'm working on some btrfs specific instructions, but hopefully these reviews
> are already useful.  I've kept the headers to make it easier to double check
> that I'm actually replying to the right email, but please let me know if any
> parts of this are incorrect:
>
>
> commit 473bbb12052f731a4e2ce3c48e7d7e9f2510528b
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: make btrfs_ref_to_path handle encrypted filenames
>
> This commit updates btrfs_ref_to_path() to handle encrypted filenames by
> introducing a new copy_resolved_iref_to_buf() helper that can decrypt
> names when the filesystem has encryption enabled.
>
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 9bb406f7dd302..577c3ef87791a 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
>
> [ ... ]
>
> > @@ -2107,6 +2108,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> >       return ret;
> >  }
> >
> > +static int copy_resolved_iref_to_buf(struct btrfs_root *fs_root,
> > +                                  struct extent_buffer *eb, char *dest,
> > +                                  u64 parent, unsigned long name_off,
> > +                                  u32 name_len, s64 *bytes_left)
> > +{
> > +     struct btrfs_fs_info *fs_info = fs_root->fs_info;
> > +     struct fscrypt_str fname = FSTR_INIT(NULL, 0);
> > +     int ret;
> > +
> > +     /* No encryption, just copy the name in. */
> > +     if (!btrfs_fs_incompat(fs_info, ENCRYPT)) {
> > +             *bytes_left -= name_len;
> > +             if (*bytes_left >= 0)
> > +                     read_extent_buffer(eb, dest + *bytes_left, name_off, name_len);
> > +             return 0;
> > +     }
> > +
> > +     ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = btrfs_decrypt_name(fs_root, eb, name_off, name_len, parent, &fname);
> > +     if (ret)
> > +             goto out;
> > +
> > +     *bytes_left -= fname.len;
> > +     if (*bytes_left >= 0)
> > +             memcpy(dest + *bytes_left, fname.name, fname.len);
> > +out:
> > +     fscrypt_fname_free_buffer(&fname);
> > +     return ret;
> > +}
> > +
> >  /*
> >   * this iterates to turn a name (from iref/extref) into a full filesystem path.
> >   * Elements of the path are separated by '/' and the path is guaranteed to be
> > @@ -2138,10 +2172,10 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> >               dest[bytes_left] = '\0';
> >
> >       while (1) {
> > -             bytes_left -= name_len;
> > -             if (bytes_left >= 0)
> > -                     read_extent_buffer(eb, dest + bytes_left,
> > -                                        name_off, name_len);
> > +             ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
> > +                                             name_off, name_len, &bytes_left);
> > +             if (ret)
> > +                     break;
> >               if (eb != eb_in) {
> >                       if (!path->skip_locking)
> >                               btrfs_tree_read_unlock(eb);
>
> Does this code leak the extent buffer when copy_resolved_iref_to_buf()
> fails? Looking at the loop structure in btrfs_ref_to_path(), when
> copy_resolved_iref_to_buf() returns an error and we break at line 2178,
> the cleanup code that follows never executes:
>
>     if (eb != eb_in) {
>         if (!path->skip_locking)
>             btrfs_tree_read_unlock(eb);
>         free_extent_buffer(eb);
>     }
>
> This can happen in subsequent iterations where eb != eb_in (the extent
> buffer was detached from path->nodes[0] and set to NULL in the previous
> iteration). The cleanup at the end of the function (btrfs_release_path()
> at line 2216) cannot free eb since it's no longer in the path.

Right, the break should be placed only after the cleanup.

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2174,13 +2174,14 @@ char *btrfs_ref_to_path(struct btrfs_root
*fs_root, struct btrfs_path *path,
     while (1) {
         ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
                         name_off, name_len, &bytes_left);
-        if (ret)
-            break;
         if (eb != eb_in) {
             if (!path->skip_locking)
                 btrfs_tree_read_unlock(eb);
             free_extent_buffer(eb);
         }
+        if (ret)
+            break;
+
         ret = btrfs_find_item(fs_root, path, parent, 0,
                 BTRFS_INODE_REF_KEY, &found_key);
         if (ret > 0)

Thanks.

--nX

> This could be triggered when decryption fails in copy_resolved_iref_to_buf()
> due to btrfs_iget() error, fscrypt_fname_alloc_buffer() ENOMEM, or
> fscrypt_prepare_readdir() failure on an encrypted filesystem.
>
> Before this patch, the name copy operation (read_extent_buffer) could not
> fail, so the cleanup always happened before any error check.
>

On Sun, 8 Feb 2026 at 16:04, Chris Mason <clm@meta.com> wrote:
>
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We use this helper for inode-resolve and path resolution in send, so
> > update this helper to properly decrypt any encrypted names it finds.
> >
>
> Hi everyone,
>
> I'm running the btrfs for-next branch, along with the encryption patch set
> through my AI review prompts:
>
> https://github.com/masoncl/review-prompts
>
> I'm working on some btrfs specific instructions, but hopefully these reviews
> are already useful.  I've kept the headers to make it easier to double check
> that I'm actually replying to the right email, but please let me know if any
> parts of this are incorrect:
>
>
> commit 473bbb12052f731a4e2ce3c48e7d7e9f2510528b
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: make btrfs_ref_to_path handle encrypted filenames
>
> This commit updates btrfs_ref_to_path() to handle encrypted filenames by
> introducing a new copy_resolved_iref_to_buf() helper that can decrypt
> names when the filesystem has encryption enabled.
>
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 9bb406f7dd302..577c3ef87791a 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
>
> [ ... ]
>
> > @@ -2107,6 +2108,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> >       return ret;
> >  }
> >
> > +static int copy_resolved_iref_to_buf(struct btrfs_root *fs_root,
> > +                                  struct extent_buffer *eb, char *dest,
> > +                                  u64 parent, unsigned long name_off,
> > +                                  u32 name_len, s64 *bytes_left)
> > +{
> > +     struct btrfs_fs_info *fs_info = fs_root->fs_info;
> > +     struct fscrypt_str fname = FSTR_INIT(NULL, 0);
> > +     int ret;
> > +
> > +     /* No encryption, just copy the name in. */
> > +     if (!btrfs_fs_incompat(fs_info, ENCRYPT)) {
> > +             *bytes_left -= name_len;
> > +             if (*bytes_left >= 0)
> > +                     read_extent_buffer(eb, dest + *bytes_left, name_off, name_len);
> > +             return 0;
> > +     }
> > +
> > +     ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = btrfs_decrypt_name(fs_root, eb, name_off, name_len, parent, &fname);
> > +     if (ret)
> > +             goto out;
> > +
> > +     *bytes_left -= fname.len;
> > +     if (*bytes_left >= 0)
> > +             memcpy(dest + *bytes_left, fname.name, fname.len);
> > +out:
> > +     fscrypt_fname_free_buffer(&fname);
> > +     return ret;
> > +}
> > +
> >  /*
> >   * this iterates to turn a name (from iref/extref) into a full filesystem path.
> >   * Elements of the path are separated by '/' and the path is guaranteed to be
> > @@ -2138,10 +2172,10 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> >               dest[bytes_left] = '\0';
> >
> >       while (1) {
> > -             bytes_left -= name_len;
> > -             if (bytes_left >= 0)
> > -                     read_extent_buffer(eb, dest + bytes_left,
> > -                                        name_off, name_len);
> > +             ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
> > +                                             name_off, name_len, &bytes_left);
> > +             if (ret)
> > +                     break;
> >               if (eb != eb_in) {
> >                       if (!path->skip_locking)
> >                               btrfs_tree_read_unlock(eb);
>
> Does this code leak the extent buffer when copy_resolved_iref_to_buf()
> fails? Looking at the loop structure in btrfs_ref_to_path(), when
> copy_resolved_iref_to_buf() returns an error and we break at line 2178,
> the cleanup code that follows never executes:
>
>     if (eb != eb_in) {
>         if (!path->skip_locking)
>             btrfs_tree_read_unlock(eb);
>         free_extent_buffer(eb);
>     }
>
> This can happen in subsequent iterations where eb != eb_in (the extent
> buffer was detached from path->nodes[0] and set to NULL in the previous
> iteration). The cleanup at the end of the function (btrfs_release_path()
> at line 2216) cannot free eb since it's no longer in the path.
>
> This could be triggered when decryption fails in copy_resolved_iref_to_buf()
> due to btrfs_iget() error, fscrypt_fname_alloc_buffer() ENOMEM, or
> fscrypt_prepare_readdir() failure on an encrypted filesystem.
>
> Before this patch, the name copy operation (read_extent_buffer) could not
> fail, so the cleanup always happened before any error check.
>
