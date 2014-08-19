Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44347 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaHSP43 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:56:29 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so6447192wgh.13
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 08:56:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819140309.GT1553@twin.jikos.cz>
References: <53E80B87.30504@gmail.com> <20140819140309.GT1553@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 19 Aug 2014 18:55:47 +0300
Message-ID: <CAGqmi77OtVSiv0HO=xBo9Yueq9wA0AORF6uwrCmKaUYDsXArcA@mail.gmail.com>
Subject: Re: [RFC PATCH] btrfs-progs: Move btrfstune to btrfs device tune
To: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No problem =).
Then, just ignore patch.

2014-08-19 17:03 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Mon, Aug 11, 2014 at 03:17:11AM +0300, Timofey Titovets wrote:
>> According to https://btrfs.wiki.kernel.org/index.php/Project_ideas#btrfs
>> Quote:
>> merge functionality of btrfstune, eg. under btrfs dev set-seed /dev/
>> (discuss the command name though)
>
> I've added this project idea long time ago and I'm afraid it's not valid
> anymore, at least not in the proposed way.
>
>> This patch is just code move
>> After, user can tune btrfs parameters through:
>> btrfs dev tune -xr /dev/sda2
>
> The btrfstune utility works on an unmounted filesystem and affects the
> whole filesystem, so the 'device' subgroup is not right here.
>
> Most of the commands from the base utility on a mounted filesystem, so a
> separate btrfstune makes some distinction. The reason for merging the
> two was to avoid a 1MB binary for very simple thing, the generic
> filesystem code can be shared with 'btrfs'.
>
> The question is what's the right UI, a new subcommand, or via the
> generic properties command? The property interface is not yet populated,
> so it might be hard to imagine where the tuning settings would go.
> Something like this:
>
> $ btrfs prop set feature.skinny-metadata 1 /dev/sdx
>
> The extended refs can be turned on even on a mounted filesystem, so this
> would avoid doing 'echo 1 > /sys/fs/btrfs/UUID/features/extended_iref'.
>
> At this moment I'm inclined to use the properties interface, which means
> that the btrfstune utility will stay a bit longer. I'll update the
> project idea to reflect this so it's not confusing anymore (sorry).



-- 
Have a nice day,
Timofey.
