From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Sun, 12 Sep 2010 15:38:50 +0300
Message-ID: <AANLkTik5mFPnqiUH3dkeGWnOz+PCBPx3rtiVzAQrXf75@mail.gmail.com>
References: <20100527151515.GA3835@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100527151515.GA3835@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 27, 2010 at 6:15 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> =C2=A0 =C2=A0Btrfs: Fix block generation verification race (+1/-1)

This seems to cause a hang when there are "parent transid verify failed=
" errors.

Somebody on #btrfs told me to revert it, and at least the system
doesn't hang any more.

--=20
=46elipe Contreras
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
