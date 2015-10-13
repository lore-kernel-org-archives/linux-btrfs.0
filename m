Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34704 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbJMTHA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 15:07:00 -0400
Received: by igbni9 with SMTP id ni9so64252545igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 12:07:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <466cad37-fdc5-42d7-ad6c-69f93d55208a@aei.ca>
References: <1443641013-26765-1-git-send-email-rruede+git@gmail.com>
	<CAL3q7H7AYV_BEkT+_gg5qYK1Yvk=dMo9Xoi5cnZx97g=w7qKpQ@mail.gmail.com>
	<466cad37-fdc5-42d7-ad6c-69f93d55208a@aei.ca>
Date: Tue, 13 Oct 2015 20:07:00 +0100
Message-ID: <CAL3q7H5J-hpr=4gqmHSh0WwTHnkOcX1807wY4TW8b5FRxx5GCA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix resending received snapshot with parent
From: Filipe Manana <fdmanana@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Robin Ruede <r.ruede@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Robin Ruede <rruede+git@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 1:31 AM, Ed Tomlinson <edt@aei.ca> wrote:
> On Friday, October 9, 2015 4:24:10 PM EDT, Filipe Manana wrote:
>>
>> On Wed, Sep 30, 2015 at 8:23 PM, Robin Ruede <r.ruede@gmail.com> wrote:
>>>
>>> This fixes a regression introduced by 37b8d27d between v4.1 and v4.2.
>>>
>>> When a snapshot is received, its received_uuid is set to the original
>>> uuid of the subvolume. When that snapshot is then resent to a third
>>> filesystem, it's received_uuid is set to the second uuid
>>> instead of the original one. The same was true for the parent_uuid. ...
>>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>>
>> Thanks for fixing this.
>> I've added this to my integration branch [1] and will send soon a pull
>> request to Chris for 4.4, including this fix plus a few others for
>> send/receive, after some more testing.
>>
>> I've also made an xfstest for it [1, 2]
>
>
> Another thanks for this fix.  It fixes things here.  I am runing 4.2.3 with
> the 4.3 btrfs tree pulled on top of it along with this fix.  Incremental
> sends
> are now working again.
> Tested-by: Ed Tomlinson <edt@aei.ca>
>
> This fixes a regression, can we please get into 4.3?

I've tagged it for stable backports in my 4.4 integration branch [1].
Thanks.

[1] http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=integration-4.4

thanks
>
> Thanks
> Ed Tomlinson
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
