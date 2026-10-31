Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793456299;
	b=p5mhQvWbdsHB4/pTDUWd1HrdhT7zoW/JJFZoHQMEJeYW0758UP4DZVV8opc2bZI6vJ0m
	 jMwSRFd3+cgdDT/B7xUdW2cZrgmy1fsAggyt6BZbgWbyJnoXIelr2S1vZ2qkFopejSpch
	 VIJ7/8SdEHDwvTPFyGL/Ail8a8oc8jfLdhEfIMheZNec6ZBzkvpJ9WXNuUIRrNrJ6J7ww
	 DiT+N/qTl8mqnaeOMxagpiFpcLif/d7DflTdk1EcLRk/il8pcn1tz238cUQ34L3ZuR5GK
	 az7cu9LYAKQtOw9TsDPJIbXBPUhHHTDANR/9rGC54Ay7GhSDhvtAgYpK5g061c81wIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793456299;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Patvq8zmYKObsZg0m1UZqbH1b5GBfytCkWtSbWUod8M=;
	b=a4WLFBlGdZVLzjTTP/AueKuFiMCuMdEP7QhjUmANY2ECXjwZHboE0YCJfcL8U9/6hmby
	 5yO3GvwKY3gr47Eh9oxXI2TH/Z7kf1o/dmjKoSd4SW93c/1Gdkk3qsyrMx775q3swq18D
	 /wHWAdc/qWimUX4TREg/OLLvunnWzeioYWBXh5Uwlx+Nx9eDusp5RGsUW5OdAjXxrt8/y
	 ijfzqbqP3SX5EaJ+Pz78DBEHl4fGijwcQpncZDf8kstE747JCr3QzmcJbAAXC5BwrYzBC
	 RP60Z1N36srMJ6sr+Luue+R1wtSpaFu0ljFUcnGpNYfJEv3fUqzZYMZEEhAkJxq1NWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oQSLLC1m;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD304606A31A
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 14:18:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD304606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oQSLLC1m
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso2251661a12.2
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 07:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793456297; cv=none;
        d=google.com; s=arc-20260327;
        b=TWeBJr2MCxh3FE0XOCxr1mjsOSHml3v1bu5Pbr7y7qCXYzIDOJVIhdqeDAR8nI8H5f
         Aioziwj3uINz3RGkHlWbefFn9fS8UGzNWo9St04XxS19f5mUqYHDWFSDJP1zxo/a/eQz
         lifaX9K9obXYMJhNGlJWE3MKMUDO8tT/1YQjEaiCOuktuBQ+PU+fASisYiaV6wyemqRv
         FimpcfMxODkdAnaHCAx8yu7m/1h0GqCp2Gj1CtF6lUHQz6QXu30AI7Hhv0RjIG7nG2Qt
         ffqBDMF5np1vuHO+LZvwlXXzVTx24gnM6n8ure1B7n3T4iWdLDWEY4XSvd/ktVdEJmYz
         yabw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Patvq8zmYKObsZg0m1UZqbH1b5GBfytCkWtSbWUod8M=;
        fh=7ZM4WxuIi8uB2o0c0QBCzBlNBy7A4ad3xp4Ad79mMYo=;
        b=AgYx+BVNZvaEdBrAB3/h2eBkY1wQFTp6BMZRj25QU1YjVYUSIExmXSrx16AsAhXgB8
         N+M+E99ruBAcgNhKtN66RNO4eksMyUhH5eLzWOncC3e1WNY/X8DIjMQJdOn41GhU44nh
         5syjlIToxvxBOUgF4Qby5V62/Umqy/wPzXbDD+CZCkySMt+jlo/gOIHZra8JttLvOk9i
         eknCYzytVZ/J8ZWGvlOfvAY3liCfDDh2wrAbyQh4kpcEijDhCh5ih/KyN7wjW34fjtPZ
         2Qj1AM/fOwgnn9gKMGmk3EtyGaXZGTzjpPc5cdM5qD6Pa+ys9QdEcwAppF97t06cCArs
         S8Sg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793456297; x=1794061097; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Patvq8zmYKObsZg0m1UZqbH1b5GBfytCkWtSbWUod8M=;
        b=oQSLLC1mlwpZCk0ZZrL78sZBTbXMULvV3A5VNNAB+fjwScljqC/+c8krSIy+5QkCTU
         9Aewd6oLipaVsncWBwbOzv9IQ35Sk7bSNgHjp0q9Wh0a2M5YtJgfdFZMc6J+S9HU2qBT
         uw96KgDa0g49IduaTD9SDThtQLiSC3e2cy576lxjGXvJqx2nWlAIGE5JrjKqxNWqltIC
         LeoPRHoC4Uw6ELdtd0segJT9DnVtvGhpAZ9uPZfReqwNibJQV+/ySK4LD1s+LQDGz9h0
         4nHs5O8COquJdR38IVfmn3pvv/jXZZzJuRPfYpx/9C7z2hfBjbua015UnPZLfmLZJ2Xi
         1BUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793456297; x=1794061097;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Patvq8zmYKObsZg0m1UZqbH1b5GBfytCkWtSbWUod8M=;
        b=QGAIBI34LWy/3M+6tLKXEZbDee9GhLsuA7I4UHUgFUd2ovn4MPv7rocLMoAJ7wf66Z
         xIaiZWwp3+N8PI/dCr3VGaYSgBZio4nsb0tGwXpZ8XrM5iL5l/IaTfKmAjfUPQjn28bA
         zfwLi5bKRSTn2cXDPh9cExeQqyoEOU1Cw+e4eUCcE10JFiy8d91M+yJUvvIl20WurfTZ
         Y3lfHBYG2otArbSUNLKhEAd47fWu3co9eb/kKaq9CcISzoCZlNIEUZ2knyWyh6VgUzi+
         /SkIFZ1EFQhwWzTMowECRMt3v1dtf7+X0QVHHJAz+DUFHEE4PyVYMJud3Ag3B3ZF1ZGn
         qQNw==
X-Forwarded-Encrypted: i=1; AKwUvBx2VPHRCxmTaNhAxbGLgiElg8UPH4VevJfqqY8zxLyEWzJM1PAi3atvc2+n1QOLC4iY7OcpvXD9uQcabw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLtkq1qR7nS+xDj4/C+hubZ1fV3JIRrReujxEEl9MvFmalp/Zy8
	qxpON56kzmyzEUXFaoW+se4/x48+K7bYZeaTtDxAM8DQQAteJ39HtlRj5KebtqnckLMFAK+fuEu
	/MkBPH/SPhyfFya/ei8t+mu4z/7ZDN40=
X-Gm-Gg: AYBFou2QMUD89EQ7O9O10qHD6NUdkCRDgkHLZICqRDQHQuHuXKXGO4jytWQ+g5bsxSq
	PnK9zt+AAaPl2eFQ7i5nY1z7CAnz5+8GWGyoj9c1iAi5mwH0XFSuIgZ2XKSkNNlGCHFFK6DL4dR
	09VNtue0Ys6K+D/mgOHRRkX/E1cVs59iptaKr9qF3mLMxFIOvskg+5GvJW44WEEgWHuKzDRJi5N
	hoEdCP4sKxrbQWqm/TeGa0rvisLiuJX+NXj24QK75nbdlXCh4zaILlyWvxUUYohQG+fKXzqqXQ5
	zIwCrxsbB7udFLy889zdMKmRejj2+bwfYkGcwiYrnq0rBB1IEvvY1J24n7DCMr1aatneAlQ/Opm
	P8Vi+Th2D94ZsEF4If9EUed7YIoB8tMmRueECd/k1u9vG0KH8Kc3KzlqIWbOXxuxI7RSiVg==
X-Received: by 2002:a05:6402:50a:b0:6b4:5a0c:a7fe with SMTP id
 4fb4d7f45d1cf-6b4d4c72396mr3193898a12.28.1793456297060; Sat, 31 Oct 2026
 07:18:17 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028134728.294127-1-koray.fra@gmail.com> <20261028134728.294127-2-koray.fra@gmail.com>
 <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net> <auMzpUIEmGCE_x_N@amir-ThinkPad-T480>
In-Reply-To: <auMzpUIEmGCE_x_N@amir-ThinkPad-T480>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 31 Oct 2026 15:18:05 +0100
X-Gm-Features: AclHuK_VupdwTnfkty2dMVhzMxaAc8BrZ6HJFAl7_OYvEEgnr1tOPYIrNbWdV30
Message-ID: <CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z8WdLjyQM_zA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 12:53=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Wed, Oct 28, 2026 at 02:56:39PM +0000, Pedro Falcato wrote:
> > On Wed, Oct 28, 2026 at 02:47:27PM +0100, koraynilay wrote:
> > > Add provenance time (ptime), indicating the time when a file or
> > > directory was created. This is user-settable via file_setattr() and
> > > retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> > >
> > > The semantics of when to preserve this new timestamp are the same as
> > > mtime, the idea being that there is a correspondence like this:
> > >
> > > ctime <-> btime
> > > mtime <-> ptime
> > >
> > > so every operation (copying, moving, ...) that currently preserves mt=
ime
> > > should also preserve ptime.
> > >
> > > Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> > > FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> > > xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr()=
 to
> > > allow ptime to be used with the file_setattr()/file_getattr() syscall=
s.
> >
> > Random comment, but: could this be doable with xattrs instead? I'm not =
sure
> > where I would put the xattrs code (if in userspace exclusively, or if h=
ooking
> > the VFS up with this, or if doing it on the filesystem side), but it wo=
uld
> > surely be less disruptive than modifying a bunch of filesystems one-by-=
one.
> >
> > This patch is quite simple, but changing btrfs, then ext4, xfs, etc is =
a
> > mess, and inevitably you can't get these timestamps until you upgrade y=
our
> > filesystems.
> >
>
> I disagree.
>
> I think that creation time should be a first class property in
> filesystems that support it.
>

One of the reasons that I think this API is a good match for the Windows
style creation time is that it was already discussed as an API for the
Windows style DOS attributes [1].

koraynilay,

In your next posting, I suggest that you first demonstrate how the proposed
API is used to facilitate filesystems that already support a user-settable
creation time (smb, ntfs,vfat,exfat), before adding btrfs support.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20241227121508.nofy6bho66pc5ry5@p=
ali/
