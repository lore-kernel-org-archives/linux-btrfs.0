Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48644 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbcISTun (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 15:50:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bm4aA-0004O4-7R
        for linux-btrfs@vger.kernel.org; Mon, 19 Sep 2016 21:50:26 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Date: Mon, 19 Sep 2016 19:50:07 +0000 (UTC)
Message-ID: <nrpfhf$g72$1@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <20160917065831.GA14388@google.com> <nriqf8$da6$2@blaine.gmane.org>
        <20160919185733.GH21290@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Sep 2016 14:57:33 -0400, Zygo Blaxell wrote:

> On Sat, Sep 17, 2016 at 07:13:45AM +0000, Alex Elsayed wrote:
>> IMO, this is already a flawed framing - in particular, if encrypting at
>> the extent level, one _should not_ be encrypting (or authenticating)
>> individual pages. The meaningful unit is the extent, and encrypting at
>> page granularity puts you right back where dmcrypt is: dealing with
>> fixed-
>> size space, and needing to find somewhere else to put the auth tag.
>> 
>> This is not a good place to be, and I strongly suspect it motivated
>> choosing XTS in the first place - something I feel is an _error_ in the
>> long run, and a dangerous one. (IMO, anything _but_ AEAD should be
>> forbidden in FS-level encryption.)
>> 
>> In a nonce-misuse-resistent AEAD, there _is_ no auth tag: There's some
>> amount of inherent ciphertext expansion, and the ciphertext _cannot be
>> decrypted at all_ unless all of it is present. In essence, a built-in
>> all-
>> or-nothing transform.
>> 
>> You could, potentially, chop off part of that and store it elsewhere,
>> but now you're dealing with significant added complexity, for
>> absolutely zero gain.
> 
> That would be true if the problem were not already long solved in btrfs.
> The 32-bit CRC tree stores 4 bytes per block separately and efficiently.
> With minor changes it can store a 32-byte HMAC for each block.

I disagree that this "solves" it - in particular, the fact that the fsck 
tool support dropping/regenerating the extent tree is wildly unsafe in 
the face of this.

For an AEAD that lacks nonce-misuse-resistance, it's "merely" downgrading 
security from AEAD to simple encryption (GCM, for instance, becomes 
exactly CTR). This would be almost okay (it's a fsck tool, after all), 
but the fact that it's a fsck tool makes the next part worse.

In the case of nonce-misuse-resistant AEAD, it's much worse: Dropping the 
checksum tree would permanently and irrevocably corrupt every single 
extent, with no data recoverable at all. This is the _exact_ opposite of 
_anything_ you would _ever_ want a fsck tool to do.

This is, fundamentally, the problem with treating an "auth tag" as a 
separate thing: It's only separate at all in weaker systems, and the act 
of separating the data induces incredibly nasty failure modes.

It gets even worse if you consider _why_ that option exists for the fsck 
tool: Because of the possibility that the _structure_ of the checksum 
tree becomes corrupted. As a result, two bit-flips (one for each 
duplicate of the metadata) would be entirely capable of irrevocably 
destroying _all encrypted data on the FS_.

Separating the "auth tag" - simply considering an "auth tag" a separate 
thing from the overall ciphertext - is a dangerous thing to do.

>> If you're _not_ using a nonce-misuse-resistant AEAD, it's even worse:
>> keeping the tag out-of-band makes it far too easy to fail to verify it,
>> or verify it only after decrypting the ciphertext to plaintext.
>> Bluntly: that is an immediate security vulnerability.
>> 
>> tl;dr: Don't encrypt pages, encrypt extents. They grow a little for the
>> auth tag, and that's fine.
>> 
>> Btrfs already handles needing to read the full extent in order to get a
>> page out of it with compression, anyway.
> 
> It does, but compressed extents are limited to 128K.  Uncompressed
> extents come in sizes up to 128M, far too large to read in their
> entirety for many applications.

Er, yes, and? Just as compressed extents have a different cap for reasons 
of practicality, so too can encrypted extents.

