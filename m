Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57755 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755261AbcIOLrh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 07:47:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkV8d-0000ht-Ru
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 13:47:31 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Date: Thu, 15 Sep 2016 11:47:21 +0000 (UTC)
Message-ID: <nre1o9$hdn$2@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <nrd9ge$hdn$1@blaine.gmane.org>
        <542bb47d-c035-2b49-a39a-074a792af215@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 15 Sep 2016 19:33:48 +0800, Anand Jain wrote:

> Thanks for commenting. pls see inline below.
> 
> On 09/15/2016 12:53 PM, Alex Elsayed wrote:
>> On Tue, 13 Sep 2016 21:39:46 +0800, Anand Jain wrote:
>>
>>> This patchset adds btrfs encryption support.
>>>
>>> The main objective of this series is to have bugs fixed and stability.
>>> I have verified with fstests to confirm that there is no regression.
>>>
>>> A design write-up is coming next, however here below is the quick
>>> example on the cli usage. Please try out, let me know if I have missed
>>> something.
>>>
>>> Also would like to mention that a review from the security experts is
>>> due,
>>> which is important and I believe those review comments can be
>>> accommodated without major changes from here.
>>>
>>> Also yes, thanks for the emails, I hear, per file encryption and
>>> inline with vfs layer is also important, which is wip among other
>>> things in the list.
>>>
>>> As of now these patch set supports encryption on per subvolume, as
>>> managing properties on per subvolume is a kind of core to btrfs, which
>>> is easier for data center solution-ing, seamlessly persistent and easy
>>> to manage.
>>>
>>>
>>> Steps:
>>> -----
>>>
>>> Make sure following kernel TFMs are compiled in.
>>> # cat /proc/crypto | egrep 'cbc\(aes\)|ctr\(aes\)'
>>> name         : ctr(aes)
>>> name         : cbc(aes)
>>
>> First problem: These are purely encryption algorithms, rather than AE
>> (Authenticated Encryption) or AEAD (Authenticated Encryption with
>> Associated Data). As a result, they are necessarily vulnerable to
>> adaptive chosen-ciphertext attacks, and CBC has historically had other
>> issues. I highly recommend using a well-reviewed AE or AEAD mode, such
>> as AES-GCM (as ecryptfs does), as long as the code can handle the
>> ciphertext being longer than the plaintext.
>>
>> If it _cannot_ handle the ciphertext being longer than the plaintext,
>> please consider that a very serious red flag: It means that you cannot
>> provide better security than block-level encryption, which greatly
>> reduces the benefit of filesystem-integrated encryption. Being at the
>> extent level _should_ permit using AEAD - if it does not, something is
>> wrong.
>>
>> If at all possible, I'd suggest _only_ permitting AEAD cipher modes to
>> be used.
>>
>> Anyway, even for block-level encryption, CTR and CBC have been
>> considered obsolete and potentially dangerous to use in disk encryption
>> for quite a while - current recommendations for block-level encryption
>> are to use either a narrow-block tweakable cipher mode (such as XTS),
>> or a wide- block one (such as EME or CMC), with the latter providing
>> slightly better security, but worse performance.
> 
>    Yes. CTR should be changed, so I have kept it as a cli option. And
>    with the current internal design, hope we can plugin more algorithms
>    as suggested/if-its-outdated and yes code can handle (or with a
>    little tweak) bigger ciphertext (than plaintext) as well.
> 
>    encryption + keyhash (as below) + Btrfs-data-checksum provides
>    similar to AE,  right ?

No, it does not provide anything remotely similar to AE. AE requires 
_cryptographic_ authentication of the data. Not only is a CRC (as Btrfs 
uses for the data checksum) not enough, a _cryptographic hash_ (such as 
SHA256) isn't even enough. A MAC (message authentication code) is 
necessary.

Moreover, combining an encryption algorithm and a MAC is very easy to get 
wrong, in ways that absolutely ruin security - as an example, see the 
Vaudenay/Lucky13 padding oracle attacks on TLS.

In order for this to be secure, you need to use a secure encryption 
system that also authenticates the data in a cryptographically secure 
manner. Certain schemes are well-studied and believed to be secure - AES-
GCM and ChaCha20-Poly1305 are common and well-regarded, and there's a 
generic security reduction for Encrypt-then-MAC constructions (using CTR 
together with HMAC in such a construction is generally acceptable).

The Btrfs data checksum is wholly inadequate, and the keyhash is a non-
sequitur - it prevents accidentally opening the subvolume with the wrong 
key, but neither it (nor the btrfs data checksum, which is a CRC rather 
than a cryptographic MAC) protect adequately against malicious corruption 
of the ciphertext.

I'd suggest pulling in Herbert Xu, as he'd likely be able to tell you 
what of the Crypto API is actually sane to use for this.

>>> Create encrypted subvolume.
>>> # btrfs su create -e 'ctr(aes)' /btrfs/e1 Create subvolume '/btrfs/e1'
>>> Passphrase:
>>> Again passphrase:
>>
>> I presume the command first creates a key, then creates a subvolume
>> referencing that key? If so, that seems sensible.
> 
>   Hmm I didn't get the why part, any help ? (this doesn't encrypt
>   metadata part).

Basically, if your tool merely sets up an entry in the kernel keyring, 
then calls the subvolume creation interface (passing in the key ID), then 
it can be composed with more advanced tooling that generates the key in a 
different manner.

If, instead, you call the subvolume creation API with a flag saying 
"please also create a key", then it does not compose and is inflexible.

That then becomes an obstacle to later extensions, such as trusted & 
encrypted keys.

>>> A key is created and its hash is updated into the subvolume item,
>>> and then added to the system keyctl.
>>> # btrfs su show /btrfs/e1 | egrep -i encrypt
>>> 	Encryption: 		ctr(aes)@btrfs:75197c8e (594790215)
>>>
>>> # keyctl show 594790215 Keyring
>>>  594790215 --alsw-v      0     0  logon: btrfs:75197c8e
>>
>> That's entirely reasonable, though you may want to support "trusted and
>> encrypted keys" (Documentation/security/keys-trusted-encrypted.txt)
> 
>    Yes. that's in the list.
> 

Okay, good to hear!

<snip>

