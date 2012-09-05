Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2IEVXw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 17:23:52 -0400
Received: by iahk25 with SMTP id k25so1301760iah.19
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Sep 2012 14:23:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120905150402.GK17430@twin.jikos.cz>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
 <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
 <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
 <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
 <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
 <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
 <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com>
 <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com>
 <20120902054410.GG17430@twin.jikos.cz> <CAGDaZ_r1zZWGh5riLnNnZR8raZZQNwSe0qSNgY3BaBWN-A9Fbg@mail.gmail.com>
 <20120905150402.GK17430@twin.jikos.cz>
From: Shentino <shentino@gmail.com>
Date: Wed, 5 Sep 2012 14:23:11 -0700
Message-ID: <CAGDaZ_qDF31tLfKLKCWDSH33yBoqucMQGpAM_9h7kb1bGz-1qw@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
To: dave@jikos.cz, Shentino <shentino@gmail.com>, Michael <mike@draftx.net>,
        cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 5, 2012 at 8:04 AM, David Sterba <dave@jikos.cz> wrote:
> On Sun, Sep 02, 2012 at 04:43:48AM -0700, Shentino wrote:
>> I assume the same results are expected during a scrub as during a normal read?
>
> yes
>
>> > I've tested this on an 2 disk data/raid1, metadata/raid1 with a running
>> > dd over one of the devices continually and using the filesystem. It was
>> > slower.
>>
>> Would I be correct to assume that a core dump on fsck is an automatic
>> bug or is using the old 3.3.8 kernel a taint that would invalidate a
>> report?  Note that this is for the btrfs-progs containing the fsck,
>> not the actual kernel side code.
>
> You're talking about fsck and kernel, I'm not quite sure which one do
> you refer to with 'bug'.
>
> fsck can crash when it finds unexpected data in the tree structures,
> but this would mean that it passed through the checksum verification
> earlier. This would be a bug, and if it is reproducible on newer kernels
> a report on 3.3.x does not disqualify it right away.
>
> Same holds for kernel, a datastructure inconsistency will most probably
> lead to a BUG and subsequent crash.
>
> david

By this I mean running fsck on a btrfs that was trashed by a 3.3.8 kernel bug.
