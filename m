Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793179233;
	b=C+DbKg4jMX2ASwfqX88tR5XrrzJF2Qs8D9g0E3XRU7IkKZU7rd3aaXm55aJxehp8kbYO
	 eLkV4evhxT11KYk6stLsCBKq7qErfi/JdDTlL99IQNuuSF09w5AHrON3zfGtV6q9NjHbV
	 4QazcAEtTTiROZUZ2imEedIFBhkZkxwprjEWc7RLDaalT8ihdPQxlwk7ysWAaQNcwQbEE
	 pbFhv5ketlu7WggA5pe1UttIoA87B0NEpneH4m2bAHNs5Tbq1jpSSWhYBKxN0ZxsytGV2
	 TfJCEdLX+/Kp/fargn5hRGx998DIY0xMXzHKTQe94N7BA4RgHwhpygWEHp6ZWEhe/5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793179233;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eh6BZCEmCk1ZVXixUmTLxWjuWCHZJ05b87AiZULAR6Q=;
	b=szY+2z0Rt+dZ7iX5eGOOmA9hqh4UufIbCOOd5L+iIo6yI3uIBSr2RrnIAdbv0RNoXD0N
	 X6pAncHK6XQ+sbDKVCZjSNmOpOSvcLIb5dz/iZE4lQCEYTdbQFgDZ9Fq4r2Ok5sONH7QR
	 ujO6swlOQTmg3DQ88XmZGveLMtnv00BXNmOaVNQcVZiwtwVWeInxaV01mIIR39uL3gIKc
	 0atxY8FAwJPFVUjcujV6khLjiEser2n4tGZq8bgcrboMnpkUsN0W36rP5a9siYDk41jb6
	 EP1qkjLxV0GlQjQVwdqjApcLgH5kmB3QVuvfpR+KwQypjkV9RbDKIBDzgnWCh0/0ijg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i8fLVYCC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.47
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21243606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 09:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21243606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i8fLVYCC
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-676858d42f8so706809d50.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 02:20:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793179231; cv=none;
        d=google.com; s=arc-20260327;
        b=mFn9QTf3yhoaDKZ9mnA4tBSmQDrtIfaxBqWskHEYtlRAzFydk8HWq0cJaP1n7YUQsX
         /Lkc2rxawKwsOCLPhZiqzcDKIE1LOuWTqpW8+oYdN+fiSAnNxb2g01tda3u9S7JFETOu
         Ekrq5QWHNIpONJehGGmR3cvJuiQJQj08zkwdmipLrkJyTNYzJKAwEyFU8Ky89kMIcNhl
         SDjE5g/0IU5Kd13R2s1oByrbYT1BPSHOXGTc3wYUkreXt52O28kgZMI7qEmyDVnj7++1
         /4HJW87yizuefFKVWyQbROLsg0KerOzCEHb0rAdm7OtTp/pzHC7cXe/vgYFd+Fjb2Lan
         mMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eh6BZCEmCk1ZVXixUmTLxWjuWCHZJ05b87AiZULAR6Q=;
        fh=OXapv6S4Dk67TcWuGvT9GexqXO+5nGyPGrdA8Jdv/x0=;
        b=DvgeIEiATqBOIxGcb9rLjlPjD0H7zB/9HpuimCWY3ZIPIRd3lHXgUjVTZSNHNFPi+u
         KkpoxILJCYdhT/eQwv3Y8mmXweFt63EHIb9ntbN2o6TnVfDAT5bWa16O2WEF+DHdPSS4
         uOkv/jOUaRxefdhDtkA1fwWZF50AXM8z62TiibIWw0umnRNWtRIpxSmSkO0+q68N/h3Z
         0noeyeWGYOXZTGi90u9A27DA3FsUd+wXlxip2ttTidrH786SU0Z7+BNqYjQbGjhQwsUi
         lEo3ECEIKG4rl2+2T1ZX88F0F0G1+qzVVftBrdqns7BKx1SJ/EnFueyqwEtrRqfvM3AH
         JOVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793179231; x=1793784031; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eh6BZCEmCk1ZVXixUmTLxWjuWCHZJ05b87AiZULAR6Q=;
        b=i8fLVYCCaKVOh3SPBcNbSk5j5GMBi7RlNKGoB2Z5YPH2wnHVnEZH6bWddEIROEAB8E
         loCXxuaQFIQBR6QUMECQJb3TiLNJQqXdNFoEKUxGzcot0G5CCtftxpdd5I8FYdujSoi1
         jwksECoM0od3XqduRIrXcWZdclQ89sq4uQziHicxCs5+gk28AxXXA3+CURVselzQJsFB
         ZKPCN7Pdw+PHNJE5fv/7eCWop6U/Cu7OkPu9B3svqB60KwvLw64bx9HCLKlj6+Yr6l/E
         I0lMvDVCh3SiY8mKrxtRrMDgmKjcn5AudGHuBh1eqR1a9cl+yC0IrW4vX9/f22ivfskZ
         Kj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793179231; x=1793784031;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eh6BZCEmCk1ZVXixUmTLxWjuWCHZJ05b87AiZULAR6Q=;
        b=WGEtya12WRuLsuONQp2CFmdznNhbajeCms9BcmDIsIdTm6nlkID0R+Sze10qMen4jb
         oLZ7hxshwtQK9U5RPqu26Do698zaiA3wY/7Ra410IDaIrqNsqJ4rxexhEpVUA2yHHfLq
         ddD49z1WXv1RZS3sOdG7Pr6Pnr6YmpIdmzDNYtvZXX1CpcPtr4sORQQmOhmOaFx0M+pI
         fW2un0dF+++pxjKXQxMeFWIaQtkRU27S4V1EiNGG4weK57UBVIRe2D4MEh4+Mr7tRkrA
         XMk8IIgKLT+zr+pC+a5Q6jc3ER8Mr6BXBi6KXQY4rllZO1hrZzCpRy635R0MrmOybHlu
         JI5A==
X-Forwarded-Encrypted: i=1; AKwUvBy4cbVBzng2vCROXMJxkTNqJJMBFwZOW3CPv2aq52OLdGh8e0M4sftm9Ovg3D5e3xoxzw/fw38ObgrzfQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLO5y9Svksd9BSwGXPP2bLdGzKpFhwc4i6t+LYG9kqaeFZZM9yA
	pj92RV/y7btf9xM0HezTR/k6gCZ5BhZtQYLQ0Zf9InKN6asnhLpyjsbe9IaMBx7d/2F+q5K7VCV
	5eav/F3sSuUCoj2XIWo5TZN46zArBtUA0Lie8yfSEEioE
X-Gm-Gg: AYBFou2P0dQsfeEWYa+qegXGSeQHtAn0QZjgwiW33piETBjN45bW2qqeC+bzjOp5WO+
	x2EzsETOGBfpe9Rn5wD1Uy1259jCQ/ctIpKJK3sdx+QeZ2GA2096plrl0RHTQOQnQ0zBuRGsOkd
	Epp3X36A8RLPHqymqQ2tE+ctDSip43YcokpNwntCXXTm/f+aknkf59ezdvDWrLXTqYZC81vO2HW
	sqJ1ymMwcQ5i8kTsUZ/VQNHbVsExY8yL6DhYqR0qqbGycUwjzv58XLShjqMMmLuk+PNqOsIkw85
	C1ZVqyPJiH5v82SbpSeaiNwIRyErgyNmG/OwAWksDHqj+hxC217+B9wZG+jyZ2RDFeCkMe0u2ga
	raIwn99kzGLGp3Aj8+0XbhzcCaU/Y7tb3tAM=
X-Received: by 2002:a05:690e:448:b0:679:992e:3ac4 with SMTP id
 956f58d0204a3-67a7bd59ce2mr983590d50.150.1793179230888; Wed, 28 Oct 2026
 02:20:30 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
 <CAO0HQ0UE5BtevPHHfV9mQo5HoqzxzDDjAkj9e=pD_0AaXmSYFQ@mail.gmail.com> <65fd2260-78e1-4521-9df1-b042788ae7bc@suse.com>
In-Reply-To: <65fd2260-78e1-4521-9df1-b042788ae7bc@suse.com>
From: Luca Stefani <luca.stefani.ge1@gmail.com>
Date: Wed, 28 Oct 2026 10:20:18 +0100
X-Gm-Features: AclHuK9-DzQDAG9TREsG2UeosGG7kD222ce8lEWGULjSuRCq72uxpwj0uMq-JIo
Message-ID: <CAO0HQ0W3rALzPX59mVONjDtK1otyS8bo6_hGG6og3qwyLepmnA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
To: Qu Wenruo <wqu@suse.com>
Cc: zhiwei.liang@zliang.me, David Sterba <dsterba@suse.com>, 
	Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>, Robbie Ko <robbieko@synology.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Oct 2026 at 09:57, Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/10/28 19:21, Luca Stefani =E5=86=99=E9=81=93:
> > On Wed, 28 Oct 2026 at 07:57, Zhiwei Liang via B4 Relay
> > <devnull+zhiwei.liang.zliang.me@kernel.org> wrote:
> >>
> >> From: Zhiwei Liang <zhiwei.liang@zliang.me>
> >>
> >> When a suspend starts during FITRIM, fstrim can fail with:
> >>
> >>    fstrim: /: FITRIM ioctl failed: Unknown error 512
> >>
> >> On a Fedora 44 laptop with kernel 7.2.7, 3 of the last 21 weekly
> >> fstrim.service runs were in progress when an automatic suspend started=
.
> >> All three failed this way and left the filesystem untrimmed.
> >>
> >> Since commit 69313850dce3 ("btrfs: add cancellation points to trim
> >> loops"), the trim loops return -ERESTARTSYS when
> >> btrfs_trim_interrupted() sees freezing(current), and FITRIM returns it
> >> to userspace. Since commit bfb670b9183b ("btrfs: handle user interrupt
> >> properly in btrfs_trim_fs()"), btrfs_trim_fs() returns it right away.
> >>
> >> -ERESTARTSYS is only valid while a signal is pending, because only the
> >> signal handling on syscall exit turns it into a restart. But
> >> freeze_processes() first sets pm_freezing, which makes freezing() true
> >> for every user task. Then it walks the task list and sends each task a
> >> fake signal. The trim loops check btrfs_trim_interrupted() after every
> >> extent. If a check falls in this window, the loop returns -ERESTARTSYS
> >> with no signal pending. Nothing restarts the syscall. On that laptop,
> >> with a few thousand threads, freezing user space took 2 to 5 ms in eac=
h
> >> of the three suspends above, and all three runs hit this window.
> >>
> >> Make btrfs_trim_interrupted() treat a freeze as an interruption only
> >> once the fake signal has arrived, i.e. when
> >> freezing(current) && signal_pending(current). freeze_processes() sends
> >> that signal in the same call. The trim loop stops at the next check
> >> after it, so suspend is not delayed.
> > Looking at how ext4 handles this scenario it seems to me they don't set
> > the error code to -ERESTARTSYS and (from a quick glance) return the
> > bytes discarded to the caller.
> > And like before they continue the discard (which will skip/fail again) =
until
> > there's nothing to be done.
> >
> > I don't know what the intention of btrfs: handle user interrupt
> > properly in btrfs_trim_fs()
> > was, maybe we should just swallow the ERESTARTSYS case in those scenari=
os.
>
> I agree on that btrfs is the exception, we should follow ext4/xfs, not
> rely on some tricky signal handling behavior for suspension.
When I updated btrfs_trim_interrupted I used the same "checks" as
seen in ext4 so at least on that part it's identical.

What differs is our error handling: we set/handle -ERESTARTSYS, ext4 does n=
ot.
ext4_try_to_trim_range only ever succeeds by returning the count of
trimmed bytes
even if it checks for trim interruptions.

I think if we remove ret =3D -ERESTARTSYS; from the
btrfs_trim_interrupted branches
we'd align the behavior (plus reverting the previous change as that's
now useless)
>
> I think the tokens of the author should be spent on unifying the btrfs
> fstrim suspension behavior instead.
>
>
> >>
> >> The restarted syscall re-reads struct fstrim_range from user memory.
> >> When the device phase is interrupted, btrfs_trim_fs() has already stor=
ed
> >> the trimmed byte count in range->len, and btrfs_ioctl_fitrim() copies
> >> the struct back unconditionally. The restart is then asked to trim
> >> [start, start + trimmed) instead of the requested range, or fails with
> >> -EINVAL when nothing was counted yet. Skip the copy_to_user() for
> >> -ERESTARTSYS. In all other cases the partial count is still copied bac=
k.
> >>
> >> Tested in a VM with pm_test=3Dfreezer. Without the patch, 18 of 20 fre=
ezes
> >> during a trim leaked errno 512, and 10 of 10 restarts after a
> >> device-phase interruption failed with -EINVAL. With the patch, all 30
> >> runs restarted and trimmed the full amount.
> >>
> >> Fixes: 69313850dce3 ("btrfs: add cancellation points to trim loops")
> >> CC: stable@vger.kernel.org # 5.15+
> >> Signed-off-by: Zhiwei Liang <zhiwei.liang@zliang.me>
> >> ---
> >>   fs/btrfs/free-space-cache.h | 3 ++-
> >>   fs/btrfs/ioctl.c            | 7 +++++++
> >>   2 files changed, 9 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> >> index e22443598b..cba2f5fd6b 100644
> >> --- a/fs/btrfs/free-space-cache.h
> >> +++ b/fs/btrfs/free-space-cache.h
> >> @@ -58,7 +58,8 @@ static inline bool btrfs_free_space_trimming_bitmap(
> >>
> >>   static inline bool btrfs_trim_interrupted(void)
> >>   {
> >> -       return fatal_signal_pending(current) || freezing(current);
> >> +       return fatal_signal_pending(current) ||
> >> +              (freezing(current) && signal_pending(current));
> >>   }
> >>
> >>   /*
> >> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> >> index ac070c745b..b02c59cbb0 100644
> >> --- a/fs/btrfs/ioctl.c
> >> +++ b/fs/btrfs/ioctl.c
> >> @@ -529,6 +529,13 @@ static noinline int btrfs_ioctl_fitrim(struct btr=
fs_fs_info *fs_info,
> >>          range.minlen =3D max(range.minlen, minlen);
> >>          ret =3D btrfs_trim_fs(fs_info, &range);
> >>
> >> +       /*
> >> +        * A restart re-reads the range from user space, so do not clo=
bber it
> >> +        * with the partial len the rerun would otherwise take as its =
input.
> >> +        */
> >> +       if (ret =3D=3D -ERESTARTSYS)
> >> +               return ret;
> >> +
> >>          if (copy_to_user(arg, &range, sizeof(range)))
> >>                  return -EFAULT;
> >>
> >>
> >> ---
> >> base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
> >> change-id: 20261028-btrfs-fitrim-freezer-d4cba16e7e13
> >>
> >> Best regards,
> >> --
> >> Zhiwei Liang <zhiwei.liang@zliang.me>
> >>
> >>
>
