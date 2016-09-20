Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33904 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753816AbcITDFt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 23:05:49 -0400
Received: by mail-pa0-f51.google.com with SMTP id wk8so1897624pab.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 20:05:49 -0700 (PDT)
From: Alex Elsayed <eternaleye@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Experimental btrfs encryption
Date: Mon, 19 Sep 2016 20:05:37 -0700
Message-ID: <2482412.ISOtnf003W@arkadios>
In-Reply-To: <20160920025041.mzeljxxzclikktxn@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20160919151518.i2aon4axmfzt54rn@thunk.org>
 <a8dc3c28-5629-d870-f202-de35d2f941f1@fb.com>
 <20160920025041.mzeljxxzclikktxn@thunk.org>

Taking a stab at a different way of replying, to try and keep Ted in the loop.

On Monday, 19 September 2016 22:50:41 PDT Theodore Ts'o wrote:
> On Mon, Sep 19, 2016 at 08:32:34PM -0400, Chris Mason wrote:
> > > > That key is used to protect the contents of the data file, and to
> > > > encrypt filenames and symlink targets --- since filenames can leak
> > > > significant information about what the user is doing.  (For example,
> > > > in the downloads directory of their web browser, leaking filenames is
> > > > just as good as leaking part of their browsing history.)
> > 
> > One of the things that makes per-subvolume encryption attractive to me is
> > that we're able to enforce the idea that an entire directory tree is
> > encrypted by one key.  It can't be snapshotted again without the key, and
> > it just fits with the rest of the btrfs management code.  I do want to
> > support the existing vfs interfaces as well too though.
> 
> One of the main reasons for doing fs-level encryption is so you can
> allow multiple users to have different keys.  In some cases you can
> assume that different users will be in different distinct subvolumes
> (e.g., each user has their own home directory), but that's not always
> going to be possible.

Mm, that's definitely something to keep in mind.

> One of the other things that was in the original design, but which got
> dropped in our initial implementation, was the concept of having the
> per-inode key wrapped by multiple user keys.  This would allow a file
> to be accessible by more than one user.  So something to consider is
> that there may very well be situations where you *want* to have more
> than one key associated with a directory hierarchy.

Makes sense.

> > > The issue, here, is that inodes are fundamentally not a safe scope to
> > > attach that information to in btrfs. As extents can be shared between
> > > inodes (and thus both will need to decrypt them), and inodes can be
> > > duplicated unmodified (snapshots), attaching keys and nonces to inodes
> > > opens up a whole host of (possibly insoluble) issues, including
> > > catastrophic nonce reuse via writable snapshots.
> > 
> > I'm going to have to read harder about nonce reuse.  In btrfs an inode is
> > really a pair [ root id, inode number ], so strictly speaking two writable
> > snapshots won't have the same inode in memory and when a snapshot is
> > modified we'd end up with a different nonce for the new modifications.
> 
> Nonce reuse is not necessrily catastrophic.  It all depends on the
> context.  In the case of Counter or GCM mode, nonce (or IV) reuse is
> absolutely catastrophic.  It must *never* be done or you completely
> lose all security.  As the Soviets discovered the hard way courtesy of
> the Venona project (well, they didn't discover it until after they
> lost the cold war, but...) one time pads are completely secure.
> Two-time pads, are most emphatically _not_.  :-)

Aaaand now I wish I'd seen this before I sent my Big Ol' Mail Full of 
References to Chris, so I could have tried this and kept you on CC.

> In the case of the nonces used in fscrypt's key derivation, reuse of
> the nonce basically means that two files share the same key.  Assuming
> you're using a competently designed block cipher (e.g., AES), reuse of
> the key is not necessarily a problem.  What it would mean is that two
> files which are are reflinked would share the same key.  And if you
> have writable snapshots, that's definitely not a problem, since with
> AES we use the a fixed key and a fixed IV given a logical block
> number, and we can do block overwrites without having to guarantee
> unique nonces (which you *do* need to worry about if you use counter
> mode or some other stream cipher such as ChaCha20 --- Kent Overstreet
> had some clever tricks to avoid IV reuse since he used a stream cipher
> in his proposed bcachefs encryption).

Er, not quite on the "safe" bit - part of the problem is that without going 
AEAD, you lose out on a good bit of security relative to GCM without reusing 
nonces. The reason (say) EME or CMC are safe for block-overwrite is actually 
_not_ that they're block ciphers - it's that they implement a security notion 
called SPRP, Strong Pseudorandom Permutation, which has a direct equivalence 
with misuse-resistant AEAD. XTS _not_ meeting that is in fact exactly why it's 
not as strong.

If you take an SPRP, reserve `p` bits at the end for zeroes, fill the rest with 
your message, and encrypt it, the result is _exactly_ a misuse-resistant AEAD 
with `p`-bit integrity. Modern misuse-resistant AEADs differ from EME and CMC 
only in 1.) efficiency and 2.) supporting variable-length messages.

> The main issue is if you want to reflink a file and then have the two
> files have different permissions / ownerships.  In that case, you
> really want to use different keys for user A and for user B --- but if
> you are assuming a single key per subvolume, you can't support
> different keys for different users anyway, so you're kind of toast for
> that use case in any case.

Mm.

> So in any case, assuming you're using block encryption (which is what
> fscrypt uses) there really isn't a problem with nonce reuse, although
> in some cases if you really do want to reflink a file and have it be
> protected by different user keys, this would have to force copy of the
> duplicated blocks at that point.  But arguably, that is a feature, not
> a bug.  If the two users are mutually suspicious, you don't _want_ to
> leak information about who much of a particular file had been changed
> by a particular user.  So you would want to break the reflink and have
> separate copies for both users anyway.

Agreed.

> One final thought --- something which is really going to be a factor
> in many use cases is going to be hardware accelerated encryption.  For
> example, Qualcomm is already shipping an SOC where the encryption can
> be done in the data path between the CPU and the eMMC storage device.
> If you want to support certain applications that try to read megabytes
> and megabytes of data before painting a single pixel, in-line hardware
> crypto at line speeds is going to be critical if you don't want to
> sacrifice performance, and keep users from being cranky because it
> took extra seconds before they could start reading their news feed (or
> saving bird eggs from voracious porcine predators, or whatever).

I heavily recommend reading the AES-GCM-SIV paper from my response to Chris - 
it uses exactly the same hardware acceleration as GCM, but achieves nonce-
misuse-resistance. Less than one cycle per byte, too.

> This may very well be an issue in the future not just for mobile
> devices, but I could imagine this potentially being an issue for other
> form factors as well.  Yes, Skylake can encrypt multiple bytes per
> clock cycle using the miracles of hardware acceleration and
> pipelining.  But in-line encryption will still have the advantage of
> avoiding the memory bandwidth costs.  So while it is fun to talk about
> exotic encryption modes, it would be wise to have file system
> encryption architectures to have modes which are compatible with
> hardware in-line encryption schemes.

Considering AES-GCM-SIV is being heavily considered for use in TLS 1.3, that 
may well be viable.

> This is also why I'm not all that excited by Kent's work trying to
> implement fast encryption using a stream cipher such as Chacha20.
> Technically, it's interesting, sure.  But on most modern systems, you
> will either have really really good AES acceleration (any recent x86
> system), or you will probably have at your disposal a hardware in-line
> cyptographic engine (ICE) that is going to be way faster than Chacha20
> implemented in software, and it means you don't have to go to extreme
> lengths to avoid never reusing a nonce or risk losing all security
> guarantees.  Block ciphers are much safer, and with hardware support,
> any speed advantage of using a stream cipher disappears; indeed, a
> stream cipher in software will be slower than a hardware accelerated
> block cipher.

I agree regarding ChaCha20 (The cases it's good for - devices without AES - 
are already fading, with deep embedded using AES-CTR-CCM and mobile gaining 
AES-GCM accel), but I really think that nonce-misuse-resistant AEAD is going 
to be incredibly important to keep in mind.

In crypto, it's far more often a subtle tool misapplied that causes problems 
than anything else - and both non-AEAD (due to CCA2) and nonce-dependent AEAD 
(due to nonce misuse catastrophes) are subtle tools indeed. Nonce-misuse-
resistant AEAD is a much less subtle tool.

