Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34854 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754586AbcITPv5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 11:51:57 -0400
Received: by mail-pf0-f178.google.com with SMTP id z123so8721134pfz.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 08:51:57 -0700 (PDT)
Date: Tue, 20 Sep 2016 07:51:52 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ChaCha20 vs. AES performance
Message-ID: <20160920155152.eopgz7h2z6kpsfdy@kmo-pixel>
References: <20160920111519.3n5ijtusvevasjl4@kmo-pixel>
 <20160920142320.ubkifckpfvzvuzom@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920142320.ubkifckpfvzvuzom@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:23:20AM -0400, Theodore Ts'o wrote:
> On Tue, Sep 20, 2016 at 03:15:19AM -0800, Kent Overstreet wrote:
> > Not on the list or I would've replied directly, but on Haswell, ChaCha20 (in
> > software) is over 2x as fast as AES (in hardware), at realistic (for a
> > filesystem) block sizes:
> 
> On Skylake and Broadwell processors, AES is faster (the posting is
> from a ChaCha20 enthusiast):
> 
>      https://blog.cloudflare.com/it-takes-two-to-chacha-poly/

The performance delta in his graphs isn't near as big as what I've measured,
which makes me suspect OpenSSL's ChaCha20 implementation isn't nearly as fast as
the kernel's.

> My big worry though is that schemes that require that nonces/IV's must
> **never** be reused are fragile.  It's for the same reason that DSA
> makes my skin crawl.  If you ever screw up --- maybe after a crash, or
> a file system bug, you end up reusing a nonce, it's game over.
> 
> So if there are hardware solutions which are faster or fast enough
> that the crypto is no longer dominant cost, why not use a cipher
> scheme which is more robust?

Block ciphers have their own downsides though - XTS is really a big pile of
hacks and workarounds. On the whole, if you can get nonces right, a stream
cipher cryptosystem (and ChaCha20 especially) is on the whole drastically
simpler, and thus easier to understand and audit.

And if you can do nonces correctly, ChaCha20/Poly1305 is pretty much one of the
gold standards - it's secure against pretty much any vaguely realistic threat
model. XTS, not so much - it's just the best you can do given the constraints of
typical disk crypto. The gold standards of encryption today are the AEADs - and
AES/GCM fails badly with nonce reuse too, there aren't any AEADs yet that don't
fail badly with nonce reuse.

> P.S.  We're also both ignoring the cost of whatever changes are needed in
> the file system to guarantee that the nonce is never, ever reused...

I'm definitely not advocating for hacking stream ciphers into existing
filesystems - if you don't have the machinery you need to be 100% rigorous about
nonces, then definitely stick with XTS. But I already had most of what I needed
in bcachefs, and I can still break the on disk format if I need to (and
encryption is a breaking change), so for me ChaCha20/Poly1305 was a no brainer.

BTW though, if there do turn out to be platforms where AES is significantly
faster than ChaCha20 I can still add AES support pretty easily - I've already
got all the relevant switch statements, since encryption is handled as another
checksum type.
