Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34166 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbcIQG6l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 02:58:41 -0400
Received: by mail-pf0-f182.google.com with SMTP id p64so34109470pfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 23:58:40 -0700 (PDT)
Date: Fri, 16 Sep 2016 23:58:31 -0700
From: Eric Biggers <ebiggers@google.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, eternaleye@gmail.com
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160917065831.GA14388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
>
> This patchset adds btrfs encryption support.
>

Hi Anand,

I'm part of a team that will be maintaining and improving ext4 encryption.
Because f2fs now shares much of the code, it will benefit from the ext4
encryption work too.  It would be really nice if btrfs could be in the same
boat, since that would avoid redundant work and help prevent bugs and design
flaws.  So I strongly suggest that you explore how btrfs encryption might reuse
the existing code (and maybe extend it if there is very good reason to).

There also needs to be a proper design document for btrfs encryption.  This is
especially true if for some (very, very good) reason you can't reuse the
infrastructure from ext4 and f2fs.  There also could be unique challenges for
btrfs such as encryption keys and/or IVs being reused in reflinked extents.

You will also not get a proper review without a proper design document which
details things like the threat model and the security properties provided.  But
I did take a short look at the code anyway because I was interested.  The
results were not pretty.  As far as I can see the current proposal is fatally
flawed as it does not provide confidentiality of file contents against a basic
attack.

The main two flaws are:

1. Use of CTR mode of operation
2. Reuse of same (key, IV) pair for all pages of a given inode

CTR mode is well known to fall over completely when used with repeated (key, IV)
pairs.  This makes the encryption nearly worthless.  In more detail: suppose I
am an attacker who has access to a file's ciphertext.  By the definition of CTR
mode, each ciphertext block is given by: C = E(ctr) XOR P, where C and P denote
the ciphertext and plaintext blocks respectively, E denotes encryption with the
block cipher using the secret key, and 'ctr' denotes the counter value.  Due to
flaw (2) the ctr values repeat every page.  Consequently, if I can correctly
guess the plaintext P1 of *any* page in the file and I want to know the
plaintext P2 of some other page, I can trivially compute P2 = P1 XOR C1 XOR C2.
No secret key needed.

Essentially: if there is any part of a file which is easily guessable, such as
a header or even a zeroed region, then the whole file is revealed.

The solution is to use a less brittle mode of operation such as XTS in
combination with per-page IVs (or "tweaks") and derived per-file keys.  This is
already done in ext4 and f2fs, where the per-page IV is just the page offset.
Note that per-file keys were needed to prevent the same (key, IV) pair from
being used in multiple places.  So if you could reuse the fs/crypto
infrastructure, you could take advantage of the fact that this problem was
already solved.

Note: even better would be an authenticated encryption mode.  That isn't yet
done by ext4 or f2fs --- I think because there wasn't a good place to store a
per-page authentication tag.  It would be interesting to know whether this would
be possible for btrfs.

I also noticed that unlike ext4 and f2fs, filenames and symlinks are not being
encrypted in btrfs.  I know it may seem somewhat ad-hoc that filenames are
encrypted but not other metadata, but apparently filenames were considered
quite important and a lot of work went into making it possible to encrypt them
in ext4.

(Apologies if I misunderstood anything.  The proposal would be easier to review
with a design document, as mentioned.)

Hope this is helpful,

Eric
