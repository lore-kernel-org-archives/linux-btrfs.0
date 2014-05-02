Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48032 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaEBQKT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 May 2014 12:10:19 -0400
Received: by mail-lb0-f176.google.com with SMTP id w7so3265653lbi.35
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 09:10:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140502154617.GP5988@twin.jikos.cz>
References: <1398002847-11144-1-git-send-email-fdmanana@gmail.com>
	<1398030003-12697-1-git-send-email-fdmanana@gmail.com>
	<20140502154617.GP5988@twin.jikos.cz>
Date: Fri, 2 May 2014 17:10:18 +0100
Message-ID: <CAL3q7H4Lem7O4ojY0DPnJyVLyjQ=jKy2vEqpuUMN_cAd=i=R7g@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] Btrfs: add send_stream_version attribute to sysfs
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 2, 2014 at 4:46 PM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Apr 20, 2014 at 10:40:03PM +0100, Filipe David Borba Manana wrote:
>> So that applications can find out what's the highest send stream
>> version supported/implemented by the running kernel:
>>
>>     $ cat /sys/fs/btrfs/send/stream_version
>>     2
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>
>> V2: Renamed /sys/fs/btrfs/send_stream_version to /sys/fs/btrfs/send/stream_version,
>>     as in the future it might be useful to add other sysfs attrbutes related to
>>     send (other ro information or tunables like internal buffer sizes, etc).
>
> Sounds good, I don't see any issue with the separate directory. Mixing
> it with /sys/fs/btrfs/features does not seem suitable for that if you
> intend adding more entries.

Yeah, I only didn't mix it with the features subdir because that
relates to features that are settable, plus there's 2 versions of it,
one global and one per fs (uuid) subdirectory (and it felt odd to me
to add it to one of those subdirs and not the other).

Thanks David

>
> Reviewed-by: David Sterba <dsterba@suse.cz>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
