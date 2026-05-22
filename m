Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D14F360ECC
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 07:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779433261; cv=pass; b=uT07QmMIWE7RJe/K/EfcYJNN3PDRcwmVcRCL6ytfvI2pCkkvnKMwqXAsObEk3SpWkAeniMZQ3BoPBCzZ6BjV+X/FB2Rybe86BmwfKBsWRs9li7iOSJH370OvRfcKZChfpI5Vt+kA54jX/dR5UAf1bSy6IF0ZuoOjKwTfm/T13+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779433261; c=relaxed/simple;
	bh=RPLULZwyGFBcnLzO3/6uBXaB8JE/6zjrHV/JLXWUDl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NehmH6QCAgXtUU0Se0d/r1A9IQDZ1/n52kvlsciQwYzZStl9XTUVQMwwkTZZ4pEYSi+PcSxk4rJDhrEgAJToYFVS7uAiCweJLtdCzT4+yUsbOJPLrOmNlDObRs2YAg0RAOirMSXzWWMCPFX+Lq3OYIQdYFMiJaSvaCco3+dtauA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HLzHPZrA; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HLzHPZrA"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48909558b3aso70558045e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 00:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779433258; cv=none;
        d=google.com; s=arc-20240605;
        b=ctSujXshcdI2lsa6zmuEMfrdTKxeHAzePMviJAjL/RY8sT4GcyJ8lip7U9XPah/TiX
         Y9ofa+9DwOLRW+6KpoutG4uJdvtwwX2wt77bjbjJf1gOvW23ZDU/vXydPWlucgWT3Cxs
         VLwazMZ/G2QkVDjmdGrJD6kUXzH7CngkOEu2axe8FaQyYIez9UOxQdEbS3e2Ezc+ahIg
         EcVtknBNRUpa++wsBJdMrryn1NmSigpA/B++kN0uh1X/xAsTPBp4pgUOBhah1a8BcIxC
         /aHBBwUhsRBiveTUFZubzvt1iH4rfLc3TzNqkKnM9HUrV8kuKtsBVTpmCEYaG8ITCQGQ
         Damg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DgrJhf9pCLWRyhDeCL2ag+63OL5JMEGKJLqO1vcQ/ro=;
        fh=qQdEHeduv10mEVMqA+vLEs4fNd92GYyqdsLr9eUPBi4=;
        b=hOVrpfKZsZ81ansAOzQ0ra9gBR2D0Jxz+ZaKMJli3viZBjYaxpQWXaGPoLEZSRXEqN
         muvnxGgJmP/jpZR+xC+k1WD7/7ea2KRPqp4Ilud38vK88H4uJHcAManwnnLy8cHGgOXM
         KSr9YO8F8F3r0OSO+5Zmp/8B8Z22Duk+c3PD645nGpA/cfcuMFlj1o0rnlk6vA9zb7Md
         dd0HLkJlI/88V9VB6J0rA6rgw/ShzmLGBNsf08rToGM7j1YCB59a5aKy1CXqZ2FLDDR2
         hdyJCriQ4/5tjZFMMm5Tw5xnxbOdXjd12Ck6Avo3Kd79ediqSsdmZYS90E2/sBnHwCet
         GtLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779433258; x=1780038058; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DgrJhf9pCLWRyhDeCL2ag+63OL5JMEGKJLqO1vcQ/ro=;
        b=HLzHPZrA6n4uD7WqH3WLxWPD+3X9IiQxUW7HukJBPo7Mvwsojo4BP6KnY7uSUKLIWi
         opGFMqwn4+HijbCbKmiy4klL/LZdhnJVTVcybWHMz+fREl7R7fdrp7+wZ72QwznzPmx6
         jMZQMvZADyTeH4OzWGXbDbb/d4BWzVjOsHJApUlZtKXEETqJ4WWFNjczpfjgKm/GyRUv
         HN0xRFVD7oDKuUdiPVdHJjJ8pc7XT0lIGCs1bEThAlru00LEmt5w7X7A0jH9DZNVc0ga
         yax1LGmHjLJyGD24nv3bH/tJqhIfAC6dA41VqwTSPTPFP3sW0NN5McELKrCbW2VoYPe8
         v5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779433258; x=1780038058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgrJhf9pCLWRyhDeCL2ag+63OL5JMEGKJLqO1vcQ/ro=;
        b=rWE0OLKRKJGe9wJPBYTJuDsglxVGcVOPYPlBuUo1vydgE3O/AVtqo/wEOKb/GODq1f
         UkTVzu2mYTQF4lrB+0TdG1IKLR9n9CEJIpQwKQUG+W49d/phhF6fCO+Yk/jgICo1zBpY
         9HzJgao8cewVKTtYQjdz957hT2aCQpy4tXYY07kcKW+TI2kG/CczUZlQHO8ReTLqXaUf
         FoiJC2cwKsMx7dIhMq1jLcehm+ZZGNxR815VFBrZ6m8OXAIce9gfBZgExfH4vy0MycOX
         E0mlWp1kiYw+LMKJDUG8Ei393Ws9jIOBJQXEO+dPxljwPcB10iVmgjCUeCe79lFT45mY
         rFJQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Gjd7ha0RaaSVbFZxvNFTTIDwtr+L6drJKOWLQurlJ3keaQ2mLNZwf0d3DzW4Lsdn86EPfmsG40kEaew==@vger.kernel.org
X-Gm-Message-State: AOJu0YwizZzvSh+OiNTvvkFwIpdG/Q3EQEJgvQY4PfvStlW8cPJccST7
	P988QKrq/6NpqxWOh+HlwmiTaWbm5yC22X2KuVWtGcSGiWMegtUqXyRAPl02ZEJRJbrTuXsR1j1
	Afv3SHITQbeXb1E2GdcA3L0zbNzpIqqXQhx/XKfUadA==
X-Gm-Gg: Acq92OEwno6skXra2UMv+q7bEjyI1nYQfLMlxGQ+egnRwGrxoD4FVzobWK5e4cqs7D4
	HKD8xXJhkmY6DcTfxbBZdM5byDqXhrJDcXbCs00isUgC+Sq+By8ICsLN2DT+K1JhdldwJ66JnWO
	U/7IZm354wqmEyoiudynBr87HZOWrqIBwHhSAt8GBZlbMS6sfWh65F0J1CoeLSJVtK5K7hzAZl2
	sw81xravbroM8/BV2KYT8imBF+wlwn4L7iYIIQrlhll9Ph+xZr9QRpDyPFtynarEhtsqk/8/ye4
	XUEIsRxEBAkm+aZqbJnD4hxRbI5HnhwrXpG5ZO0BQnCHxiRLaUjTfgeqyEVIo/62KIhBaV3Hi/5
	Nga6cPAvykeJO4tE=
X-Received: by 2002:a05:600c:1c0b:b0:488:b187:3c with SMTP id
 5b1f17b1804b1-490426aa7acmr30260965e9.14.1779433257800; Fri, 22 May 2026
 00:00:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com>
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 22 May 2026 09:00:46 +0200
X-Gm-Features: AVHnY4KaCg2TnL5N7-_bJO4bF9ZVXcF6atGf4TwugcWam8oNLxjSD5HXNcr7eME
Message-ID: <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
To: Eric Biggers <ebiggers@kernel.org>, David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 May 2026 at 10:54, Daniel Vacek <neelx@suse.com> wrote:
>
> Hello,
>
> These are the remaining parts from former series [1] from Omar, Sweet Tea
> and Josef.  Some bits of it were split into the separate set [2] before.
>
> Notably, at this stage encryption is not supported with RAID5/6 setup
> and send is also disabled for now.
>
> For straight git access you can find this series as the `fscrypt-v7` tag
> e85358ef9fba here:
>
> [0] https://github.com/dvacek/linux-btrfs/tree/fscrypt-v7
>
> Changes since v6 [3]
>  * Rebased onto linux v7.1-rc3.
>  * Adapted to the v7.0 fscrypt API changes, mostly following commit
>    bb8e2019ad613 ("blk-crypto: handle the fallback above the block layer")
>  * Addressed all the review feedback, thanks to Eric Biggers, Chris Mason
>    (and his LLM review prompts) and Neal Gompa.
>  * Adapted to the v7.1 fscrypt API cleanups, using byte offsets as function
>    arguments instead of logical block numbers for newly introduced functions.
>    This should match https://lore.kernel.org/linux-fscrypt/20260218061531.3318130-1-hch@lst.de/
>    As a result btrfs_set_bio_crypt_ctx_from_extent() and btrfs_mergeable_encrypted_bio()
>    helpers were no longer needed and they got removed.

Hi Eric,

This is just a gentle ping.
I was wondering if you had a chance to look at this version?
I believe all your previous feedback has been addressed and this
version is solid.
Please, let me know your thoughts.

Regards,
Daniel

> There are a few changes since v5 [1]:
>  * Rebased to btrfs/for-next branch.  Couple things changed in the last
>    years.  A few patches were dropped as the code cleaned up or refactored.
>    More details in the patches themselves.
>  * As suggested by Qu and Dave, the on-disk format of storing the extent
>    encryption context was re-designed.  Now, a new tree item with dedicated
>    key is inserted instead of extending the file extent item.  As a result
>    a special care needs to be taken when removing the encrypted extents
>    to also remove the related encryption context item.
>  * Fixed bugs found during testing.
>
> Have a nice day,
> Daniel
>
> [1] v5 https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/
> [2]    https://lore.kernel.org/linux-btrfs/20251112193611.2536093-1-neelx@suse.com/
> [3] v6 https://lore.kernel.org/linux-btrfs/20260206182336.1397715-1-neelx@suse.com/
>
> Josef Bacik (33):
>   fscrypt: add per-extent encryption support
>   fscrypt: allow inline encryption for extent based encryption
>   fscrypt: add a __fscrypt_file_open helper
>   fscrypt: conditionally don't wipe mk secret until the last active user
>     is done
>   blk-crypto: add a process bio callback
>   fscrypt: add a process_bio hook to fscrypt_operations
>   fscrypt: add documentation about extent encryption
>   btrfs: add infrastructure for safe em freeing
>   btrfs: select encryption dependencies if FS_ENCRYPTION
>   btrfs: add fscrypt_info and encryption_type to ordered_extent
>   btrfs: plumb through setting the fscrypt_info for ordered extents
>   btrfs: populate the ordered_extent with the fscrypt context
>   btrfs: keep track of fscrypt info and orig_start for dio reads
>   btrfs: add extent encryption context tree item type
>   btrfs: pass through fscrypt_extent_info to the file extent helpers
>   btrfs: implement the fscrypt extent encryption hooks
>   btrfs: setup fscrypt_extent_info for new extents
>   btrfs: populate ordered_extent with the orig offset
>   btrfs: set the bio fscrypt context when applicable
>   btrfs: add a bio argument to btrfs_csum_one_bio
>   btrfs: limit encrypted writes to 256 segments
>   btrfs: implement process_bio cb for fscrypt
>   btrfs: implement read repair for encryption
>   btrfs: add test_dummy_encryption support
>   btrfs: make btrfs_ref_to_path handle encrypted filenames
>   btrfs: deal with encrypted symlinks in send
>   btrfs: decrypt file names for send
>   btrfs: load the inode context before sending writes
>   btrfs: set the appropriate free space settings in reconfigure
>   btrfs: support encryption with log replay
>   btrfs: disable auto defrag on encrypted files
>   btrfs: disable encryption on RAID5/6
>   btrfs: disable send if we have encryption enabled
>
> Omar Sandoval (6):
>   fscrypt: expose fscrypt_nokey_name
>   btrfs: start using fscrypt hooks
>   btrfs: add inode encryption contexts
>   btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
>   btrfs: adapt readdir for encrypted and nokey names
>   btrfs: implement fscrypt ioctls
>
> Sweet Tea Dorminy (4):
>   btrfs: handle nokey names
>   btrfs: add get_devices hook for fscrypt
>   btrfs: set file extent encryption excplicitly
>   btrfs: add fscrypt_info and encryption_type to extent_map
>
>  Documentation/filesystems/fscrypt.rst |  41 +++
>  block/blk-crypto-fallback.c           |  41 +++
>  block/blk-crypto-internal.h           |   8 +
>  block/blk-crypto-profile.c            |   2 +
>  block/blk-crypto.c                    |   6 +-
>  fs/btrfs/Kconfig                      |   4 +
>  fs/btrfs/Makefile                     |   1 +
>  fs/btrfs/accessors.h                  |   2 +
>  fs/btrfs/backref.c                    |  43 ++-
>  fs/btrfs/bio.c                        | 155 +++++++++-
>  fs/btrfs/bio.h                        |  14 +-
>  fs/btrfs/btrfs_inode.h                |   7 +-
>  fs/btrfs/compression.c                |   6 +
>  fs/btrfs/ctree.h                      |   3 +
>  fs/btrfs/defrag.c                     |  14 +
>  fs/btrfs/delayed-inode.c              |  25 +-
>  fs/btrfs/delayed-inode.h              |   5 +-
>  fs/btrfs/dir-item.c                   | 110 ++++++-
>  fs/btrfs/dir-item.h                   |  10 +-
>  fs/btrfs/direct-io.c                  |  28 +-
>  fs/btrfs/disk-io.c                    |   3 +-
>  fs/btrfs/extent_io.c                  | 115 ++++++-
>  fs/btrfs/extent_io.h                  |   3 +
>  fs/btrfs/extent_map.c                 | 102 ++++++-
>  fs/btrfs/extent_map.h                 |  26 ++
>  fs/btrfs/file-item.c                  |  28 +-
>  fs/btrfs/file-item.h                  |   2 +-
>  fs/btrfs/file.c                       |  79 +++++
>  fs/btrfs/fs.h                         |   6 +-
>  fs/btrfs/fscrypt.c                    | 413 ++++++++++++++++++++++++++
>  fs/btrfs/fscrypt.h                    |  86 ++++++
>  fs/btrfs/inode.c                      | 404 +++++++++++++++++++------
>  fs/btrfs/ioctl.c                      |  41 ++-
>  fs/btrfs/ordered-data.c               |  35 ++-
>  fs/btrfs/ordered-data.h               |  14 +
>  fs/btrfs/reflink.c                    |  43 ++-
>  fs/btrfs/root-tree.c                  |   9 +-
>  fs/btrfs/root-tree.h                  |   2 +-
>  fs/btrfs/send.c                       | 134 ++++++++-
>  fs/btrfs/super.c                      |  99 +++++-
>  fs/btrfs/super.h                      |   3 +-
>  fs/btrfs/sysfs.c                      |   6 +
>  fs/btrfs/tree-checker.c               |  64 +++-
>  fs/btrfs/tree-log.c                   |  34 ++-
>  fs/btrfs/volumes.c                    |   5 +
>  fs/crypto/crypto.c                    |  10 +-
>  fs/crypto/fname.c                     |  36 ---
>  fs/crypto/fscrypt_private.h           |  51 +++-
>  fs/crypto/hooks.c                     |  38 ++-
>  fs/crypto/inline_crypt.c              |  91 +++++-
>  fs/crypto/keyring.c                   |  18 +-
>  fs/crypto/keysetup.c                  | 164 ++++++++++
>  fs/crypto/policy.c                    |  47 +++
>  include/linux/blk-crypto.h            |  15 +-
>  include/linux/fscrypt.h               | 127 ++++++++
>  include/uapi/linux/btrfs.h            |   1 +
>  include/uapi/linux/btrfs_tree.h       |  26 +-
>  57 files changed, 2665 insertions(+), 240 deletions(-)
>  create mode 100644 fs/btrfs/fscrypt.c
>  create mode 100644 fs/btrfs/fscrypt.h
>
> --
> 2.53.0
>
