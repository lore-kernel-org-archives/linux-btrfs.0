Received: from mail-lf1-f68.google.com (mail-lf1-f68.google.com [209.85.167.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186D623D2A4
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424423; cv=pass; b=aGRbkO1vGIa8T1nYqkwjY61HR+5c9vyp2pKums/PjZxBQVm2Afap3g+ayO9JryxD/pFa5y+9/Em8+fnN3DR0auTT8ahDUhtB814i1X43QxPod1LGc+dORphsMIG472XIE47F0pelQ8RPJqk02L2Pg4uSFIO3uM8C6hs/J9Qz3QQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424423; c=relaxed/simple;
	bh=h40h/uE3I3vyKbVkt+V9MnD/yQesarFdVJWJtXTsgeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D6MigEaC/FDh3g0TAwmZQITqXp+fpYc+ar9HIfJPG7w1EEjQBMwDKN5dO9MP0NUYYFGRZiKaHWngEq1JCng7QW81wzepv+vIgQtJl32YGcMVL+LE3p2iA44v2Ab3pxPHn+CBgJqti9NEE4jkb6748NoR6MVDWg7Pw3bo8dzhz7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6H+IvEx; arc=pass smtp.client-ip=209.85.167.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6H+IvEx"
Received: by mail-lf1-f68.google.com with SMTP id 2adb3069b0e04-5a8c6fc5fd3so341474e87.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778424420; cv=none;
        d=google.com; s=arc-20240605;
        b=cxGF4k+u5DZyltEm5emGb+K0WDLtqGKaG9uxlOB1DliPF8mzfeKYx149nnoTRXeNVu
         oL0wJ1SKfeESiJOYmR3Ip0vS3DuL8jAoQDIfaV4TwmJFJYTqMr149wfCex7cYzKgwGlX
         J40PdA5nAoKoWR4nJRve6TzF7KuDtbXytGMvTpWwwEtmDIZnNnft5lTZAr1+/cNA9/8H
         1GxlulYTxwHO9nibZViCjwhMDu4K4wAsQNm9ODuP3t+HJUAL4mUxDoVfjLtdZEDGXMUr
         0GNQa7dHxpEA/mtO4UyymEB4lUKWJa15joImSvA1xxxCSei6+Ci28+80s7EUROpRSGKg
         M9bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TqoMZgRLv2HnhjHwvIDSk69jPRZKx+pgDAbPaXC8/44=;
        fh=762QtiOhYH6qWN2JSWVSRWSbENY216VY9ebJ4sU8iwE=;
        b=Pgo04bp1SIlJjdF44e9pcgZ+l2JPYtgU2kFeaIb3zT4IARzNplNWK1u0tpbwubXsNt
         q16tdUP9JWKW6RVpDKW0mnCa0tYriKOMojkvdukTlLP60EZ2Tx7E4W0oV3xKWarXC4Sc
         ZpPsOQlBnWDl2HJeIZxiIoDPcqDu+HvVcaRR0doVbGXBsRk5sH/3lJ+0P14NhcSKeJRg
         HfSF3zQ/t5zLQeVEEgPyrgkaciL8aa9kUGn62wDLvgOMvO+MqzoFDZGM0XiW4Y8yOc+y
         oEpjfQgdlWdQQtxfC28p65EkKYGU0t+w1OiCJkV3M328oz94ULAXMWEdwe2fIsi33EJC
         VpYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778424420; x=1779029220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqoMZgRLv2HnhjHwvIDSk69jPRZKx+pgDAbPaXC8/44=;
        b=C6H+IvExbTeh79AJWPxjKijgBCmZQAa0zAELjebjFhRWRG7A4oPHCO+BSNSSwWNCn1
         houtCAKAVSt1LtSfrC7eJ8JpneyYEjwa5K6nw+YOykFOn69ihsLBB8EyNaAv1nZ7s75g
         ODtj1GSXwn9Di/K3um4idIQ9dhMeoiMHsyRZl8QmYy7VmP2HEGcQ6aAQ1I3q+0RoSXsZ
         9UCiznudOkM6m80SeZZPy0TzpYton9UYLIk5b4Y5U1W9Mr1CIc/3MwfmW4j9UNj1UL1d
         rNYj+nHxQiV3Q34dqvwRLbMmxQcrnE//z3BtM6ySbv07TWLKq5KVfIcGVrSNqe0cLIAj
         opkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778424420; x=1779029220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TqoMZgRLv2HnhjHwvIDSk69jPRZKx+pgDAbPaXC8/44=;
        b=dRtjiWJWMqKcv8bvhD8gejHXeeBeYA71GuGChZmu85AiQKDCQWCXF0CEuYDCMsQa8Q
         nUuhrtEIvH8oqew5qWuKMkAWpBlIHAnfvsp/tksTIb9XBf3mthJoGdAZ7j7dGSxmiEtd
         EL5FfyG4PtYcVp895kH5yZx4lmK0XQc7GgKP8dFa0WL3eCA7oc/FsPtWwxgVhbmfDijg
         Ll+rdJTqM0hxLBrAlFLGRqc5Jq9IQ3eFkEQhnSi1jkSiMxsx3I8g/h4SPe6/yyu6msf2
         HkoZWuY5Wl0U25xHhU7aPuKnM07c0+1IqxW0kz7u41GM1PiyWqzXDnQitQLtPE+Mz5fH
         HVYg==
X-Gm-Message-State: AOJu0YyMDNp1VcUSOiWN/gJM5UBvkJUwVCvMeaEqRJp2DpJ3AsjpwAQe
	6bYaVGhTXzK5rZgu0G1nPBnbTu1jGWtDc88T1b//JyJHE4xFow663NGKtQrN07Z/yce3XNLvxiy
	twv1vmv2nOhjWsmaxKOsNhO4l61ykR6U=
X-Gm-Gg: Acq92OF9kvWqQd5KCjxMRGDi3EjUu9m0Lys6eMnBazE8LayCjp8OAWBBDuyfiYViOEx
	lQ+QunjSnqhlSMBkQuS/kPhUGmTQEX68hTD0c+n3p/tGqPSrqGNPVc28Pe6/f5GcZw7ild49LIj
	0KTwe+rUD20vdkxlbLanSCt973G/HBZiV8xGEHl6m1gVlYmL85lfgacFqNTQsoHP+i9uwPGEYO0
	QgM5/gKKoc5YxoWEXCS+MpDjAs+mveuAEVmn3R+ck5aEX+tg8jzoy+VdBRE7bTNBzMR7tDC2hFE
	pRPGxi8Vg4jqZB7scr0=
X-Received: by 2002:a05:6512:39d0:b0:5a4:5d0:2892 with SMTP id
 2adb3069b0e04-5a899bbd00emr3896613e87.19.1778424420005; Sun, 10 May 2026
 07:47:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260510074943.2644335-1-rollkingzzc@gmail.com> <20260510144211.3722701-1-rollkingzzc@gmail.com>
In-Reply-To: <20260510144211.3722701-1-rollkingzzc@gmail.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Sun, 10 May 2026 22:46:47 +0800
X-Gm-Features: AVHnY4LawKNGQTz1oY5XJTHXPWvJAyvrGNce2wb0x251qEy6edLRgPGRjyk_ZxI
Message-ID: <CAB7XQsFWKoeV_SVGs+g0xAfvFPuJ4WcxC36DR_NutuGUMG1KxQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: validate root ref names in tree-checker
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>, zerocling0077@gmail.com, 
	2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm so sorry, I sent the wrong message.

Best regards,
Zhang Cen

Zhang Cen <rollkingzzc@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8810=E6=97=
=A5=E5=91=A8=E6=97=A5 22:42=E5=86=99=E9=81=93=EF=BC=9A
>
> ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
> by the subvolume name. Several readers assume that this layout is already
> valid and then use the on-disk name length directly. A corrupted item can
> therefore make those readers address bytes outside the item, and
> BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAP=
I
> name buffer.
>
> Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reade=
r
> uses them. Reject items smaller than struct btrfs_root_ref, reject record=
s
> whose name_len does not exactly describe the remaining item payload, and
> reject names longer than BTRFS_SUBVOL_NAME_MAX.
>
> For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len a=
nd
> keep a local BTRFS_VOL_NAME_MAX guard for the fixed ioctl output field.
> Terminate the copied name explicitly.
>
> Sanitizer validation reported:
> BUG: KASAN: slab-out-of-bounds in read_extent_buffer()
> Write of size 505 at addr ffff88810936d608
> Call trace:
>   dump_stack_lvl() (?:?)
>   print_address_description() (mm/kasan/report.c:373)
>   read_extent_buffer() (?:?)
>   print_report() (?:?)
>   __virt_addr_valid() (?:?)
>   srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
>   kasan_addr_to_slab() (mm/kasan/common.c:45)
>   kasan_report() (?:?)
>   kasan_check_range() (?:?)
>   __asan_memcpy() (mm/kasan/shadow.c:103)
>   btrfs_ioctl_get_subvol_info() (fs/btrfs/ioctl.c:1948)
>   btrfs_get_32() (?:?)
>   btrfs_set_16() (?:?)
>   btrfs_test_get_subvol_info_name_oob() (?:?)
>   btrfs_run_sanity_tests() (?:?)
>   init_btrfs_fs() (fs/btrfs/super.c:2690)
>   do_one_initcall() (init/main.c:1382)
>   __kasan_kmalloc() (?:?)
>   rcu_is_watching() (?:?)
>   do_initcalls() (init/main.c:1457)
>   kernel_init_freeable() (init/main.c:1674)
>   kernel_init() (init/main.c:1584)
>   ret_from_fork() (?:?)
>   __switch_to() (?:?)
>   ret_from_fork_asm() (?:?)
>   kasan_save_stack() (mm/kasan/common.c:52)
>   kasan_save_track() (mm/kasan/common.c:74)
>
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
>
> ---
> From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
> In-Reply-To: <20260510074943.2644335-1-rollkingzzc@gmail.com>
> References: <20260510074943.2644335-1-rollkingzzc@gmail.com> <qu-root-bac=
kref-20260510-161800@local>
> From: Zhang Cen <rollkingzzc@gmail.com>
> Date: Sun, 10 May 2026 17:05:00 +0800
> Subject: [PATCH v2] btrfs: validate root ref names in tree-checker
> To: Chris Mason <clm@fb.com>,
>     David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org,
>     Qu Wenruo <wqu@suse.com>,
>     zerocling0077@gmail.com,
>     2045gemini@gmail.com,
>     Zhang Cen <rollkingzzc@gmail.com>
>
> ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
> by the subvolume name. Several readers assume that this layout is already
> valid and then use the on-disk name length directly. A corrupted item can
> therefore make those readers address bytes outside the item, and
> BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAP=
I
> name buffer.
>
> Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reade=
r
> uses them. Reject items smaller than struct btrfs_root_ref, reject record=
s
> whose name_len does not exactly describe the remaining item payload, and
> reject names longer than BTRFS_SUBVOL_NAME_MAX.
>
> For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len a=
nd
> keep a local BTRFS_VOL_NAME_MAX guard for the fixed ioctl output field.
> Terminate the copied name explicitly.
>
> Sanitizer validation reported:
> BUG: KASAN: slab-out-of-bounds in read_extent_buffer()
> Write of size 505 at addr ffff88810936d608
> Call trace:
>   read_extent_buffer()
>   btrfs_ioctl_get_subvol_info()
>
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
> Changes since v1:
> - Move ROOT_REF/ROOT_BACKREF structural validation into tree-checker.
> - Validate both forward and backward root refs instead of only the ioctl =
path.
> - Keep the ioctl-side BTRFS_VOL_NAME_MAX check as a destination-buffer gu=
ard.
>
>  fs/btrfs/ioctl.c       | 17 +++++++++++++----
>  fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+), 4 deletions(-)
> diff --git aa/fs/btrfs/ioctl.c bb/fs/btrfs/ioctl.c
> index a39460bf68a7..b43d33eaea07 100644
> --- aa/fs/btrfs/ioctl.c
> +++ bb/fs/btrfs/ioctl.c
> @@ -1956,7 +1956,8 @@ static int btrfs_ioctl_get_subvol_info(struct inode=
 *inode, void __user *argp)
>         struct btrfs_root_ref *rref;
>         struct extent_buffer *leaf;
>         unsigned long item_off;
> -       unsigned long item_len;
> +       u32 item_size;
> +       u16 name_len;
>         int slot;
>         int ret =3D 0;
>
> @@ -2034,14 +2035,21 @@ static int btrfs_ioctl_get_subvol_info(struct ino=
de *inode, void __user *argp)
>                         subvol_info->parent_id =3D key.offset;
>
>                         rref =3D btrfs_item_ptr(leaf, slot, struct btrfs_=
root_ref);
> +                       item_size =3D btrfs_item_size(leaf, slot);
> +                       name_len =3D btrfs_root_ref_name_len(leaf, rref);
> +                       if (name_len > item_size - sizeof(*rref) ||
> +                           name_len > BTRFS_VOL_NAME_MAX) {
> +                               ret =3D -EUCLEAN;
> +                               goto out;
> +                       }
> +
>                         subvol_info->dirid =3D btrfs_root_ref_dirid(leaf,=
 rref);
>
> -                       item_off =3D btrfs_item_ptr_offset(leaf, slot)
> -                                       + sizeof(struct btrfs_root_ref);
> -                       item_len =3D btrfs_item_size(leaf, slot)
> -                                       - sizeof(struct btrfs_root_ref);
> +                       item_off =3D btrfs_item_ptr_offset(leaf, slot) +
> +                                  sizeof(*rref);
>                         read_extent_buffer(leaf, subvol_info->name,
> -                                          item_off, item_len);
> +                                          item_off, name_len);
> +                       subvol_info->name[name_len] =3D '\0';
>                 } else {
>                         ret =3D -ENOENT;
>                         goto out;
> diff --git aa/fs/btrfs/tree-checker.c bb/fs/btrfs/tree-checker.c
> index 1f15d0793a9c..41417b2df32d 100644
> --- aa/fs/btrfs/tree-checker.c
> +++ bb/fs/btrfs/tree-checker.c
> @@ -1371,6 +1371,38 @@ static int check_root_item(struct extent_buffer *l=
eaf, struct btrfs_key *key,
>         return 0;
>  }
>
> +static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *=
key,
> +                                 int slot)
> +{
> +       struct btrfs_root_ref *rref;
> +       u32 item_size =3D btrfs_item_size(leaf, slot);
> +       u32 name_len;
> +
> +       if (unlikely(item_size < sizeof(*rref))) {
> +               generic_err(leaf, slot,
> +                           "invalid root ref item size for key type %u, =
have %u expect >=3D %zu",
> +                           key->type, item_size, sizeof(*rref));
> +               return -EUCLEAN;
> +       }
> +
> +       rref =3D btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
> +       name_len =3D btrfs_root_ref_name_len(leaf, rref);
> +       if (unlikely(name_len > BTRFS_SUBVOL_NAME_MAX)) {
> +               generic_err(leaf, slot,
> +                           "root ref name too long for key type %u, have=
 %u max %u",
> +                           key->type, name_len, BTRFS_SUBVOL_NAME_MAX);
> +               return -EUCLEAN;
> +       }
> +       if (unlikely(item_size !=3D sizeof(*rref) + name_len)) {
> +               generic_err(leaf, slot,
> +                           "invalid root ref item size for key type %u, =
have %u expect %zu",
> +                           key->type, item_size, sizeof(*rref) + name_le=
n);
> +               return -EUCLEAN;
> +       }
> +
> +       return 0;
> +}
> +
>  __printf(3,4)
>  __cold
>  static void extent_err(const struct extent_buffer *eb, int slot,
> @@ -2226,6 +2258,10 @@ static enum btrfs_tree_block_status check_leaf_ite=
m(struct extent_buffer *leaf,
>         case BTRFS_ROOT_ITEM_KEY:
>                 ret =3D check_root_item(leaf, key, slot);
>                 break;
> +       case BTRFS_ROOT_REF_KEY:
> +       case BTRFS_ROOT_BACKREF_KEY:
> +               ret =3D check_root_ref(leaf, key, slot);
> +               break;
>         case BTRFS_EXTENT_ITEM_KEY:
>         case BTRFS_METADATA_ITEM_KEY:
>                 ret =3D check_extent_item(leaf, key, slot, prev_key);
> --
> 2.43.0
