Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:36052 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbbJMAbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 20:31:36 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Robin Ruede <r.ruede@gmail.com>, <linux-btrfs@vger.kernel.org>,
        Robin Ruede <rruede+git@gmail.com>
Subject: Re: [PATCH] btrfs: fix resending received snapshot with parent
Date: Mon, 12 Oct 2015 20:31:33 -0400
MIME-Version: 1.0
Message-ID: <466cad37-fdc5-42d7-ad6c-69f93d55208a@aei.ca>
In-Reply-To: <CAL3q7H7AYV_BEkT+_gg5qYK1Yvk=dMo9Xoi5cnZx97g=w7qKpQ@mail.gmail.com>
References: <1443641013-26765-1-git-send-email-rruede+git@gmail.com>
 <CAL3q7H7AYV_BEkT+_gg5qYK1Yvk=dMo9Xoi5cnZx97g=w7qKpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, October 9, 2015 4:24:10 PM EDT, Filipe Manana wrote:
> On Wed, Sep 30, 2015 at 8:23 PM, Robin Ruede <r.ruede@gmail.com> wrote:
>> This fixes a regression introduced by 37b8d27d between v4.1 and v4.2.
>> 
>> When a snapshot is received, its received_uuid is set to the original
>> uuid of the subvolume. When that snapshot is then resent to a third
>> filesystem, it's received_uuid is set to the second uuid
>> instead of the original one. The same was true for the parent_uuid. ...
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>
> Thanks for fixing this.
> I've added this to my integration branch [1] and will send soon a pull
> request to Chris for 4.4, including this fix plus a few others for
> send/receive, after some more testing.
>
> I've also made an xfstest for it [1, 2]

Another thanks for this fix.  It fixes things here.  I am runing 4.2.3 with 
the 4.3 btrfs tree pulled on top of it along with this fix.  Incremental 
sends
are now working again.  

Tested-by: Ed Tomlinson <edt@aei.ca>

This fixes a regression, can we please get into 4.3?

Thanks
Ed Tomlinson

