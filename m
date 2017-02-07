Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48974 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754207AbdBGVhX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 16:37:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbDQJ-0000PK-43
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 22:35:39 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS for OLTP Databases
Date: Tue, 7 Feb 2017 22:35:38 +0100
Message-ID: <20170207223538.3c37c840@jupiter.sol.kaishome.de>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <20170207140058.GA4249@carfax.org.uk>
        <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
        <20170207213614.5fd40981@jupiter.sol.kaishome.de>
        <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
        <7204f2cf-bcb4-c943-b6d2-f9eb4b5b29cf@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 7 Feb 2017 22:25:29 +0100
schrieb Lionel Bouton <lionel-subscription@bouton.name>:

> Le 07/02/2017 à 21:47, Austin S. Hemmelgarn a écrit :
> > On 2017-02-07 15:36, Kai Krakow wrote:  
> >> Am Tue, 7 Feb 2017 09:13:25 -0500
> >> schrieb Peter Zaitsev <pz@percona.com>:
> >>  
>  [...]  
> >>
> >> Out of curiosity, I see one problem here:
> >>
> >> If you're doing snapshots of the live database, each snapshot
> >> leaves the database files like killing the database in-flight.
> >> Like shutting the system down in the middle of writing data.
> >>
> >> This is because I think there's no API for user space to subscribe
> >> to events like a snapshot - unlike e.g. the VSS API (volume
> >> snapshot service) in Windows. You should put the database into
> >> frozen state to prepare it for a hotcopy before creating the
> >> snapshot, then ensure all data is flushed before continuing.  
> > Correct.  
> >>
> >> I think I've read that btrfs snapshots do not guarantee single
> >> point in time snapshots - the snapshot may be smeared across a
> >> longer period of time while the kernel is still writing data. So
> >> parts of your writes may still end up in the snapshot after
> >> issuing the snapshot command, instead of in the working copy as
> >> expected.  
> > Also correct AFAICT, and this needs to be better documented (for
> > most people, the term snapshot implies atomicity of the
> > operation).  
> 
> Atomicity can be a relative term. If the snapshot atomicity is
> relative to barriers but not relative to individual writes between
> barriers then AFAICT it's fine because the filesystem doesn't make
> any promise it won't keep even in the context of its snapshots.
> Consider a power loss : the filesystems atomicity guarantees can't go
> beyond what the hardware guarantees which means not all current in fly
> write will reach the disk and partial writes can happen. Modern
> filesystems will remain consistent though and if an application using
> them makes uses of f*sync it can provide its own guarantees too. The
> same should apply to snapshots : all the writes in fly can complete or
> not on disk before the snapshot what matters is that both the snapshot
> and these writes will be completed after the next barrier (and any
> robust application will ignore all the in fly writes it finds in the
> snapshot if they were part of a batch that should be atomically
> commited).
> 
> This is why AFAIK PostgreSQL or MySQL with their default ACID
> compliant configuration will recover from a BTRFS snapshot in the
> same way they recover from a power loss.

This is what I meant in my other reply. But this is also why it should
be documented. Wrongly implying that snapshots are single point in time
snapshots is a wrong assumption with possibly horrible side effects one
wouldn't expect.

Taking a snapshot is like a power loss - even tho there is no power
loss. So the database has to be properly configured. It is simply short
sighted if you don't think about this fact. The documentation should
really point that fact out.


-- 
Regards,
Kai

Replies to list-only preferred.


