Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40394 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753823AbcIQHOG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 03:14:06 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bl9ox-0002PP-I6
        for linux-btrfs@vger.kernel.org; Sat, 17 Sep 2016 09:13:55 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Date: Sat, 17 Sep 2016 07:13:45 +0000 (UTC)
Message-ID: <nriqf8$da6$2@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <20160917065831.GA14388@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 16 Sep 2016 23:58:31 -0700, Eric Biggers wrote:

> On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
>>
>> This patchset adds btrfs encryption support.
>>
>>
> Hi Anand,

<snip>

> Note: even better would be an authenticated encryption mode.  That isn't
> yet done by ext4 or f2fs --- I think because there wasn't a good place
> to store a per-page authentication tag.  It would be interesting to know
> whether this would be possible for btrfs.

IMO, this is already a flawed framing - in particular, if encrypting at 
the extent level, one _should not_ be encrypting (or authenticating) 
individual pages. The meaningful unit is the extent, and encrypting at 
page granularity puts you right back where dmcrypt is: dealing with fixed-
size space, and needing to find somewhere else to put the auth tag.

This is not a good place to be, and I strongly suspect it motivated 
choosing XTS in the first place - something I feel is an _error_ in the 
long run, and a dangerous one. (IMO, anything _but_ AEAD should be 
forbidden in FS-level encryption.)

In a nonce-misuse-resistent AEAD, there _is_ no auth tag: There's some 
amount of inherent ciphertext expansion, and the ciphertext _cannot be 
decrypted at all_ unless all of it is present. In essence, a built-in all-
or-nothing transform.

You could, potentially, chop off part of that and store it elsewhere, but 
now you're dealing with significant added complexity, for absolutely zero 
gain.

If you're _not_ using a nonce-misuse-resistant AEAD, it's even worse: 
keeping the tag out-of-band makes it far too easy to fail to verify it, 
or verify it only after decrypting the ciphertext to plaintext. Bluntly: 
that is an immediate security vulnerability.

tl;dr: Don't encrypt pages, encrypt extents. They grow a little for the 
auth tag, and that's fine.

Btrfs already handles needing to read the full extent in order to get a 
page out of it with compression, anyway.

<snip>


