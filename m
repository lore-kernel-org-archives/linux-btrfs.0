Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0369233F368
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 22:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773871520; cv=pass; b=a+2Ah88hxzDPrisTBr3mCq/ovB9zJOxfrwW2Ji4Cea2IoqTQ3Frlenu1A+ol5qrJQhQz/WK5sPLDQDQY8B0kzUInWhGF6BkSdnSGrAIIm5X4nTTgLpF6HFoihsuLdT4q9itRwyuiFa8fKwHpn52vnwSF+BlZf+zh7yxfh9r/HnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773871520; c=relaxed/simple;
	bh=sabj0A0BAuS8xh08yMv2OD5jFNV9qz6Xr7PStsyCPio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/x7YRuasXgIfaW0AK71MxSIH4D62VUGdsvKoL4IGBwOKa7d/dv0jlggUHHnfBlfgvXLD39nqMXdV2cZuSCpplPKn2NlV9cIThc+Og6QqGX1f4ea1O170PHLAbL6MolIqGq8TTCfTduVmfnDWP1X8DOzUjGm6HU3dxrtuwsHLr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VKH7tkks; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VKH7tkks"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-41706b23543so201890fac.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 15:05:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773871518; cv=none;
        d=google.com; s=arc-20240605;
        b=KzkU2nbdd98P9GoOV+PBZGSTXXxgszyM0S3Pn5P4/qet/ls0gAAYI1ACTh4OJYH6rT
         Tr79KXKGdgc9oQOFoGyhkKcYzFN3Sl7CBC3GBSyCBh9r1yNbDSExQsukM7DIQrSsdZuO
         FcapVynmRbr923PpULMFl/T9I3Bh1vBtl1GcH4FbU9sTPOvGbgutd7YMhJmm1e1Kuref
         efcAu9LOeBhkNLvSoVEk/hURHwz9yzn4PcIt2aWTUbKBOy73NEpJdNZl6sjYc73k09X6
         Y0dkH9I9wY73V4dxmHbbcHJ1Tl/gi0JXo024A4zuDhlz2ceHOt4sypAzCDtuhf2F4UYu
         uEPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KTOPNs9Pv/5RY/SOvNaQNpRdaO7uO/4bJmIrMXXPD+w=;
        fh=HRQ+QdrBWMykqC3eTzQ20jZJtv9u/Sk24IxwFmKKcow=;
        b=XbQC5r99fYRNXp6zV8JjqJZkDxoQGbKpSvm5z/XuvqphX1/LBmKzM8ToDjqZaqBXOG
         iWGfl+Kh2zub/Y4GRxlKPxyEzFw5fY/az+mUOcCTM8Qy34QSTUIyGh4Ss6tq6/tLodY2
         ffQDn/ZArD/IBDk5wwmfkCrkR9FZH4UXzxG8QxNLltDpNUdKpGLueD1I2QvO3HecYV3I
         iNctp3+4QOz0O6NMR17Io8cINq/IajR7W662roXFJmJK4uLNhJuQoPU0C/e4hqVgM/f1
         wWIFBYkYG+61Icnmlgpqx+qSBhmwgE3Ew82kRdRo8AAzqQrNV4clw6o58Wjq3uivkyNY
         5TRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773871518; x=1774476318; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTOPNs9Pv/5RY/SOvNaQNpRdaO7uO/4bJmIrMXXPD+w=;
        b=VKH7tkksZh4yPmMglDjSpfTDlwkdateQeG9WCxjNOseMqwXKKnsbELLTdioLRTHX3d
         FfRnlYRjpviVz68Mptg0ShQWxjrWYC0778INUA4KCHGH5DdkMgdjtcsh/duyTBq8+0JP
         VOPCX+YWxSnSVl8x4m0GppQT4ekR3yRLqd1AQCS1mgVAVmfwPyIpB0qdm81hG67XQoN8
         oE8AaL/M2aHa1WsmmKIl9vn48PF8BBbo6Prpy81AtYG0gf2ihwYhEvj0oHsp6E/vrli1
         +BtN5+wZpR4ao+9FE6dJdAwGdT0ZG/wqxRtyItcIFHf4ZdTNbpWU9uWe5j7iDWGrqDm8
         VtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773871518; x=1774476318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KTOPNs9Pv/5RY/SOvNaQNpRdaO7uO/4bJmIrMXXPD+w=;
        b=oRqxQQ1ouWPthp8Gr+wVuKm40HFRnZnzbAvlwcx76MLpBExBePY1EKqofnemG3MdLx
         rVvBQ1hJMvRW0z6Jrd+hyl5K1pViW0+cho+FqSnaTDNVQcOQqNveWvD2khIQUu/DkTN4
         961N6MQcTcWM/NIPkf0rlC8aNdGagpKeFzbYYVP1GUOF8q2vqxjykNG3+RvfiOQoV6Du
         n2/19F7DCSKnLTQ42VQLdRLpvQCOEsPrT61Un2+bcoDzkQwHBjRB4Bm5F80n50m1+bIK
         M3hTZWbuKyG+4wZ36EG2h/wVvn3p647hBlgwS4sKJaqV7vfiX+hVAzBMOuPFJZf1S+L2
         Pksg==
X-Forwarded-Encrypted: i=1; AJvYcCUpRWQByr1hg6DWNPfWkHgQ0TX1toQCgrXISN8xporJZWa3byhLaDLgghkjc/enYrKNXSwWMMa04RrfBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOr6rjlZyo0B3Xqsfc1hR+QRfl7kZWaEW3E0xZTS9DCgsrs7vV
	v8CISm0TQ9VLfeOxrWw6pvfLYsWcPJoED+qnwrUh4VCXmZXSr6lo9LdcQIJnlCXe1ys7xcN2s4z
	9JnUhdCnCJ7F/6B/gRTrA7rd4kJSfMk9yg4429z/c
X-Gm-Gg: ATEYQzw18rcZBe4g/c0uqVm0hWrmx5J/wRKSfVEGqY8aUJ90No87mUzxBw3FE5u/NSK
	WK5L0At612HxVAPDq2++rvXtBZJG/VcRS2feX/666LuZH5FZbob4y0X9D9pR9RL5SNfD/RKcqHZ
	Vv4Sc/bQJj8khLEq/+Pl+CI3R1s6VntWogEFLIq6WO+238xqHTzyAhwqXw/hmBJyffO+ZuLmQiL
	npt57TEddPA1neE6y0rN4J0Wsb+M+AAyU3rJMZLVfe2f8rW0y3PU6HjG8ZLWL6Qhq/7fQB+h/mF
	yH3JLRCbzXrCXJ4WX6ahhRQzD7h6i+vNlr7Ei5n/f7MVqsU2nYDCfTTIjMZHcvifHE3uhTcvvQ1
	UBgXk6KE=
X-Received: by 2002:a05:6870:a7a4:b0:417:28be:32a7 with SMTP id
 586e51a60fabf-41befc50b48mr786544fac.4.1773871517548; Wed, 18 Mar 2026
 15:05:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <69b8084c.050a0220.248e02.0115.GAE@google.com> <20260318163510.GE5735@twin.jikos.cz>
In-Reply-To: <20260318163510.GE5735@twin.jikos.cz>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 18 Mar 2026 23:05:06 +0100
X-Gm-Features: AaiRm52gJ3NaK4ElXJM9kqcdADiunedu18U8Gtc7iglNoEzH_UZLUeqrjjfd48o
Message-ID: <CANp29Y7q2qyvCre5Una2vx3LM7g-0ZGpRmmT_R2BnnKqB_a4=A@mail.gmail.com>
Subject: Re: [syzbot] [btrfs?] BUG: corrupted list in btrfs_free_compr_folio
To: dsterba@suse.cz
Cc: syzbot <syzbot+3c4d8371d65230f852a2@syzkaller.appspotmail.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 5:35=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Mon, Mar 16, 2026 at 06:40:28AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    f338e7738378 Linux 7.0-rc4
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D15265602580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd46eab0cfd3=
1c214
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D3c4d8371d6523=
0f852a2
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e=
25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-f338e773.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/2567fb35ebfb/vmli=
nux-f338e773.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/f9124de81ddb=
/bzImage-f338e773.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+3c4d8371d65230f852a2@syzkaller.appspotmail.com
>
> syz: fix: btrfs: zlib: handle page aligned compressed size correctly

#syz fix: btrfs: zlib: handle page aligned compressed size correctly
