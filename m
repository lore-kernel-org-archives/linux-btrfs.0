Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D66301460
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777044058; cv=none; b=L/VEtpZH86i2OVpdWYsGM07agAso0wMXA9OngQxvR/KSmKUeLolSo0Lb864BnczZDaeBvvaB2nb/Hr3BOm4zdj5fkjsLtTyj9gPkjzjLLEa1UEIdciZ6EYhVGhXMaajpOXpFP51+3NVaO5pR4l4tGPlGhe41L9T1SAGhUrZVw3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777044058; c=relaxed/simple;
	bh=G5RRD+LtSh+MM43vL/udLMQUaepJ9K8ewotYudPTu5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTZd+nquNQJX82NMPJvzSw4mDBcEd2sFeI9IIY7iAOFEvqVuCidFDgMXXApgIflmIpbCpcQudDQGiXGjoAkknyv0vS2lQaOCFlSXHV1NUogN0hvobxCv5FvTykriixQnwETBQHaHF38xhbumGFWIDTzP5oVD/rT+NH2impDjEi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4xoOSSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4xoOSSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A62C19425
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777044058;
	bh=G5RRD+LtSh+MM43vL/udLMQUaepJ9K8ewotYudPTu5E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A4xoOSSyyigVo2FZ+F+RNBKyvtRiEBmH0xn/k7nYwJcyWgbeGEpWhfEP2mYcxtIew
	 zU0PAMovImVsAO0pbvDucUCtsd/NiIkQuuQV7uzYxOEK8OHDtnYkRJF7RQgDj/fvQo
	 nFrsItlmB5t2fiJHQSVHs2H5mg9CeLgizueBE2wVhkOxdKhhMnd7DVk/G8slOtjYbd
	 joqi7ITCMr7UoF40/aoEQGG5Bi8tgGWAMPqfyFsAbk4sbjjTDTzvKku8FoucttLbSK
	 MXUu6uHgws2gAs2rLDB4ZyfRRMKPxPwMwSAhaNwm8mi5nn+wOpnh+yMCUDSUs877CD
	 hUOayhPhL13tw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b936331786dso1048398766b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:20:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YzviK3a5p1JGARoG5nliHdovsGbly3nBe651PI27TszoTJWr6QB
	YIMLvm/xw7SrlswW7imWbXxHjL0sTzAWqhD/C6qRhNhTa7SGT95aQLb9IUjDReEKNiRbd7zir66
	149+bBQ+qath1BNK56cxTYX/v9xCrjLw=
X-Received: by 2002:a17:907:934a:b0:bae:8734:18b4 with SMTP id
 a640c23a62f3a-bae87341903mr65370166b.16.1777044056662; Fri, 24 Apr 2026
 08:20:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
 <20260424023835.GA3542906@twin.jikos.cz> <20260424031154.GB3542906@twin.jikos.cz>
In-Reply-To: <20260424031154.GB3542906@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 24 Apr 2026 16:20:19 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7oXSMAHYmzX=hMk92M+7T5h055ETSJ9j6QyTH4wmmJuw@mail.gmail.com>
X-Gm-Features: AQROBzCKVfuJBGdoKR4gnLCcSMh4i2EdJ0fYF_H29cHT1lzL2CbNO4xQG66dgbE
Message-ID: <CAL3q7H7oXSMAHYmzX=hMk92M+7T5h055ETSJ9j6QyTH4wmmJuw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: collapse report_eb_range() into its single caller
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 4:12=E2=80=AFAM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Fri, Apr 24, 2026 at 04:38:35AM +0200, David Sterba wrote:
> > On Thu, Apr 23, 2026 at 12:38:13PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > There's no point in having this static function since it's too short =
and
> > > it has a single caller (check_eb_range()), so move its code into the
> > > caller and remove it.
> >
> > The point is to separate the check and report functionality, so the
> > check part is inline and a simple if (a few instructions), while the
> > report is not always inlined and is considered cold code.
>
> But what compiler does is not what was intended, there should be either
> __cold or noinline for the report function.
>
> The effects of __cold on unpatched:
>
>      text          data     bss     dec     hex filename
>   1742535        150224   15560 1908319  1d1e5f pre/btrfs.ko
>   1742159        150224   15560 1907943  1d1ce7 post/btrfs.ko
>
>   DELTA: -376
>
> Stack effects:
>
>    copy_extent_buffer                           -8 (80 -> 72)
>    extent_buffer_get_byte                      -24 (32 -> 8)
>    memcmp_extent_buffer                        -16 (80 -> 64)
>    memcpy_extent_buffer                         -8 (72 -> 64)
>    memmove_extent_buffer                       -16 (64 -> 48)
>    memzero_extent_buffer                       -32 (40 -> 8)
>    read_extent_buffer                          -24 (72 -> 48)
>    read_extent_buffer_to_user_nofault          -24 (72 -> 48)
>    __write_extent_buffer                        -8 (88 -> 80)
>
>    LOST (0):
>
>    NEW (40):
>            report_eb_range                      40
>    LOST/NEW DELTA:      +40
>    PRE/POST DELTA:     -120
>
> As can be seen it's all in the extent buffer manipulation helpers so
> the hot path functions where the micro optimizations have impact.
>
> The effects of 'noinline:
>
>      text          data     bss     dec     hex filename
>   1742535        150224   15560 1908319  1d1e5f pre/btrfs.ko
>   1742033        150224   15560 1907817  1d1c69 post/btrfs.ko
>
>   DELTA: -502
>
> Stack:
>
>   copy_extent_buffer                            -8 (80 -> 72)
>   extent_buffer_get_byte                       -24 (32 -> 8)
>   memcmp_extent_buffer                         -16 (80 -> 64)
>   memcpy_extent_buffer                          -8 (72 -> 64)
>   memmove_extent_buffer                        -16 (64 -> 48)
>   memzero_extent_buffer                        -32 (40 -> 8)
>   read_extent_buffer                           -24 (72 -> 48)
>   read_extent_buffer_to_user_nofault           -24 (72 -> 48)
>   __write_extent_buffer                         -8 (88 -> 80)
>
>   LOST (0):
>
>   NEW (40):
>           report_eb_range                       40
>   LOST/NEW DELTA:      +40
>   PRE/POST DELTA:     -120
>
> So the same effects on stack (this is consumed by setting up the printk
> and other things to report it), and difference how exactly is the code
> inlined.
>
> Either way, merging the report to check is not right.

Yes, oversight on the fact that check_eb_range() is inline and it has
quite a significant number of callers.
Updated in another patch:
https://lore.kernel.org/linux-btrfs/5082990dc32613cf128c27ef01086178edcf4e2=
4.1777043747.git.fdmanana@suse.com/

Thanks.
