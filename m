From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: Re: single disk reed solomon codes
Date: Sat, 19 Jul 2008 19:53:44 +0300
Message-ID: <3da3b5b40807190953r324868e4x2a8b521f6fae45fe@mail.gmail.com>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
	 <1216486204.2475.11.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "David Woodhouse" <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216486204.2475.11.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

> RS-based error correction for themselves. If we're unlucky in our choice
> of error correction, it might even be possible to end up in a situation
> where the only errors we'd _see_ are the ones which were uncorrectable.
>

but since at the FS level, the redundancy would be at a different
place, than the hardware level redundancy, it might be correctable to
you
