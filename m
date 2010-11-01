From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
Date: Mon, 1 Nov 2010 12:09:43 -0400
Message-ID: <AANLkTimMCw8p+YJRzCg7_cEn4UEDTC6vxs6ByUjJYMnL@mail.gmail.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
	<AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
	<AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
	<20101031224757.GA2430@selene>
	<AANLkTingbRtFQUoQNZmQubL0LNhVF2hvkdma6j7VDTEU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
	Calvin Walton <calvin.walton@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTingbRtFQUoQNZmQubL0LNhVF2hvkdma6j7VDTEU@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 11:58 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Or when going through all the fragments of a file, have a counter, an=
d
> if it exceeds certain limit mark it somehow, so that it gets
> defragmented at least to a certain extent.

Thats elegant, =E2=80=94 then resources are only spent on defragmenting=
 files
which are actually in use and which actually need it... but I don't
see how it deals with the partial mutual exclusivity of defragmenting
and COWed files.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
