Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19481 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765164AbcIOLcI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 07:32:08 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Alex Elsayed <eternaleye@gmail.com>, linux-btrfs@vger.kernel.org
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <nrd9ge$hdn$1@blaine.gmane.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <542bb47d-c035-2b49-a39a-074a792af215@oracle.com>
Date: Thu, 15 Sep 2016 19:33:48 +0800
MIME-Version: 1.0
In-Reply-To: <nrd9ge$hdn$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for commenting. pls see inline below.

On 09/15/2016 12:53 PM, Alex Elsayed wrote:
> On Tue, 13 Sep 2016 21:39:46 +0800, Anand Jain wrote:
>
>> This patchset adds btrfs encryption support.
>>
>> The main objective of this series is to have bugs fixed and stability.
>> I have verified with fstests to confirm that there is no regression.
>>
>> A design write-up is coming next, however here below is the quick
>> example on the cli usage. Please try out, let me know if I have missed
>> something.
>>
>> Also would like to mention that a review from the security experts is
>> due,
>> which is important and I believe those review comments can be
>> accommodated without major changes from here.
>>
>> Also yes, thanks for the emails, I hear, per file encryption and inline
>> with vfs layer is also important, which is wip among other things in the
>> list.
>>
>> As of now these patch set supports encryption on per subvolume, as
>> managing properties on per subvolume is a kind of core to btrfs, which
>> is easier for data center solution-ing, seamlessly persistent and easy
>> to manage.
>>
>>
>> Steps:
>> -----
>>
>> Make sure following kernel TFMs are compiled in.
>> # cat /proc/crypto | egrep 'cbc\(aes\)|ctr\(aes\)'
>> name         : ctr(aes)
>> name         : cbc(aes)
>
> First problem: These are purely encryption algorithms, rather than AE
> (Authenticated Encryption) or AEAD (Authenticated Encryption with
> Associated Data). As a result, they are necessarily vulnerable to
> adaptive chosen-ciphertext attacks, and CBC has historically had other
> issues. I highly recommend using a well-reviewed AE or AEAD mode, such as
> AES-GCM (as ecryptfs does), as long as the code can handle the ciphertext
> being longer than the plaintext.
>
> If it _cannot_ handle the ciphertext being longer than the plaintext,
> please consider that a very serious red flag: It means that you cannot
> provide better security than block-level encryption, which greatly
> reduces the benefit of filesystem-integrated encryption. Being at the
> extent level _should_ permit using AEAD - if it does not, something is
> wrong.
>
> If at all possible, I'd suggest _only_ permitting AEAD cipher modes to be
> used.
>
> Anyway, even for block-level encryption, CTR and CBC have been considered
> obsolete and potentially dangerous to use in disk encryption for quite a
> while - current recommendations for block-level encryption are to use
> either a narrow-block tweakable cipher mode (such as XTS), or a wide-
> block one (such as EME or CMC), with the latter providing slightly better
> security, but worse performance.

   Yes. CTR should be changed, so I have kept it as a cli option. And
   with the current internal design, hope we can plugin more algorithms
   as suggested/if-its-outdated and yes code can handle (or with a little
   tweak) bigger ciphertext (than plaintext) as well.

   encryption + keyhash (as below) + Btrfs-data-checksum provides
   similar to AE,  right ?


>> Create encrypted subvolume.
>> # btrfs su create -e 'ctr(aes)' /btrfs/e1 Create subvolume '/btrfs/e1'
>> Passphrase:
>> Again passphrase:
>
> I presume the command first creates a key, then creates a subvolume
> referencing that key? If so, that seems sensible.

  Hmm I didn't get the why part, any help ? (this doesn't encrypt
  metadata part).

>> A key is created and its hash is updated into the subvolume item,
>> and then added to the system keyctl.
>> # btrfs su show /btrfs/e1 | egrep -i encrypt
>> 	Encryption: 		ctr(aes)@btrfs:75197c8e (594790215)
>>
>> # keyctl show 594790215 Keyring
>>  594790215 --alsw-v      0     0  logon: btrfs:75197c8e
>
> That's entirely reasonable, though you may want to support "trusted and
> encrypted keys" (Documentation/security/keys-trusted-encrypted.txt)

   Yes. that's in the list.

>> Now any file data extents under the subvol /btrfs/e1 will be encrypted.
>>
>> You may revoke key using keyctl or btrfs(8) as below.
>> # btrfs su encrypt -k out /btrfs/e1
>>
>> # btrfs su show /btrfs/e1 | egrep -i encrypt
>> 	Encryption: 		ctr(aes)@btrfs:75197c8e (Required key not
> available)
>>
>> # keyctl show 594790215 Keyring Unable to dump key: Key has been revoked
>>
>> As the key hash is updated, If you provide wrong passphrase in the next
>> key in, it won't add key to the system. So we have key verification from
>> the day1.
>
> This is good.

   Thanks.

Thanks, Anand


>> # btrfs su encrypt -k in /btrfs/e1 Passphrase:
>> Again passphrase:
>> ERROR: failed to set attribute 'btrfs.encrypt' to
>> 'ctr(aes)@btrfs:75197c8e' : Key was rejected by service
>>
>> ERROR: key set failed: Key was rejected by service
>>
>> # btrfs su encrypt -k in /btrfs/e1 Passphrase:
>> Again passphrase:
>> key for '/btrfs/e1' has  logged in with keytag 'btrfs:75197c8e'
>>
>> Now if you revoke the key the read / write fails with key error.
>>
>> # md5sum /btrfs/e1/2k-test-file 8c9fbc69125ebe84569a5c1ca088cb14
>> /btrfs/e1/2k-test-file
>>
>> # btrfs su encrypt -k out /btrfs/e1
>>
>> # md5sum /btrfs/e1/2k-test-file md5sum: /btrfs/e1/2k-test-file: Key has
>> been revoked
>>
>> # cp /tfs/1k-test-file /btrfs/e1/
>> cp: cannot create regular file ‘/btrfs/e1/1k-test-file’: Key has been
>> revoked
>>
>> Plain text memory scratches for security reason is pending. As there are
>> some key revoke notification challenges to coincide with encryption
>> context switch,
>> which I do believe should be fixed in the due course, but is not a
>> roadblock at this stage.
>>
>> Thanks, Anand
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
