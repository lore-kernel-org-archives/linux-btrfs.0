Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20329 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcIQQKL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 12:10:11 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Eric Biggers <ebiggers@google.com>, linux-btrfs@vger.kernel.org
References: <20160917065831.GA14388@google.com>
Cc: eternaleye@gmail.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b205136c-5680-c7cd-0862-b81d24a4b8e0@oracle.com>
Date: Sun, 18 Sep 2016 00:12:01 +0800
MIME-Version: 1.0
In-Reply-To: <20160917065831.GA14388@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Eric,

  Thanks for the constructive feedback, pls see inline below.


On 09/17/2016 02:58 PM, Eric Biggers wrote:
> On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
>>
>> This patchset adds btrfs encryption support.
>>
>
> Hi Anand,
>
> I'm part of a team that will be maintaining and improving ext4 encryption.
> Because f2fs now shares much of the code, it will benefit from the ext4
> encryption work too.  It would be really nice if btrfs could be in the same
> boat, since that would avoid redundant work and help prevent bugs and design
> flaws.  So I strongly suggest that you explore how btrfs encryption might reuse
> the existing code (and maybe extend it if there is very good reason to).

In fact my first attempt was using f2fs/ext4, found its too complicated,
further couldn't stable it, so re-wrote completely to a version where I
won't worry too much on the cipher mode _at the moment_, so this version
came with a caveat as mentioned.
Now looking to integrate with fs/crypto, however have the following 
concerns,

fs/crypto:
.
   fscrypt_context:master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
   should it go to the disk ? its just a descriptor which might
   change at the user end and still may contain the right key
   in the payload.

   btrfs keeps it only in-memory and key hash goes to the disk.
   Further in the long we need an integration with key management
   system as well.

.
   ext4/f2fs allows per file keys, when we are talking about large
   data center FS for cloud services, it would need key services
   to scale along with the FS. And there will be a lot of resources
   which is allocated but not used.

.
  system keyring already defines struct user_key_payload
  probably we should have used it instead of

  71 struct fscrypt_key {
  72         u32 mode;
  73         u8 raw[FS_MAX_KEY_SIZE];
  74         u32 size;
  75 } __packed;


.
  Some of key derivation functions should have been part of
  crypto library rather.

.
  page->index based IV won't suite btrfs, so it uses a random, but yes
  it needs crypto hardened. I am kind of opinion that, for a real need
  of retrievable random number we are replacing it with sector(truecrypt)
  /page-offset number, I think we aren't addressing problem in a right
  way ? If that that's the best solution we could achieve, yet I am not
  sure how to solve the need of FS independent decrypt ? I am yet to
  look at gpg.

.
  Yes needs AEAD. But at the same time we need
    - MAC to be separated from the ciphertext and ciphertext-size
      == plaintext-size.
    To make sure for sync,dio we do create extents and IO which matches
    with the application IO. So that performance tuning will be things
    as usual.


> There also needs to be a proper design document for btrfs encryption.  This is
> especially true if for some (very, very good) reason you can't reuse the
> infrastructure from ext4 and f2fs.  There also could be unique challenges for
> btrfs such as encryption keys and/or IVs being reused in reflinked extents.
>
> You will also not get a proper review without a proper design document which
> details things like the threat model and the security properties provided.  But
> I did take a short look at the code anyway because I was interested.

  Thank You !!  I should have sent the code when doc is ready rather.
  Sorry about that.


>  The
> results were not pretty.  As far as I can see the current proposal is fatally
> flawed as it does not provide confidentiality of file contents against a basic
> attack.
>
> The main two flaws are:
>
> 1. Use of CTR mode of operation
> 2. Reuse of same (key, IV) pair for all pages of a given inode
>
> CTR mode is well known to fall over completely when used with repeated (key, IV)
> pairs.  This makes the encryption nearly worthless.  In more detail: suppose I
> am an attacker who has access to a file's ciphertext.  By the definition of CTR
> mode, each ciphertext block is given by: C = E(ctr) XOR P, where C and P denote
> the ciphertext and plaintext blocks respectively, E denotes encryption with the
> block cipher using the secret key, and 'ctr' denotes the counter value.  Due to
> flaw (2) the ctr values repeat every page.  Consequently, if I can correctly
> guess the plaintext P1 of *any* page in the file and I want to know the
> plaintext P2 of some other page, I can trivially compute P2 = P1 XOR C1 XOR C2.
> No secret key needed.
>
> Essentially: if there is any part of a file which is easily guessable, such as
> a header or even a zeroed region, then the whole file is revealed.

  Yes this will be fixed. No TFM is claimed to be btrfs default
  as of now.

> The solution is to use a less brittle mode of operation such as XTS in
> combination with per-page IVs (or "tweaks") and derived per-file keys.  This is
> already done in ext4 and f2fs, where the per-page IV is just the page offset.
> Note that per-file keys were needed to prevent the same (key, IV) pair from
> being used in multiple places.  So if you could reuse the fs/crypto
> infrastructure, you could take advantage of the fact that this problem was
> already solved.

> Note: even better would be an authenticated encryption mode.  That isn't yet
> done by ext4 or f2fs --- I think because there wasn't a good place to store a
> per-page authentication tag.  It would be interesting to know whether this would
> be possible for btrfs.

  Yes. That's possible in btrfs. Encoders integration was planned quite
  early in the design. There are reserved spaces in the extent items.
  I should attempt straight to GCM AEAD then.


> I also noticed that unlike ext4 and f2fs, filenames and symlinks are not being
> encrypted in btrfs.  I know it may seem somewhat ad-hoc that filenames are
> encrypted but not other metadata, but apparently filenames were considered
> quite important and a lot of work went into making it possible to encrypt them
> in ext4.

  Can we use inode number as file name when there is no key ?
  And save real file name as encrypted attribute, a bit neater
  though.


> (Apologies if I misunderstood anything.  The proposal would be easier to review
> with a design document, as mentioned.)

  Nope your understanding is correct. Apologies I should have
  sent code later when doc is ready.

Thanks, Anand

> Hope this is helpful,
>
> Eric
>
