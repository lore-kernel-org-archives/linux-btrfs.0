Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44094 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbcITUgY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 16:36:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bmRlz-0002Kc-Kp
        for linux-btrfs@vger.kernel.org; Tue, 20 Sep 2016 22:36:11 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: ChaCha20 vs. AES performance
Date: Tue, 20 Sep 2016 20:35:56 +0000 (UTC)
Message-ID: <nrs6jc$rd$1@blaine.gmane.org>
References: <20160920111519.3n5ijtusvevasjl4@kmo-pixel>
        <20160920142320.ubkifckpfvzvuzom@thunk.org>
        <20160920155152.eopgz7h2z6kpsfdy@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 Sep 2016 07:51:52 -0800, Kent Overstreet wrote:

> On Tue, Sep 20, 2016 at 10:23:20AM -0400, Theodore Ts'o wrote:
>> On Tue, Sep 20, 2016 at 03:15:19AM -0800, Kent Overstreet wrote:
>> > Not on the list or I would've replied directly, but on Haswell,
>> > ChaCha20 (in software) is over 2x as fast as AES (in hardware), at
>> > realistic (for a filesystem) block sizes:

Apologies if this doesn't CC you - replying via gmane, since (not being 
subscribed via email either) I can't try the same trick I did to include 
Ted (i.e., reply via my mail client).

One useful trick, though - if you have a Usenet client, gmane _will_ let 
you reply directly, even to old messages. That's what I'm doing.

>> On Skylake and Broadwell processors, AES is faster (the posting is from
>> a ChaCha20 enthusiast):
>> 
>>      https://blog.cloudflare.com/it-takes-two-to-chacha-poly/
> 
> The performance delta in his graphs isn't near as big as what I've
> measured, which makes me suspect OpenSSL's ChaCha20 implementation isn't
> nearly as fast as the kernel's.
> 
>> My big worry though is that schemes that require that nonces/IV's must
>> **never** be reused are fragile.  It's for the same reason that DSA
>> makes my skin crawl.  If you ever screw up --- maybe after a crash, or
>> a file system bug, you end up reusing a nonce, it's game over.
>> 
>> So if there are hardware solutions which are faster or fast enough that
>> the crypto is no longer dominant cost, why not use a cipher scheme
>> which is more robust?
> 
> Block ciphers have their own downsides though - XTS is really a big pile
> of hacks and workarounds. On the whole, if you can get nonces right, a
> stream cipher cryptosystem (and ChaCha20 especially) is on the whole
> drastically simpler, and thus easier to understand and audit.

Yes, I would entirely agree with your assessment of XTS (in particular, 
the doubling of the length of the key is rooted in the original authors 
misunderstanding the XEX paper...).

> And if you can do nonces correctly, ChaCha20/Poly1305 is pretty much one
> of the gold standards - it's secure against pretty much any vaguely
> realistic threat model. XTS, not so much - it's just the best you can do
> given the constraints of typical disk crypto. The gold standards of
> encryption today are the AEADs - and AES/GCM fails badly with nonce
> reuse too, there aren't any AEADs yet that don't fail badly with nonce
> reuse.

Not true - SIV is a generic construction, which has been applied to AES 
(AES-SIV, RFC 5297) and ChaCha20 (HS1-SIV, submitted to CAESAR). There's 
also AES-GCM-SIV, which takes advantage of GCM hardware acceleration as 
well as AES acceleration.

