Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718777;
	b=D1t8JekIHeMOgBsUiVSWUr1rqboDF9+cRXrnvwrXLZMNftzpln5Ab7eLRGyeHBkt55WC
	 wIB64OZ793m9MN4GeHFoFHmU8MTDtVN84L/s0T67UFXP3irUrt1m1tklNKhvNLu4UscZC
	 P+TUT6kftNs/zRBkVNZwB0NeW1tzx2P6M+4XISSTYl1x1f/RaNZXjnBYdAI8LIHkifqxE
	 UXyOo9sSOf2ehb5uKdkgZJqVL5g9vko3u1upNRMPx0DGSwdI7LZJm4WJ94pMov7YdFtO2
	 EXLYiJwHugCLPF45cM1511CzZ6NL5ftbZvW0VuW95QQ0W0RtDrCPhdA0rrxeEWOeULg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
	b=4lmiP0BNpws3NEYrK+Fq66dbXzJnJSnAHpCZB5DNB41mI3zSzEf3pwJ37jnEYslJJzpi
	 K1KCkvvktjgD+fcfOkYTgeFFbteha1154zR0M1kWrOFJD+/+SsP6ewCtDRiVhw+OBsNF0
	 vPukZKlET1qh8V/z74IIcEU5sVqIG7u5i3ciHLRg9We9Bp+97krLe0aW+0q0o0kNu1IDa
	 jdWBUer/bG14ddsuUM6csC7IdNweT1/Wnwa8xTquaIuRx6EzeNbQit3Fh44UilP5HU+je
	 2l/qQDegiPz+qxLk/P87pAi29PtuNIADhctORs58RCK0W37mINAIELLb9u41fOJMjsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvFvtKic;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9163C606B258
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9163C606B258
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvFvtKic
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso1165428a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:12:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793718775; cv=none;
        d=google.com; s=arc-20260327;
        b=ERr3FD2YkDAE4muHyQBmCiMt75R5qEbB7efzvdJ8bs48W8JYqyE58dq44DkhbFqUb/
         mdq8r4kiu03IV2raaLKKXX9KmYzUuOcthG3tKhEx1fwzFVL1T+sN2p38FCY9AkvIuMSD
         bbmU8YJCWgcZvpmZ6RaxVS7g5ZUGZxWEzxVOYzo9zEDwftoIDroDpUo1XEdf+HtQevBQ
         LTweTV8GCne7rh3p3BDeJ+gx+EvtB469NA2ilsbuK1o/ErD7yK/p2zktVhiiNefkQs27
         bxk8MSZq2fstv4cubsQz/K+tM+eZ6ecL8A5WcaTDk8LTlpCOoKAm5QTO+nvQJc0Mc56K
         5hwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
        fh=kZcYIggO7qE/9yPCc3x0lr0cayBrznMprcYMccv2I6I=;
        b=CWFgNF0khvm8UuQ3fjjcPfzAS/i8WQqiw3lv37gnplvJdi0mo8MYTlleV1Wv+5Q1tB
         G7oFFsBR0ncgtAhDiUpYiI5bgoUVguljYuVy2Z9Lxf3kOW9O74Yujd15aqvA04nICzLB
         8M1thZVWZ7FBwKN6iKqeknXBusteHMg45ZC50ek1iWYYhEeJlNb4w3qGvCMJquQxaJZK
         JbRvEgYuf42paLR68pTVdmzfRCtgPk7tO8YX0Ua6aumijvFCJUH72Qv1WXx7s1kyPJMM
         TiWb+6k8yl44YhSPIgxFUQRNLiyBaoN3y8Lc0KJc9sIDif63kG5uHTGPxz/7Zd8KljgH
         rDiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718775; x=1794323575; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
        b=OvFvtKic68lKCYq5u4vqHczl3baTPtF15hOIez1MaJdBuzdCpImLq5Qv7L32t95reC
         ew8jluUvcc+N3iPd5ONhE6VQMsevXPTcnFcQMaMAXtydoe1Hvu4ufW8rct43NHU52g5v
         X6kQhB503r+JeDBVm2lVapqlL+7T5XwUc4QW0kNnCmhuVPRXuTmuIrietp2CZoQSDa/Z
         4jg55kmTR2BGZX5663w+3TGaH1OHMO4OEHB3ShEet7gRgN/NDGqdS+XvhVI8/KoYJeGO
         ZH8EsfNHZpQ1Z4aUgHGqr2/pfzFkq3nT8y24hz069Du181ff3kyUHLwqV6RHhY7o6PLP
         P4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718775; x=1794323575;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
        b=eGHvNi+05BxzMXMlqmttnrS/usAY9aWXcu5gUV6IygA9r7np1POMrdDBN7+PLewQAc
         O2pTa7qcTYW3SBzahGrZLn2IwXO3f6T4lZdnPkdV7Xzu5TrJCmP+W1W3N3icPfrjRtvW
         jJ3sIk/NXn3ksRWTcsdtbgl2XBY4gN2l5eCShH/vxbeEgICex5bm3EbzVleybG6PmRX3
         f9G8A6eB8wuZBSSBQ+EPb/Fh2YuW0zCi5h9uiYUTvtW1lG4e0y3gv3lcxXRTMQjwl3Cf
         z1Z7UFuKDf1kQGroR0zt2AXQ7tMlr8StMkWSuaEWudMJD1lstxGvR1Amm1q+16nMH8yN
         jZ2A==
X-Forwarded-Encrypted: i=1; AKwUvBz3nQaJZGkvHpy/mL50EEt84ENHcJea9QuGS/oL3/09a3CSo4OcjBXTPAot+ZucqTF097aqdsvmMLdrpw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8EZSGeAjwYcK23BttXPJ7n/6+rGLujbmMOt2gNqt+QPPw7T9A6
	LWm3fXuedSTrwbPcVPmVFoAbA76WUNqQdOObbGn05NzzLPhxRIZBteZJgBye0cDOhG+B6PwgLA/
	ZaTCaZCfjHebuhn0TIoeWkFGw7tdcCko=
X-Gm-Gg: AYBFou0P6jzP737jrZtqsil0J2/2DIeH2jRYzwASHPKpUOIkd9M5cdW7VXZ3IICDjbO
	CtnFA4uPwFDPAQF2U7ahmxCh8oqXqgpl66tdmUD9qwQbSAG2HiPX+5qOb+DUIIbPg9KMFcxtWL+
	aMFPy6w1eml/enRfWM4aAMhClvN9bpFZhyNG9nkPO2ZAtAs5uy1cwZJAWo55cQVjrbOO4vSVdhZ
	13Pwz3Tyfyw2aLZ+hwgexPn7vu0CfxxOuE4wQiKyTnqM5MyAmTTyERDL9vS0pqXQdxVl2JaHy8k
	wmy9UUMlQnuNzZDWnMPxTnRl49Au1QONwxN881vj1VLNcoa9IHHuG2MzUjbO4/wF+XPtPzO896q
	kcC/oyZlV8N2E9ekOrr3pIY1w4ah9T7EVornsHx4gDD278yCRb/PLznkEwKsxfNmW8kOqYTs=
X-Received: by 2002:aa7:c716:0:b0:6b1:c521:ebda with SMTP id
 4fb4d7f45d1cf-6b4d5ee6c50mr6756533a12.14.1793718774731; Tue, 03 Nov 2026
 07:12:54 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <CAOQ4uxjkG=1j1z==Mv4wzkF042rXstodokKnBfMFBf2e-Eztmw@mail.gmail.com>
 <DMLJE2Z57AD9.1W22LSE7V9HH2@gmail.com>
In-Reply-To: <DMLJE2Z57AD9.1W22LSE7V9HH2@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 16:12:42 +0100
X-Gm-Features: AclHuK8QI8V9NvEKNRSnDchTL0FslmV7Uh3t35Xsoq4Akwwc8XamtLwVFdORxbE
Message-ID: <CAOQ4uxiMLDgMXuij99-43UfCqfZN2a=CTet560o_RzU2m_Y4SA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 12:25=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 2, 2026 at 3:54 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> This is an initial implementation of a new timestamp to indicate the
> >> time when a file/directory was initially created.
> >>
> >> This patch series takes inspiration from the one by Sean Smith
> >> <defendthedisabled@gmail.com> [1], but using
> >> file_setattr()/file_getattr() as suggested by Darrick J. Wong
> >> <djwong@kernel.org> in [2].
> >>
> >> The semantics of this new timestamp should be at least these:
> >> - it should be the same as btime on a newly created file
> >> - it's user-settable, so it can be preserved for backups, filesystem
> >>   conversions, archives and any similar operation
> >> - it should be preserved every time mtime gets preserved
> >>
> >> and the correspondence with the other timestamps is as follows:
> >>
> >> ctime <-> btime
> >> mtime <-> ptime
> >>
> >> Examples:
> >> 1) a .zsh_history file created in 2019, then after a few years the use=
r
> >>    decides to switch to another filesystem, copying the .zsh_history t=
o
> >>    the new home, in that case btime would have the timestamp of the co=
py
> >>    and ptime would have the 2019 timestamp (just like mtime would have
> >>    been preserved)
> >> 2) a symlink created in 2020 from the home directory to a /path going
> >>    through the same process as the .zsh_history, in this case it would
> >>    also make sense to sync the ptime to the 2020 timestamp instead of
> >>    keeping only the btime (so the inode creation time).
> >>
> >> The proof-of-concept code (for testing) for stat(1) and cp(1) is
> >> available at https://github.com/koraynilay/coreutils (master branch)
> >> (Note: these coreutils code changes are a prototype and won't be
> >> submitted upstream as-is, but they work as expected in simple stat and
> >> cp -a/--preserve=3Dptime tests)
> >>
> >> Lastly, the name "provenance" and "ptime" are not final, I personally
> >> don't have a strong opinion on any name, but while testing with stat(1=
)
> >> I noticed that "Provenance" is definitely too long for the normal
> >> output, so another option which would fit well is "Origin time",
> >> abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
> >> conflict with btrfs' internal naming and create confusion.
> >
> > FWIW, I agree that given the existing uses of btime and crtime in the
> > kernel and various XXXprogs, using 'ptime' for kernel code is probably
> > the lesser evil.
>
> What do you think about the origiN time (ntime) (Origin: in stat)?
> It would also coincidentally be alphabetically (ntime <-> mtime, n -> m)
> the same as btime <-> ctime (b -> c) ahah.
>

Honestly I don't know.
My new idea is don't publish it in statx() at all.

Thanks,
Amir.
