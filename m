Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:49319 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GHQQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 12:16:43 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so1963781bkc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jul 2013 09:16:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130708161400.GB18204@twin.jikos.cz>
References: <20130705202718.GE2260@localhost.localdomain>
	<1373057014-1424-1-git-send-email-fdmanana@gmail.com>
	<20130708161400.GB18204@twin.jikos.cz>
Date: Mon, 8 Jul 2013 17:16:41 +0100
Message-ID: <CAL3q7H7f9j2JUEspW_K=A3LQ+UqLOvXGk6HLPEfEXRL7A5q3Yw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs-progs: remove incorrect slot decrement
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, sorry.
I'm not used to git send-email and related best practices.

Thanks for letting me know.

On Mon, Jul 8, 2013 at 5:14 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Jul 05, 2013 at 09:43:34PM +0100, Filipe David Borba Manana wrote:
>> In btrfs_set_block_flags() we want to check if the slot
>> in the leaf points to the first item in the leaf - if it
>> doesn't check if the previous item in the leaf is an extent
>> item. By removing this extra slot decrement we are indeed
>> checking the item right before the slot, and not the second
>> item before.
>>
>> V2: Added Josef Bacik's review mention.
>
> Please don't do that. It's ok to increase version if you update code or
> changelog/subject, but not just the tags.
>
> thanks,
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
