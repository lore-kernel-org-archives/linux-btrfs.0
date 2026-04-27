Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC88A3EC2F4
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314689; cv=pass; b=PpCwU1mYoAdlx9zTeygPf5m8MxbrLAQHjxjri9AuCZ5fagzqPmJ1K/E9JADAZ20zrM1Gnv92cGkbg+wBeStUzrify5C8XCwj2gpq6iq+JymEHUz3EHjQX+eacxjBwlVcw3UtRIe0WFV0TapD1xIAlSUVsBkkJ/YENLbEo/ez15s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314689; c=relaxed/simple;
	bh=y5vNoVjRrCeEb0mNeJ57C/lgX2jIu5b+hJdLehDSizI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k9xviuSVbV+WpojNF6GwW5XzXxWiq0XQvb6WsqYC8Di7jHBh7i5KRwc1QgGul22qb/qQplLWFVCy0O/aedu1JmpG8dJXJTpSDAuQFfJbPZ54esYfJUXFeUnlxC+1kBOTBwOU8mpV7x7fPuFn64Mrx3Su59NjT7y/pptnBquzHhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g9E8KppX; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9E8KppX"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b941762394aso1441852666b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 11:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777314686; cv=none;
        d=google.com; s=arc-20240605;
        b=LkKQbpWxvQHZpT8lW7g2Z9Y2WrhpyTQxUmT4gw47VO2BdKNDEnBXJHbArwTqy03BTV
         EyhDz2hKwTHDBbWsZYc9wJpI96AWfB3SRe5gCDVG5tBWb6xbPQBY9yi52HulwYMUvxba
         5fF4W1v5WQJYM7jhl0NIs+0dcQyWh8KbPOkBDd9p1/WvlGrvHYYryDq6kxRvnRQNP1WU
         IXzZln3fgDcgC7IzqbaGi4BftV+o7CSS5F5Mibph4Rd5gShzpQEOG48t5edwuqXtHofV
         KCjSzQVaLqlHN11hG3dJ/u+Iw5lWaizlopWMHCsDak60iaWxvUpmausPnVnn5wAI9CSB
         Bmog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        fh=vTfpoDHU5a/YJvswXFpg2Jcg4vTTWTi3eJWuezrfrcs=;
        b=GP4WmgBXX+5IaAZ+jjowGPydSvloTmbnAlRt9MpsQhBbv82A3tswHts0eyS7xnm7V8
         1yUUDy2genTQwm3bOkBT+CAUiZ2tTAUJqhTF4uXKhBW53nUTkI249rZZerWNNp2q7hOs
         rF7Jw+XUdhJehOEuLRdxwWtOpus+8LtqEiMLsDn2b/rWiT+ovHcQWODxdPEcE1lWeFvm
         6OvKb24kPbJ8ZCeQwPqCOgsE+Jy1SVAGuWUAtPlWVgUSdOmk3HpLAGKrudr2J1yPF315
         JeWvKD1awWnbZ3otsNgG54ToFTezd68xoL42dhP/qtYB8wJcl7aOZxZmyZJSJhPunW41
         1/FA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777314686; x=1777919486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        b=g9E8KppXOGP+2YshzElHjYypJOoFSumRh8nKOHEMqlQ1thu4nV8VbkX1FUeocZEA0H
         alIgwcCm4qgTvesoEIP/Sy16rr7NJuYp8L1j4fk4BFWv1Q9w7hoA3zEf47AMnf197OV7
         mCyZu/NdkRuKXUmmB96AxJwaOFp/EtbNnd54XiEC0sIRBDzG7kXvOudD/ydXUwE0fRmL
         N+HEtvs2Pq7jpHZc11C4B7cmpg4qge9oz5WZ4zAta7U+yEG7OppkAkLBlon6sOek3rVP
         fzHfkTyWMxDB8qYXnP7FBsnpcH6s5Mggz0O8+/jZgLKQRLOQbXvyhF26Dtx+xt1w3oE5
         1qPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314686; x=1777919486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        b=aRzCKpQHaAOEBjRe515ZlyM3DkSg834q0mGvXWExt+r2vbOMLOToumSmYUFnKR6cas
         RVbF2Lb0ZNWSsyKZPFUzcFOq+YJidZhwq+8CsDGjm3S8hCUyxWhugwjMpK1A8FoFU7vz
         03eAHLGWpfpcpgFynIoi8fEW8sQpflsErFuN0nGmFVc7inxSX6ur8grsNUIRzy9ao8Qq
         Lbd7U4Y+XgLnQ+Eld6+NjCRHTDKoNPJwyAjGEjLR0uCzUiVaitCqMe+Y5XoKzmvXJoKx
         7FazfCKCQvjlW8ZeYejqlrtHmGHnBxzGz4P46eS6vNzhpHUPZxP9mpYMGU4eeCxfLfZV
         VLXQ==
X-Forwarded-Encrypted: i=1; AFNElJ+GDXZeA2tB75MMxhR/DmLOc+Cyd08U7XyCohG5bXDoBqOuxD8ktCQgh0zjL2PxslQyyF4E/0YEN1ZEhA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy47tRfwTecUzXk6zW7KMLdTu9CCOT9Cb8/l+bDcMUiNf9FAyBA
	pR1IxOPJGRZWwzqKKdy+FYK6UB4B5mgkXWJ/inxyabLgCT/S8B2pKYA7EVkQ4s+45hmHGG6YLuC
	ybgXyLifiI3mra1Pi+g5sFuhnpoRymus=
X-Gm-Gg: AeBDietnmw/XU/hY8l4k1/EXAC3ar7cnWry4aNaGRBKdjsXuRYSFfxvYlshCrk9+gZN
	97nqyCylAp9xVPh+y7sB8sW06CrawEjahsuNBwAUD5QaQ6R+fZiDifBDcY0iAYECc9RsPwQUgtd
	Ax/5+TLDZF9a2Qxur8g3UVSv28NrgDipWdjbWCfjGNGVeWCzFi1Z2T5jIBFL9cUeQ6FVVEK36px
	SulS2ebtUOkeERtwYvP9FCXqgfyBgCE5EoQgs2bq/2BaG5MWurVq9ToIeEopxU8dd5wKlJDZtwy
	6HfdrrGKbK1jkx/cA10IQayi1QGuJqhknP5Uaanxct1YnniZGreV
X-Received: by 2002:a17:907:6b85:b0:ba5:391e:20f0 with SMTP id
 a640c23a62f3a-bb7fd277cffmr2751366b.42.1777314685571; Mon, 27 Apr 2026
 11:31:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777281778.git.asj@kernel.org> <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
In-Reply-To: <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 20:31:14 +0200
X-Gm-Features: AVHnY4IQzHFWkbOhQxy-O7952b296RbWBnPSd_gwXqTuhmjQtW-vYoNk5uAynBw
Message-ID: <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] fstests: add _loop_image_create_clone() helper
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 12:19=E2=80=AFPM Anand Jain <asj@kernel.org> wrote:
>
> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> image file and clone it to another image file, and attach a loop device t=
o
> them. And its destroy part.
>
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/common/rc b/common/rc
> index 9632b211b58f..0e7b7eb1d98f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1503,6 +1503,50 @@ _scratch_resvblks()
>         esac
>  }
>
> +_loop_image_create_clone()
> +{
> +       local -n _ret=3D$1
> +       local pre_clone_tune_func=3D$2
> +       local img_file=3D$TEST_DIR/${seq}.img
> +       local img_file_clone=3D$TEST_DIR/${seq}_clone.img
> +       local size=3D$(_small_fs_size_mb 128) # Smallest possible
> +       local loop_devs
> +
> +       size=3D$((size * 1024 * 1024))
> +       $XFS_IO_PROG -f -c "truncate $size" $img_file
> +
> +       loop_devs=3D$(_create_loop_device $img_file)
> +       _ret=3D($loop_devs)
> +
> +       case $FSTYP in
> +       xfs)
> +               _mkfs_dev "-s size=3D4096" $img_file
> +               ;;
> +       btrfs)
> +               _mkfs_dev $img_file
> +               ;;
> +       *)
> +               _mkfs_dev $img_file

You making a wrong assumption that FSTYP can format the loop devices

You should add _require_block_device $SCRATCH_DEV
to all your tests or maybe nicer, add:

_require_loop_mountable which requires loop and block dev fs
and use this requirement instead of just _require_loop in all tests.

Thanks,
Amir.
