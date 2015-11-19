Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34676 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbbKSIbn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 03:31:43 -0500
Received: by wmvv187 with SMTP id v187so13394101wmv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 00:31:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151119105830.48b57273@natsu>
References: <564CC90F.3060703@gmail.com> <20151119105830.48b57273@natsu>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Thu, 19 Nov 2015 09:31:22 +0100
Message-ID: <CAA7pwKNO_5iC81rehkS4BaRe+1sX_4vT_1Dqn+qhY1rKVD8jgw@mail.gmail.com>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: linux-btrfs.tebulin@xoxy.net
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 November 2015 at 06:58, Roman Mamedov <rm@romanrm.net> wrote:
>
> On Wed, 18 Nov 2015 19:53:03 +0100
> linux-btrfs.tebulin@xoxy.net wrote:
>
> >   $ uname -a
> >   Linux neptun 3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8
> > 10:21:08 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
[...]
>
> So my suggestion would be to try a newer kernel from www.kernel.org: if the
> problem disappears at 4.1 then just keep on using that, or 4.3 if you have to,
> but otherwise that one might be a bit too new to start using right away.

Give http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.13-wily/ a try.

wget -e robots=off -r -l1 -np -nd -A '*all.deb','*generic*amd64.deb'
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.13-wily/
