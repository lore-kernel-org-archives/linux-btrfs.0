Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45129 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaDOTty (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 15:49:54 -0400
Received: by mail-lb0-f178.google.com with SMTP id s7so7507079lbd.9
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 12:49:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140415193518.GG7901@wotan.suse.de>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
	<20140415172800.GD7901@wotan.suse.de>
	<CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com>
	<20140415174121.GE7901@wotan.suse.de>
	<CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com>
	<20140415180415.GF7901@wotan.suse.de>
	<3qfwc02110okvx394wlhso7b.1397585421171@email.android.com>
	<CAL3q7H5wUNAkH7HV+TyizTUe3FCHjOycCFQ9Q6hJOSxoZ78maQ@mail.gmail.com>
	<20140415193518.GG7901@wotan.suse.de>
Date: Tue, 15 Apr 2014 20:49:52 +0100
Message-ID: <CAL3q7H5yYFOiJ=BkEHaRLOh87CoL49xqdm1-aFa2dPASwCFMSg@mail.gmail.com>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
From: Filipe David Manana <fdmanana@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 8:35 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> On Tue, Apr 15, 2014 at 07:30:51PM +0100, Filipe David Manana wrote:
>> On Tue, Apr 15, 2014 at 7:10 PM, Josef Bacik <jbacik@fb.com> wrote:
>> > Just make a SUPPORTS_V2 flag that userspace can pass in through the existing flags to make the kernel spit out V2 commands.  We don't want to break old user space, I still have to see distro guys in real life ;).  Thanks,
>>
>> So would this flag named like "supports_v2" imply to send fallocate
>> commands and data size computation/command? Right now I made data size
>> optional, sent only if a new ioctl send flag is set, because for large
>> fs trees it can take some time to compute data size.
>
> If it's already backwards-compatibilty you could keep the flag for data size computation as-is
> and simply add another flag that gets passed in for the fallocate commands
> (UNDERSTANDS_FALLOCATE or something lke that).

Yep, exactly what I had in mind.

>
>
>
>> Also, would new btrfs-progs version send that flag (support_v2)
>> always, without any option to use old v1, or not really that useful?
>
>
> As far as btrfs-progs go you could go with many different approaches. For
> the library interface to this we might just let the callers determine the
> behavior they want. For the command processing (user runs the btrfs program
> directly), you could do a couple things:
>
> - perhaps try once with the new flags, if you get an error (EINVAL right now
>   for bad flags) try with the old ones and only then throw an error out to
>   the caller?
>
> - have user specify whether new flags should be tried or not (this is
>   easiest)
>
> I would generally avoid breaking compatibility inside of btrfs-progs too so
> just forcing the new flag seems the most 'breaking' option.

Sounds good. Will probably try first to have the user explicitly pass
a --stream-version=2 for e.g to btrfs send command, with v1 (current)
being the default. I like the idea of clearing the
SUPPORT_FALLOCATE/DATA_SIZE bits from the flags and retry if the ioctl
returns -EINVAL too.

Thanks Mark

>
> Thanks,
>         --Mark
>
> --
> Mark Fasheh



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
