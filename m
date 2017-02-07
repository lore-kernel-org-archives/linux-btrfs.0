Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:60510 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753201AbdBGV1J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 16:27:09 -0500
Subject: Re: BTRFS for OLTP Databases
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <20170207213614.5fd40981@jupiter.sol.kaishome.de>
 <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <7204f2cf-bcb4-c943-b6d2-f9eb4b5b29cf@bouton.name>
Date: Tue, 7 Feb 2017 22:25:29 +0100
MIME-Version: 1.0
In-Reply-To: <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/02/2017 à 21:47, Austin S. Hemmelgarn a écrit :
> On 2017-02-07 15:36, Kai Krakow wrote:
>> Am Tue, 7 Feb 2017 09:13:25 -0500
>> schrieb Peter Zaitsev <pz@percona.com>:
>>
>>> Hi Hugo,
>>>
>>> For the use case I'm looking for I'm interested in having snapshot(s)
>>> open at all time.  Imagine  for example snapshot being created every
>>> hour and several of these snapshots  kept at all time providing quick
>>> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
>>> think you also describe)  nodatacow  does not provide any advantage.
>>
>> Out of curiosity, I see one problem here:
>>
>> If you're doing snapshots of the live database, each snapshot leaves
>> the database files like killing the database in-flight. Like shutting
>> the system down in the middle of writing data.
>>
>> This is because I think there's no API for user space to subscribe to
>> events like a snapshot - unlike e.g. the VSS API (volume snapshot
>> service) in Windows. You should put the database into frozen state to
>> prepare it for a hotcopy before creating the snapshot, then ensure all
>> data is flushed before continuing.
> Correct.
>>
>> I think I've read that btrfs snapshots do not guarantee single point in
>> time snapshots - the snapshot may be smeared across a longer period of
>> time while the kernel is still writing data. So parts of your writes
>> may still end up in the snapshot after issuing the snapshot command,
>> instead of in the working copy as expected.
> Also correct AFAICT, and this needs to be better documented (for most
> people, the term snapshot implies atomicity of the operation).

Atomicity can be a relative term. If the snapshot atomicity is relative
to barriers but not relative to individual writes between barriers then
AFAICT it's fine because the filesystem doesn't make any promise it
won't keep even in the context of its snapshots.
Consider a power loss : the filesystems atomicity guarantees can't go
beyond what the hardware guarantees which means not all current in fly
write will reach the disk and partial writes can happen. Modern
filesystems will remain consistent though and if an application using
them makes uses of f*sync it can provide its own guarantees too. The
same should apply to snapshots : all the writes in fly can complete or
not on disk before the snapshot what matters is that both the snapshot
and these writes will be completed after the next barrier (and any
robust application will ignore all the in fly writes it finds in the
snapshot if they were part of a batch that should be atomically commited).

This is why AFAIK PostgreSQL or MySQL with their default ACID compliant
configuration will recover from a BTRFS snapshot in the same way they
recover from a power loss.

Lionel
