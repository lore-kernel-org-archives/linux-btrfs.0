Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36851 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbcHLRCi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 13:02:38 -0400
Received: by mail-oi0-f45.google.com with SMTP id f189so41887784oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 10:02:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <35417d9d-c3e4-6a3a-50e0-bdd91bf39f80@gmail.com>
References: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
 <35417d9d-c3e4-6a3a-50e0-bdd91bf39f80@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 12 Aug 2016 11:02:35 -0600
Message-ID: <CAJCQCtSCKdthhN5L_DChDPrAXJD75y-OSPCkX7KuZ6AkXcedSg@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2016 at 6:04 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-08-11 16:23, Dave T wrote:

>> 5. Would most of you guys use btrfs + dm-crypt on a production file
>> server (with spinning disks in JBOD configuration -- i.e., no RAID).
>> In this situation, the data is very important, of course. My past
>> experience indicated that RAID only improves uptime, which is not so
>> critical in our environment. Our main criteria is that we should never
>> ever have data loss. As far as I understand it, we do have to use
>> encryption.
>
> On a file server?  No, I'd ensure proper physical security is established
> and make sure it's properly secured against network based attacks and then
> not worry about it.  Unless you have things you want to hide from law
> enforcement or your government (which may or may not be legal where you
> live) or can reasonably expect someone to steal the system, you almost
> certainly don't actually need whole disk encryption.

Sure but then you need a fairly strict handling policy for those
drives when they leave the environment: e.g. for an RMA if the drive
dies under warranty, or when the drive is being retired. First there's
the actual physical handling (even interception) and accounting of all
of the drives, which has to be rather strict. And second, the fallback
to wiping the drive if it's dead must be physical destruction. For any
data not worth physically destroying the drive for proper disposal,
you can probably forego full disk encryption.


-- 
Chris Murphy
