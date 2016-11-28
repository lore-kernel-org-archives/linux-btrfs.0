Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36451 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbcK1DxG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 22:53:06 -0500
Received: by mail-lf0-f46.google.com with SMTP id t196so86854163lff.3
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Nov 2016 19:53:05 -0800 (PST)
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
To: Christoph Anton Mitterer <calestyo@scientia.net>, kreijack@inwind.it,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <1480304269.6254.6.camel@scientia.net>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <bcbc1321-7a82-f13c-ccf6-91821aab2eac@gmail.com>
Date: Mon, 28 Nov 2016 06:53:02 +0300
MIME-Version: 1.0
In-Reply-To: <1480304269.6254.6.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

28.11.2016 06:37, Christoph Anton Mitterer пишет:
> On Sat, 2016-11-26 at 14:12 +0100, Goffredo Baroncelli wrote:
>> I cant agree. If the filesystem is mounted read-only this behavior
>> may be correct; bur in others cases I don't see any reason to not
>> correct wrong data even in the read case. If your ram is unreliable
>> you have big problem anyway.
> 
> I'd agree with that - more or less.
> 
> If the memory is broken, then even without repairing (on read) a
> filesystem that is written to will likely be further corrupted.
> 
> 
> I think for safety it's best to repair as early as possible (and thus
> on read when a damage is detected), as further  blocks/devices may fail
> till eventually a scrub(with repair) would be run manually.
> 
> However, there may some workloads under which such auto-repair is
> undesirable as it may cost performance and safety may be less important
> than that.
> 
> Thus I think, there should be a mount-option that let users control
> whether repair should happen on normal reads or not... and this should
> IMO be independent of whether the fs was mounted ro or rw.

If you allow any write to filesystem before resuming from hibernation
you risk corrupted filesystem. I strongly believe that "ro" must be
really read-only - having separate option to control it will require
update of every tool that generates initramfs and even then you cannot
avoid using older initramfs with newer kernel.

> I'd say the default should go for data safety (i.e. repair as soon as
> possible).
> 

Safety means exactly opposite for me - do not modify data if explicitly
requested not to do it. Having filesystem in half-read-only state will
be too error prone.
