From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Mon, 7 Nov 2011 13:49:21 +0100
Message-ID: <CAK-xaQbT+hrO-DOoiTDrU_4KfQuc+xvc4D_F0JFnWNHdGOTkQA@mail.gmail.com>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net> <20111107154936.7c60be38@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arne Jansen <sensille@gmx.net>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111107154936.7c60be38@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

2011/11/7 Roman Mamedov <rm@romanrm.ru>:
> If so, shouldn't there also be a corresponding dmesg warning about "Unable to allocate....", which would confirm or rule this out?
> So before following the "did you try turning it off and on again" advice (and throwing away useful debug info), I'd suggest checking/saving dmesg first.

Hi Roman,
   and thanks a lot for your reply.
   I did check dmesg and /var/log also, but I didn't find complain about it.

   So, I tried with a loopback device and it works well.
   Maybe the problem is about my device stack?
   Bottom up my home is on a: md + luks + lvm + md + btrfs.

Thanks a lot for your time,
Andrea
