Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35177 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753240AbcITCrq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 22:47:46 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bmB5t-0004g3-6Z
        for linux-btrfs@vger.kernel.org; Tue, 20 Sep 2016 04:47:37 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Experimental btrfs encryption
Date: Tue, 20 Sep 2016 02:47:17 +0000 (UTC)
Message-ID: <nrq7vk$j27$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20160919151518.i2aon4axmfzt54rn@thunk.org>
 <nrpjhc$g72$3@blaine.gmane.org>
 <a8dc3c28-5629-d870-f202-de35d2f941f1@fb.com>

On Mon, 19 Sep 2016 20:32:34 -0400, Chris Mason wrote:

> On 09/19/2016 04:58 PM, Alex Elsayed wrote:

<snip>

>> When someone says "pretty simple" regarding cryptography, it's often
>> neither pretty nor simple :P
>>
>> The issue, here, is that inodes are fundamentally not a safe scope to
>> attach that information to in btrfs. As extents can be shared between
>> inodes (and thus both will need to decrypt them), and inodes can be
>> duplicated unmodified (snapshots), attaching keys and nonces to inodes
>> opens up a whole host of (possibly insoluble) issues, including
>> catastrophic nonce reuse via writable snapshots.
> 
> I'm going to have to read harder about nonce reuse.  In btrfs an inode
> is really a pair [ root id, inode number ], so strictly speaking two
> writable snapshots won't have the same inode in memory and when a
> snapshot is modified we'd end up with a different nonce for the new
> modifications.
> 
> This would lead to a chain, where reading an single modified file in a
> snapshot might require multiple different keys.  The btrfs metadata has
> what it needs to look these things up in the readpage call, but it ends
> up being much closer to per-extent encryption.

For reading about nonce reuse (and nonce-misuse-resistant AEAD), the best 
option to start with is likely Hoang, Krovetz, and Rogaway's "Robust 
Authenticated Encryption: AEZ and the problem it solves"

https://eprint.iacr.org/2014/793

For one of the first such schemes, it's likely of interest to read about 
SIV (Rogaway and Shrimpton):

http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/siv/
siv.pdf

A variant of SIV that can be efficiently realized using the same hardware 
acceleration as AES-GCM is AES-GCM-SIV (Gueron, Lindell):

https://eprint.iacr.org/2015/102

And for information on how catastrophic _ever_ reusing the same (nonce, 
key) pair is with plain GCM:

Nonce-Disrespecting Adversaries: Practical Forgery Attacks on GCM in TLS
(Böck, Zauner, Devlin, Somorovsky, Jovanovic)
https://eprint.iacr.org/2016/475

(The same applies to ChaCha20-Poly1305, and the vast majority of other 
AEADs that lack nonce-misuse-resistance).

