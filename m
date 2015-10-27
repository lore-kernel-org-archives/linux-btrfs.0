Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:54212
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbbJ0PWP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 11:22:15 -0400
Subject: Re: Bad fs performance, IO freezes
To: "cheater00 ." <cheater00@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
 <562F7C7B.6060408@gmail.com>
 <CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
 <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
 <CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
 <CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com>
 <562F91E7.5030407@googlemail.com>
 <CA+9GZUi_YiuAsDBxZqXKW2cVH2A1UVp8gR2e=r-Byw7yXZs-_Q@mail.gmail.com>
 <CA+9GZUhfnuuCgf+kgR8a6MH+k1gih4U-O+mZaZmY6ETNZJvDKQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <562F96A5.5080509@googlemail.com>
Date: Tue, 27 Oct 2015 16:22:13 +0100
MIME-Version: 1.0
In-Reply-To: <CA+9GZUhfnuuCgf+kgR8a6MH+k1gih4U-O+mZaZmY6ETNZJvDKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/27/15 16:07, cheater00 . wrote:
> Can I have nodatacow but still have checksumming?

No, see "nodatacow":
https://btrfs.wiki.kernel.org/index.php/Mount_options

Torrents are typically rehashed both on a per-block basis and after
completion. That won't protect you from bitflips or fs corruption, but
then again you don't have data redundancy anyway, so it doesn't really
matter.

Also any silently bitflipped blocks will be rejected by peers since
they don't match they block hash, so even in that case you won't be
distributing corrupt data.

-h

