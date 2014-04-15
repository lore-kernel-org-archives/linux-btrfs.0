Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaDOTfT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 15:35:19 -0400
Date: Tue, 15 Apr 2014 12:35:18 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
Message-ID: <20140415193518.GG7901@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com> <20140415172800.GD7901@wotan.suse.de> <CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com> <20140415174121.GE7901@wotan.suse.de> <CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com> <20140415180415.GF7901@wotan.suse.de> <3qfwc02110okvx394wlhso7b.1397585421171@email.android.com> <CAL3q7H5wUNAkH7HV+TyizTUe3FCHjOycCFQ9Q6hJOSxoZ78maQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5wUNAkH7HV+TyizTUe3FCHjOycCFQ9Q6hJOSxoZ78maQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 07:30:51PM +0100, Filipe David Manana wrote:
> On Tue, Apr 15, 2014 at 7:10 PM, Josef Bacik <jbacik@fb.com> wrote:
> > Just make a SUPPORTS_V2 flag that userspace can pass in through the existing flags to make the kernel spit out V2 commands.  We don't want to break old user space, I still have to see distro guys in real life ;).  Thanks,
> 
> So would this flag named like "supports_v2" imply to send fallocate
> commands and data size computation/command? Right now I made data size
> optional, sent only if a new ioctl send flag is set, because for large
> fs trees it can take some time to compute data size.

If it's already backwards-compatibilty you could keep the flag for data size computation as-is
and simply add another flag that gets passed in for the fallocate commands
(UNDERSTANDS_FALLOCATE or something lke that).



> Also, would new btrfs-progs version send that flag (support_v2)
> always, without any option to use old v1, or not really that useful?


As far as btrfs-progs go you could go with many different approaches. For
the library interface to this we might just let the callers determine the
behavior they want. For the command processing (user runs the btrfs program
directly), you could do a couple things:

- perhaps try once with the new flags, if you get an error (EINVAL right now
  for bad flags) try with the old ones and only then throw an error out to
  the caller?

- have user specify whether new flags should be tried or not (this is
  easiest)

I would generally avoid breaking compatibility inside of btrfs-progs too so
just forcing the new flag seems the most 'breaking' option.

Thanks,
	--Mark

--
Mark Fasheh
