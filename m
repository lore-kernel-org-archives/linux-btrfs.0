Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64090 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaDRT63 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 15:58:29 -0400
Received: by mail-lb0-f176.google.com with SMTP id 10so1620681lbg.21
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Apr 2014 12:58:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140418171836.GI29256@twin.jikos.cz>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
	<20140415172800.GD7901@wotan.suse.de>
	<CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com>
	<20140415174121.GE7901@wotan.suse.de>
	<CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com>
	<20140415180415.GF7901@wotan.suse.de>
	<3qfwc02110okvx394wlhso7b.1397585421171@email.android.com>
	<CAL3q7H5wUNAkH7HV+TyizTUe3FCHjOycCFQ9Q6hJOSxoZ78maQ@mail.gmail.com>
	<20140415193518.GG7901@wotan.suse.de>
	<CAL3q7H5yYFOiJ=BkEHaRLOh87CoL49xqdm1-aFa2dPASwCFMSg@mail.gmail.com>
	<20140418171836.GI29256@twin.jikos.cz>
Date: Fri, 18 Apr 2014 20:58:27 +0100
Message-ID: <CAL3q7H5hhWVZHtUPZ9o8CZBAd8xfmN_=8fqD1QMtNuSh8D+h+Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 18, 2014 at 6:18 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Apr 15, 2014 at 08:49:52PM +0100, Filipe David Manana wrote:
>> On Tue, Apr 15, 2014 at 8:35 PM, Mark Fasheh <mfasheh@suse.de> wrote:
>> > On Tue, Apr 15, 2014 at 07:30:51PM +0100, Filipe David Manana wrote:
>> >> On Tue, Apr 15, 2014 at 7:10 PM, Josef Bacik <jbacik@fb.com> wrote:
>> >> > Just make a SUPPORTS_V2 flag that userspace can pass in through the existing flags to make the kernel spit out V2 commands.  We don't want to break old user space, I still have to see distro guys in real life ;).  Thanks,
>> >>
>> >> So would this flag named like "supports_v2" imply to send fallocate
>> >> commands and data size computation/command? Right now I made data size
>> >> optional, sent only if a new ioctl send flag is set, because for large
>> >> fs trees it can take some time to compute data size.
>> >
>> > If it's already backwards-compatibilty you could keep the flag for data size computation as-is
>> > and simply add another flag that gets passed in for the fallocate commands
>> > (UNDERSTANDS_FALLOCATE or something lke that).
>>
>> Yep, exactly what I had in mind.
>>
>> > As far as btrfs-progs go you could go with many different approaches. For
>> > the library interface to this we might just let the callers determine the
>> > behavior they want. For the command processing (user runs the btrfs program
>> > directly), you could do a couple things:
>> >
>> > - perhaps try once with the new flags, if you get an error (EINVAL right now
>> >   for bad flags) try with the old ones and only then throw an error out to
>> >   the caller?
>> >
>> > - have user specify whether new flags should be tried or not (this is
>> >   easiest)
>> >
>> > I would generally avoid breaking compatibility inside of btrfs-progs too so
>> > just forcing the new flag seems the most 'breaking' option.
>>
>> Sounds good. Will probably try first to have the user explicitly pass
>> a --stream-version=2 for e.g to btrfs send command, with v1 (current)
>> being the default. I like the idea of clearing the
>> SUPPORT_FALLOCATE/DATA_SIZE bits from the flags and retry if the ioctl
>> returns -EINVAL too.
>
> The fallocate and progress flags are of different nature. While
> fallocate should be used by default with v2 (because it's more efficient
> and the right thing to do), the progress is optional.
>
> So if user selects protocol version=2, he gets the falloc rightaway.
> Ie. no flag like VERSION_V2 or UNDERSTANDS_FALLOCATE, this should be for
> free under "STREAM_VERSION=2".
>
> (I'm not sure if the falloc should be optional at all in v2.)

Fine for me, the only optional one in my opinion is the total data
size calculation (and if requested, sets stream version to 2
automatically).

>
> The progress decreases performance and I think it should be off by
> default.
>
> The remaining v2-draft features are OTIME, file flags and single-file
> clones - all of them are not optional and would be good to add them to
> v2.

I'll add stubs/interfaces for them (kernel and btrfs-progs), and
implement them (kernel side and btrfs-progs) later (or perhaps someone
else might want to get his/her hands dirty too).

Thanks David


-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
