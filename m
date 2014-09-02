Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62981 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaIBXH1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 19:07:27 -0400
Received: by mail-pa0-f43.google.com with SMTP id et14so15854983pad.30
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 16:07:27 -0700 (PDT)
Message-ID: <54064DAC.9050602@converseincode.com>
Date: Tue, 02 Sep 2014 16:07:24 -0700
From: Behan Webster <behanw@converseincode.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Alasdair Kergon <agk@redhat.com>, clm@fb.com,
        "David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
        Fabian Frederick <fabf@skynet.be>,
        Herbert Xu <herbert@gondor.apana.org.au>, jbacik@fb.com,
        snitzer@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        james.l.morris@oracle.com, john.johansen@canonical.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
        linux-security-module@vger.kernel.org, neilb@suse.de, serge@hallyn.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 0/6] LLVMLinux: Patches to enable the kernel to be
 compiled with clang/LLVM
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com> <05DCB0B8-AA7C-495F-B8E6-0803052DD273@holtmann.org>
In-Reply-To: <05DCB0B8-AA7C-495F-B8E6-0803052DD273@holtmann.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/14 16:01, Marcel Holtmann wrote:
> Hi Behan,
>
>> These patches remove the use of Variable Length Arrays In Structs (VLAIS) in
>> crypto related code. Presented here for comments as a whole (since they all do
>> the same thing in the same way). Once everyone is happy I will submit them
>> individually to their appropriate maintainers.
>>
>> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
>> clang (the C front end for the LLVM compiler infrastructure project).
>>
>>
>> Jan-Simon Möller (4):
>>   crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
>>   crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
>>   crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
>>   crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
>>
>> Vinícius Tinti (2):
>>   apparmor: LLVMLinux: Remove VLAIS
>>   btrfs: LLVMLinux: Remove VLAIS
>>
>> crypto/hmac.c              | 27 +++++++++++++--------------
>> crypto/testmgr.c           | 16 ++++++++--------
>> drivers/md/dm-crypt.c      | 38 ++++++++++++++++++--------------------
>> fs/btrfs/hash.c            | 18 +++++++++---------
>> lib/libcrc32c.c            | 18 +++++++++---------
>> security/apparmor/crypto.c | 19 +++++++++----------
>> 6 files changed, 66 insertions(+), 70 deletions(-)
> are you sure these are all of them? I know for a fact that we are using the same construct in net/bluetooth/amp.c as well.
There have been other places where this was an issue before too (ext4, 
mac80211, USB gadget, ...). Some have already been fixed.

Hmm. Yeah, I thought we had a patch for bluetooth too. I can't find it 
now though.

Suffice it to say that similar patches are required for the other 
instances of this kind of code elsewhere as well.

Thanks Marcel,

Behan

-- 
Behan Webster
behanw@converseincode.com

