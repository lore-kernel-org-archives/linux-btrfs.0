Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:61067 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaDRUCH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 16:02:07 -0400
Received: by mail-la0-f52.google.com with SMTP id ec20so1618665lab.39
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Apr 2014 13:02:06 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140418174142.GJ29256@twin.jikos.cz>
References: <1397580051-26643-3-git-send-email-fdmanana@gmail.com>
	<1397678294-6248-1-git-send-email-fdmanana@gmail.com>
	<20140418174142.GJ29256@twin.jikos.cz>
Date: Fri, 18 Apr 2014 21:02:05 +0100
Message-ID: <CAL3q7H4Q9DY6jZzmFSL3tdwYPskUJJSoppVkGWmF90RZTXbYTw@mail.gmail.com>
Subject: Re: [PATCH 3/4 v3] Btrfs-progs: send, implement fallocate command callback
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 18, 2014 at 6:41 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Apr 16, 2014 at 08:58:14PM +0100, Filipe David Borba Manana wrote:
>> The fallocate send stream command, added in stream version 2, is used to
>> pre-allocate space for files and punch file holes. This change implements
>> the callback for that new command, using the fallocate function from the
>> standard C library to carry out the specified action (allocate file space
>> or punch a file hole).
>
>> +-a::
>> +Use fallocate to pre-allocate file extents and to punch file holes, instead of writing zeroes
>> +to files.
>
> (I wrote that in another mail and repeat it again in the context of the patch)
>
> for v2 the fallocate mode should be default and IMHO not configurable by
> a flag at all - falloc is efficient and the (right) thing that the devs
> choose for the user.
>
> I think that letting the user decide if he should use falloc or not is
> too low-level. From the UI perspective, specifying a protocol number
> should be enough.

Fine for me.

>
> There's currently no way to find the highest protocol version supported,
> but the sysfs flags can be enhanced with that.

You mean, I guess, adding an entry named like
/sys/fs/btrfs/features/send_stream_version

Thanks David



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
