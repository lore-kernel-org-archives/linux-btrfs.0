Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56524 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2HPWSF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 18:18:05 -0400
Date: Fri, 17 Aug 2012 00:17:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: james northrup <northrup.james@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andi Kleen <andi@firstfloor.org>, Roman Mamedov <rm@romanrm.ru>,
        Johannes Stezenbach <js@sig21.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120816221758.GM11413@one.firstfloor.org>
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net> <502B8FE3.7080501@oberhumer.com> <20120815144539.GA8300@sig21.net> <502C92C3.7090701@oberhumer.com> <20120816150647.GA22010@sig21.net> <20120816232549.4d14a6aa@natsu> <20120816175234.GL11413@one.firstfloor.org> <CAMuHMdWK_Y=QwkgQD6K8tFBLaO04Fy0yVAzEpb2OYW6Ec0hGoA@mail.gmail.com> <CAPkEcwgv6f5B+Mrw7kzrHcZ5JZ+Yr0o=bLdoFqCB-e4CLiVx5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPkEcwgv6f5B+Mrw7kzrHcZ5JZ+Yr0o=bLdoFqCB-e4CLiVx5A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2012 at 11:55:06AM -0700, james northrup wrote:
> looks like ARM results are inconclusive from a lot of folks without
> bandwidth to do a write-up, what about just plain STAGING status for ARM so
> the android tweakers can beat on it for a while?

Staging only really works for new drivers, not for updating existing
library functions like this.

I suppose you could keep both and have the architecture select with a
CONFIG.

-Andi
