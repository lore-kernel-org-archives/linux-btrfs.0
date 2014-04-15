Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:64073 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaDOSax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 14:30:53 -0400
Received: by mail-la0-f47.google.com with SMTP id pn19so7136497lab.6
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 11:30:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <3qfwc02110okvx394wlhso7b.1397585421171@email.android.com>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
	<20140415172800.GD7901@wotan.suse.de>
	<CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com>
	<20140415174121.GE7901@wotan.suse.de>
	<CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com>
	<20140415180415.GF7901@wotan.suse.de>
	<3qfwc02110okvx394wlhso7b.1397585421171@email.android.com>
Date: Tue, 15 Apr 2014 19:30:51 +0100
Message-ID: <CAL3q7H5wUNAkH7HV+TyizTUe3FCHjOycCFQ9Q6hJOSxoZ78maQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Mark Fasheh <mfasheh@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 7:10 PM, Josef Bacik <jbacik@fb.com> wrote:
> Just make a SUPPORTS_V2 flag that userspace can pass in through the existing flags to make the kernel spit out V2 commands.  We don't want to break old user space, I still have to see distro guys in real life ;).  Thanks,

So would this flag named like "supports_v2" imply to send fallocate
commands and data size computation/command? Right now I made data size
optional, sent only if a new ioctl send flag is set, because for large
fs trees it can take some time to compute data size.

Also, would new btrfs-progs version send that flag (support_v2)
always, without any option to use old v1, or not really that useful?

thanks

>
> Josef
>
> Mark Fasheh <mfasheh@suse.de> wrote:
>
>
> On Tue, Apr 15, 2014 at 06:57:17PM +0100, Filipe David Manana wrote:
>> >> > Are these changes compatible with software using the old stream version? We
>> >> > have snapshotting tools that are using send/recieve and it would be bad to
>> >> > change the ABI in incompatible ways underneath them.
>> >> >         --Mark
>> >>
>> >> New versions of btrfs-progs (send stream v2 support) will still be
>> >> able to read and process v1 streams. Older btrfs-progs (v1 only) won't
>> >> be able to process the new commands.
>> >> Does this answers your question Mark?
>> >
>> > Yes it does thanks. Unfortunately though this is unacceptable behavior -
>> > kernel upgrades are not supposed to break existing userspace interfaces.
>> >
>> > In particular what will happen here is that the user will grab a new kernel
>> > and then find out that their fancy snapshotting software won't work any
>> > more.
>>
>> Good point. I followed this approach based on Josef's comments on a
>> previous rfc at https://urldefense.proofpoint.com/v1/url?u=http://www.spinics.net/lists/linux-btrfs/msg32999.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=wUTU%2FIE4hdC77M9gBWyPgg1QcqkuVHjEMjOGfI79alY%3D%0A&s=4d77650ee86676b158e0f54ff93c700300f098ae6d86f36fcf61feb70fa2ac78
>
> Apparently Josef doesn't get those sorts of bugs in his queue ;)
>
>
>> The only alternative I can think of right now is to use new send ioctl
>> flags instead, so that new clients able to process the new commands
>> will pass these flags explicitly, while old clients would continue to
>> work without changes (and not bumping the stream version, as
>> btrfs-receive refuses versions higher than 1 currently). This seems to
>> be similar to what was done here:
>> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id%3Dcb95e7bf7ba481c3d35b238b1cd671b63f54238a&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=wUTU%2FIE4hdC77M9gBWyPgg1QcqkuVHjEMjOGfI79alY%3D%0A&s=0e82acdd655c133f52a9717216f7038a09afa1bfefaa91c4d332530a5be4c3d6
>
> Yeah that works for me - any client that understand the new features just
> sends some flag that indicates it can process them. Then we know that old
> clients will continue to work unaffected.
>
> Thanks Filipe,
>         --Mark
>
> --
> Mark Fasheh



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
