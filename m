Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793201780;
	b=N7kx0+DT2ghBgNt+esAHmC5lGdXBwghq37g3WZjxN8qYzHx9qt528pMOoWi1Zf3UiRzR
	 CYetYFz6Hu7vf4ZPDyglRF6qJDVuzfdN8mmWlrAfThp0IgXcE+VpGVAKfe6N/fWlo1X9Q
	 6L0JlBjeFVUlTE2qnFoss26P+fBHJR/DZWcmyMTemSO79Y1evkCFJ1eP1evuQ6v1Hkd69
	 tfaaGWHKX9bWwpLO4xmWrci0GoAfUtFnYorxTXMi1oyzRvIiOWKahZdH5hemZFWfFOqKL
	 wl+Ra40ogGrAbMcmge/GdppaJeQjq3ua334CgGr0XyPIdSFXoPnFzsk1aug8yq4/M6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
	b=sQ5eSLCEVsYfBsn1q6R0eg1KahbwBYzWawikuOc43t72Hz3aDETN+CGDCRjWjBBiF0Q3
	 lwO6MYLIGTjlZt4na/xD3hrKKn6A1y1DyvoiJyUPC2XeCC+s8U1ZMaxXcjV8fOe/M5Cl+
	 M/GYNFiYH9EEhCpxhf0NxCYqSwKmr71o6wyiYdEyYzNbjAW38pi6SkGa7NcSBVSrIXFxM
	 1hy3WI5OYHUsVdWF3jS4ae3p8/QSsVYTDZNt0/SCR4vtVhDX5qar6bXQD2ac/PmfDe7lU
	 HH9CZByJ6oFSI9PiFyIOWEBKOtRDWOJvzWgfgvJHoy/aDv4S40OBBOPkxgP8OxLMnlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="o8+eS/kO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8C660A2623
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 15:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA8C660A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o8+eS/kO
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso3714867a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 08:36:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201778; cv=none;
        d=google.com; s=arc-20260327;
        b=WVwV9QxB0lULhHnyT3wQEiW3KMY67A0e+3qtgjXpzr9iLAACu4uBnACEVQl3+4vCJZ
         kqhVoHx/fReZwWs5ZteQPT+71833Jp9tfg+JM30uAudS1YDZ4clgDOdyIxykorlsdiEC
         o00cZ1z+n4fg250B6IZNtxjuZbfgnu89Y37tffzoSnFBYitRhm4FCap6pO4HWsvriK2S
         UfDlchkxObAkAEKQCR5HEFI4bKbLBfHl9rD4lh3gViR9A676XZ/L4a10NeWGwqn48UrT
         laR0qKdZbUlYDK/Gy9GdlGBF5ICNZUPQq0Is4mMQvwe/JgwIMSX87FMPtNUuieAYnWdw
         ZJGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        fh=ovcSHs4vav/0mSEjPAc6Tbv5AkkDBB5MyG7DgUF59ac=;
        b=C+eEWJwQ8rQX0RFMAzJDaWbJIolQenYE//WmG0InkGZ2Ms+gXWax9dz7PVR3VliBik
         DBAsOgxFU7fquhvprHNugiXL0CunV3cdiO4LP1e7+oj9z+s7fjkROO6ovFMWyzVgz3an
         aihep8UuSNefUk99G1B0uLoMHMQRxTizDD2QLiRtJE0Hdbg5mX17Ob1+jhV3DYpoF7/v
         S12HEnn/Sf3cOFpVD6Cf9LDmXlGhIe41lqcbUKy1ZukOlrkVH6cGrmfJlLQYDj/yzJwN
         rSLaFdubsui05AnYRsBI1Jt3FWWe/UOZB6maI08MiUJVIKs81iidpmDUe9hE5gvg2+Iy
         tPtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793201778; x=1793806578; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=o8+eS/kOJnmSQQuDmyzKcnpM8XIf62WHDcQTpfgGgAc33ST6Cpvb/Avm5gCEO3G83f
         mwT5WJaRXBMVxl81EO5AaJjNxHST8plT8azYXYCCF/zkFLzRRxL39DAnbyDEtc0izQ7z
         BXoAb+hBgpOG2MczfmPvBVDGk/iwK7R5wDwXpDgw00NJCrhcdpnLJlcQCfyX7fUAE/q3
         TuCIcIAJMA+UYbeKn4XOSAztm+6f2MAyPPJZPpKrZOIFxUTkZmyPclmqG21F1aEzhplB
         iTR/S6KCchmPfCqzmnzIC7zf+BT3HW7rmx33Rm1wtRiZPxIFwLBfca6G1MEP1JTTmXMW
         ehHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201778; x=1793806578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=lKePJTejdNacZISape3VI4aBqH3Ho2C8XFcq6+RVFSylLlMsYqMNxGblP17jskYENv
         fr7dZ90TItsOKmtYMXuT14WSmOvuhMRlnidUp4FVmhjGPl1JTPaDGr2b7blJGt/zfbwf
         BXVT/7G0H+k6gN4Ci+8mDoNNSO9lJcSEZOFzVObL1BGUZP97gwN81oZ0cLtqFnFUj5qC
         0Uj4kaCg5KX4XUQZGEORfV1SDZkA9vXha/8RPMeklxCKcVPcszOxCMtEg4O5lAjl9cqy
         6EMm/QVu/DNvdaajkeLS9R7JVuF6r8ryjmO5r63C/kVfr0UT8JLHGs9VR/OSycOIf6K4
         gFZw==
X-Forwarded-Encrypted: i=1; AKwUvBxqVJ11xPkbPSQlySbIvg2zJLecl8lR71zk25OXTxcH6YgtFEfx9LKXqgTJ7Lja5qJxBL2ppoGt9zfkzg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIsCUCZNzXcsLth/VDOeLL3zfViQHy+vXGqKKfV2euFX86XAP4e
	oCbSHWPc3f3zG00kq3PMpaQyl2EVWVtfwvgVozf1mPVQvrPh0xIrQZ36RAHYhJddCVI4M6Ejw1d
	SFPlsbj3E5ul/zAlky3clNWZW8c4i/lo=
X-Gm-Gg: AYBFou24KqOp8yDTemzBq1VqP4NAcqZvCdrdQwW4Pt1se91EE9vbbar98HoyynyW59v
	OadTEMmp3V3ZhWHVpCstIr4qzsUKv2jhOJErlSIT/kSSwrZDrWI6p/yFtMTOkEo6NpgcAsfvEQW
	6CN18WKRlHVvtxPtOF5WGg6aItdmh0mbbSGrHqpd6ASBnMSjb/4VgYCf5hnrhx54CX8ilWXjxYz
	1H2nXjSLijUO8xhazKI4hn1ZJcGoDRvZfTWLs21wP1AMhYo9zq5uq0ykj9aJqoRBKgpfI1UnGQN
	zuMckesyoGFU8dpXqhTVCO7jJDVsYqNHTfnDxXkFqW67NjlzA6alYacLKE9uUsJxAjpY8ePVxs+
	NhiKovROvJIaLtmiwnzIxRtFz4K8jZjhSWT3GlZsu1BF0Ffct1TcuAEMd1M4sb1psDqTDUg==
X-Received: by 2002:aa7:d955:0:b0:6b3:b0b2:6e7 with SMTP id
 4fb4d7f45d1cf-6b47bcde687mr3518808a12.18.1793201777944; Wed, 28 Oct 2026
 08:36:17 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Oct 2026 17:36:06 +0200
X-Gm-Features: AclHuK-uy9OcEc2oh0_9o59ea-Px6xRmZClAxF9aj0taY8198qZo83-6yRUk1Js
Message-ID: <CAOQ4uxjNWagHSXM0q+3q-SwX1RRun746iSsfyoR-4fLjcqH16A@mail.gmail.com>
Subject: Re: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, 
	Carlos Maiolino <cem@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:09=E2=80=AFPM Josef Bacik <josef@toxicpanda.com>=
 wrote:
>
> sync_filesystem() writes every dirty inode of a filesystem and then calls
> ->sync_fs().  The data needs that.  Whether the metadata does depends on
> the filesystem.  ext2 copies an inode to its buffer in ->write_inode() an=
d
> nowhere else.  A filesystem which logs its metadata has recorded the
> change when it was made, and ->sync_fs() commits the log.
>
> overlayfs wants to sync what was changed through one overlay instead of
> the whole upper filesystem.  It knows which inodes it wrote data to.  It
> has a much harder time with all the inodes which the upper filesystem
> dirtied on its behalf, many of which it has no inode of its own for:
> whiteouts, index entries, work directories, the parents of all of them.
> With a filesystem which logs its metadata it doesn't have to know.
>
> Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() wit=
h
> wait set makes every change of metadata durable which was made before the
> call, whether ->write_inode() was called for the inode or not.  Timestamp=
s
> which lazytime holds back are not covered by that.  As an upper filesyste=
m
> of overlayfs it then gets ->sync_fs() instead of sync_filesystem().
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  include/linux/fs/super_types.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_type=
s.h
> index 72f4288e16c5..370b0d27815b 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
>  #define SB_I_NOIDMAP   0x00002000      /* No idmapped mounts on this sup=
erblock */
>  #define SB_I_ALLOW_HSM 0x00004000      /* Allow HSM events on this super=
block */
>  #define SB_I_NO_DATA_INTEGRITY 0x00008000 /* fs cannot guarantee data pe=
rsistence on sync */
> +#define SB_I_OVL_USE_SYNC_FS   0x00010000 /* overlayfs: ->sync_fs() comm=
its all metadata */
>


I have some reservations about the flag name (how could I not).
Not easy, but can we try the flag to describe the contract?

I am interested to know if the same flag or maybe even a more
strict contract which is fulfilled by ext4/xfs/btrfs could be
used to help determine ovl_should_sync_metadata() -

In commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up")
we added fsync on parent directories and metadata after copy up
to fix correctness on ubifs.

In commit 1f6ee9be92f8d ("ovl: make fsync after metadata copy-up
opt-in mount option") fsync=3Dstrict was created for opting-in to fsync
parent dirs on copy up, after a report on regression over ext4 when
due to the unconditional metadata fsync.

I am wondering whether fsync=3Dauto could decide regarding fsync of
metadata on copy up depending on the flag, so metadata would be
fsynced on ubifs and not fsynced on ext4.

The problem is that your flag speaks of the metadata ordering contract
of sync_fs(sb) and my interest is the metadata ordering contract of
fsync(inode).

To be more specific, in this sequence:
mkdir t1
chmod 700 t1
mv t1 A
mkdir t2
chmod 700 t2
mv t2 A/B
touch t3
chmod 600 t3
sync -d t3
mv t3 A/B/foo

When A/B/foo is observed after a crash, in xfs I know that because
all metadata writes are serialized in the single transaction, the mode
of parents is correct.

Not sure about btrfs and ext4 fast commit.

If you think that the answer is that they provide the same guaranty
then if the flag could be named something like
SB_I_ORDERED_METADATA or something and
the contract is documented, then perhaps it also fits the
sync_fs case, because what you really want to know is that
sync_fs persistent the metadata that the inode depends on.

Am I talking nonsense?

Thanks,
Amir.
