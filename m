Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48383 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2IBLo2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Sep 2012 07:44:28 -0400
Received: by ieje11 with SMTP id e11so2775108iej.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Sep 2012 04:44:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120902054410.GG17430@twin.jikos.cz>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
 <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
 <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
 <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
 <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
 <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
 <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com>
 <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com> <20120902054410.GG17430@twin.jikos.cz>
From: Shentino <shentino@gmail.com>
Date: Sun, 2 Sep 2012 04:43:48 -0700
Message-ID: <CAGDaZ_r1zZWGh5riLnNnZR8raZZQNwSe0qSNgY3BaBWN-A9Fbg@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
To: dave@jikos.cz, Shentino <shentino@gmail.com>, Michael <mike@draftx.net>,
        cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 1, 2012 at 10:44 PM, David Sterba <dave@jikos.cz> wrote:
> On Sat, Sep 01, 2012 at 06:03:32PM -0700, Shentino wrote:
>> This whole subject was also about using sed to corrupt-o-magic a
>> file's data on disk.
>>
>> Is this an acceptable method for testing?
>
> Starting with kernels 3.4 the error handling has been improved,
> namely for the EIO, so it shouldn't take your box down when you hit one.
> Newer kernels got fixes to the 'transaction abort' cleanup, so it should
> be possible to umount and mount the filesystem without problems.
>
> The filesystem should survive shooting at blocks, the checksums catch
> any change (with respect to it's strength, ie. generating a hash
> collision will lead to crash/abort later).
>
> Expected result for reading blocks after random writes is:
> * EIO for the corrupted block (both data or metadata) provided that
>   there's no other copy
> * transparent and automatic repair from other copies

I assume the same results are expected during a scrub as during a normal read?

> I've tested this on an 2 disk data/raid1, metadata/raid1 with a running
> dd over one of the devices continually and using the filesystem. It was
> slower.
>
>
> david

Would I be correct to assume that a core dump on fsck is an automatic
bug or is using the old 3.3.8 kernel a taint that would invalidate a
report?  Note that this is for the btrfs-progs containing the fsck,
not the actual kernel side code.
