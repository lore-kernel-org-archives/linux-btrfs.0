Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41952 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDOR5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 13:57:19 -0400
Received: by mail-la0-f46.google.com with SMTP id hr17so7139653lab.19
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 10:57:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140415174121.GE7901@wotan.suse.de>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
	<20140415172800.GD7901@wotan.suse.de>
	<CAL3q7H6gNbDbZudcUveR+W5PznWzz8L4sc1YTWvEhQextfGCtg@mail.gmail.com>
	<20140415174121.GE7901@wotan.suse.de>
Date: Tue, 15 Apr 2014 18:57:17 +0100
Message-ID: <CAL3q7H4dcDeDZ-j6w5eH-AjE8TZSR0KZJbRJPeNQect-KA_OQg@mail.gmail.com>
Subject: Re: [PATCH 1/4] Btrfs: send, bump stream version
From: Filipe David Manana <fdmanana@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 6:41 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> On Tue, Apr 15, 2014 at 06:34:38PM +0100, Filipe David Manana wrote:
>> On Tue, Apr 15, 2014 at 6:28 PM, Mark Fasheh <mfasheh@suse.de> wrote:
>> > On Tue, Apr 15, 2014 at 05:40:18PM +0100, Filipe David Borba Manana wrote:
>> >> This increases the send stream version from version 1 to version 2, adding
>> >> 2 new commands:
>> >>
>> >> 1) total data size - used to tell the receiver how much file data the stream
>> >>    will add or update;
>> >>
>> >> 2) fallocate - used to pre-allocate space for files and to punch holes in files.
>> >>
>> >> This is preparation work for subsequent changes that implement the new features
>> >> (computing total data size and use fallocate for better performance).
>> >
>> > Are these changes compatible with software using the old stream version? We
>> > have snapshotting tools that are using send/recieve and it would be bad to
>> > change the ABI in incompatible ways underneath them.
>> >         --Mark
>>
>> New versions of btrfs-progs (send stream v2 support) will still be
>> able to read and process v1 streams. Older btrfs-progs (v1 only) won't
>> be able to process the new commands.
>> Does this answers your question Mark?
>
> Yes it does thanks. Unfortunately though this is unacceptable behavior -
> kernel upgrades are not supposed to break existing userspace interfaces.
>
> In particular what will happen here is that the user will grab a new kernel
> and then find out that their fancy snapshotting software won't work any
> more.

Good point. I followed this approach based on Josef's comments on a
previous rfc at http://www.spinics.net/lists/linux-btrfs/msg32999.html

The only alternative I can think of right now is to use new send ioctl
flags instead, so that new clients able to process the new commands
will pass these flags explicitly, while old clients would continue to
work without changes (and not bumping the stream version, as
btrfs-receive refuses versions higher than 1 currently). This seems to
be similar to what was done here:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=cb95e7bf7ba481c3d35b238b1cd671b63f54238a

thanks

>         --Mark
>
> --
> Mark Fasheh



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
