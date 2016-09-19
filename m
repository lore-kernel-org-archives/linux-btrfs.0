Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35769 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbcISU6u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 16:58:50 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bm5eI-0006Yl-9U
        for linux-btrfs@vger.kernel.org; Mon, 19 Sep 2016 22:58:46 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Experimental btrfs encryption
Date: Mon, 19 Sep 2016 20:58:20 +0000 (UTC)
Message-ID: <nrpjhc$g72$3@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20160919151518.i2aon4axmfzt54rn@thunk.org>

On Mon, 19 Sep 2016 11:15:18 -0400, Theodore Ts'o wrote:

> (I'm not on linux-btrfs@, so please keep me on the cc list.  Or perhpas
> better yet, maybe we can move discussion to the linux-fsdevel@
> list.)

I apologize if this doesn't keep you in the CC, as I'm posting via gmane.

> Hi Anand,
> 
> After reading this thread on the web archives, and seeing that some
> folks seem to be a bit confused about "vfs level crypto", fs/crypto,
> and ext4/f2fs encryption, I thought I would give a few comments.
> 
> First of all, these are all the same thing.  Initially ext4 encryption
> was implemented targetting ChromeOS as the initial customer, and as a
> replacement for ecryptfs.  Folks have already pointed you at the design
> document[1].  Also of interest is the is the 2015 Linux Security
> Symposium slides set[2].  The first deployed use of this was for Android
> N's File-based Encryption and Direct boot[3]; a technical description
> which left out some of the product details (since LSS 2016 was before
> the Android N release) can be found at the 2016 LSS slides[4].
> 
> [1]
> https://docs.google.com/document/
d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg/preview
> [2] http://kernsec.org/files/lss2014/Halcrow_EXT4_Encryption.pdf [3]
> https://android.googleblog.com/2016/08/android-70-nougat-more-powerful-
os-made.html
> [4] http://kernsec.org/files/lss2015/halcrow.pdf
> 
> The other thing that perhaps would be worth noting is that Michael
> Halcrow started this as an encryption/security expert who had dabbled in
> file systems, while I was someone for whom encryption/security is a
> hobby (although in a previous life I was the tech lead for Kerberos and
> chaired the IPSEC working group) who was a file system expert.  In order
> to do file system security well, you need people who are well versed in
> both discplines working together.
> 
> With all due respect, the fact that you chose counter mode and how use
> used it pretty clearly demonstrates that you would be well advised to
> find someone who is a crypto expert to collaborate with you --- or use
> the fs/crypto framework since it was designed and vetted by multiple
> crypto experts as well as file system experts.

100% agreed on the former, and mostly agreed on the latter (though I feel 
that even applying fs/crypto to btrfs includes sufficient novelty as to 
require very careful review by crypto experts).

> Having someone who is a product manager who can discuss with you
> specific goals is also important, because there are lots of tradeoffs
> and lots of design choices ---- and so what you chose to do is (or at
> least should be!)  very much dependent on your threat model, who is
> planning on using the feature, what you can and can not upon via-a-vis
> hardware support, performance requirements, and so on.
> 
> 
> Secondly, in terms of how it all works.  Each user as a "master key"
> which is stored on a keyring.  We use a hash of the key to serve as the
> key identifier, and associated with each inode we store a nonce (a
> random unique string) and the key identifier.  We use the nonce and the
> user's master key to generate a unique key for that inode.

As noted in my discussions with Zygo Blaxell, this is one of the places 
where applying fs/crypto to btrfs without careful reexamination would 
fail badly - using the inode will not work.

> That key is used to protect the contents of the data file, and to
> encrypt filenames and symlink targets --- since filenames can leak
> significant information about what the user is doing.  (For example,
> in the downloads directory of their web browser, leaking filenames is
> just as good as leaking part of their browsing history.)
>
> As far as using the fs/crypto infrastructure, it's actually pretty
> simple.  The file system needs to provide a flag indicating whether or
> not the file is encrypted, and support extended attributes.  When you
> create an inode in an encrypted directory, you call
> fscrypt_inherit_context() and the fscrypto layer will take care of
> creating the necessary xattr for the per-inode key.  When you need open
> a encrypted file, or operate on an encrypted inode, you call
> fscrypt_get_encryption_info() on the inode.  The per-inode encryption
> key is cached in the i_crypt_info structure, which hangs off of the
> struct inode.

When someone says "pretty simple" regarding cryptography, it's often 
neither pretty nor simple :P

The issue, here, is that inodes are fundamentally not a safe scope to 
attach that information to in btrfs. As extents can be shared between 
inodes (and thus both will need to decrypt them), and inodes can be 
duplicated unmodified (snapshots), attaching keys and nonces to inodes 
opens up a whole host of (possibly insoluble) issues, including 
catastrophic nonce reuse via writable snapshots.

> When you write to an encrypted file, you call fscrypt_encrypt_page(),
> which returns a struct page with the encrypted contents to be written.
> After the write is completed (or in the error case), you call
> fscrypt_restore_control_page() to release encrypted page.
> 
> To read from an encrypted page, you call fscrypt_get_ctx() to get an
> encryption context, which gets stashed in the bio's bi_private pointer. 
> (If btrfs is already using bi_private, then you'll need to add a field
> in the structure which hangs off of bi_private to stash the encryption
> context.)  After the read completes, you call
> fscrypt_decrypt_bio_pages() to decrypt all of the pages read as part of
> the read/write operation.
> 
> It's actually relatively straightforward to use.  If you have any
> questions please feel free to ask on linux-fsdevel.

Straightforward to use, yes. Straightforward to use _securely_ with btrfs 
in particular, undetermined.

> As far as poeple commenting that it might be better to encrypt on the
> extent level --- the reason why we didn't chose that path is because
> while it does make it easier to do authenticated encryption modes, the
> downside is that you can only do the data integrity check if you read in
> the entire extent.  This has obvious memory utilization impacts and will
> also impact your 4k random read/write performance.

It does, yes, but btrfs already does this with compression. I'd suggest 
that's a pretty good argument  for it being at least potentially 
acceptable.

> We do have a solution in mind to solve the authenticated encryption
> problem; in fact, an intern has recently finished a prototype using
> Authenticated Skip Lists[5][6].  Hopefully we'll be able to get some
> patches for review in the near future.
> 
> [5] http://cs.brown.edu/cgc/stms/papers/hashskip.pdf [6]
> http://cs.brown.edu/cgc/stms/papers/discex2001.pdf

That's fascinating, and I'll have to read it in-depth later - thank you 
for the links!

> One of the challenges with data integrity is that you need to be able to
> update authentication data and the data blocks atomically, or else you
> could end up breaking the file on a crash.  For ext4, we're going to
> simply only support data integrity for those files which are written and
> then closed, and if you crash, the file which is being written may not
> have valid data integrity checksums.  This is good enough for many use
> cases, since most files are not updated after they are initially
> written.  Obviously, btrfs would be able to do much better since it has
> COW properties.

Makes sense.

