Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39577 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab2HARbq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 13:31:46 -0400
Received: by obbuo13 with SMTP id uo13so12488856obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 10:31:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqC0NgYJNDkMAsfEQAmB8TkJdzQ3M=nHZCdiVHMhQAPRDQ@mail.gmail.com>
References: <CAHf9xvaGUfK0TWTacsT9i=85etzM_-aD1dC-dNVdJYws0K10tQ@mail.gmail.com>
	<CAB9VWqC0NgYJNDkMAsfEQAmB8TkJdzQ3M=nHZCdiVHMhQAPRDQ@mail.gmail.com>
Date: Wed, 1 Aug 2012 20:31:46 +0300
Message-ID: <CAHf9xvYbECS5biGS9p8md9snLc1HxpLkpBqE1dUKxwzRxZOwng@mail.gmail.com>
Subject: Re: Questions and notes about send/receive
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander,
thanks for addressing the issues.

>> __get_cur_name_and_parent()
>> if we decided to call get_first_ref() on the send_root (due to ino <
>> sctx->send_progress), do we really need to call did_overwrite_ref()?
>> Because it will just lookup the send root again. I mean if we know
>> that this inode has been already handled, then it's not an orphan
>> anymore, so no need for this additional check. If my understanding is
>> wrong, pls give some small example?
> get_first_ref does not return the current state. It returns the
> permanent state. The result of did_overwrite_ref however depends on
> the current send progress. There is however some room for optimization
> here. In many cases, I did not think much about double tree lookups
> due to the different calls, as I wanted it to work first and later
> optimize it. One possible optimization for example would be to cache
> the results of lookups. But only for functions which return permanent
> state, e.g. get_inode_info.
So do you think my understanding is correct that if (ino <
sctx->send_progress), then both functions will return the same value?
Or perhaps: if (ino < sctx->send_progress), then no need to check
anymore the did_overwrite_ref(), because we have handled that already?
I think that the call to did_overwrite_ref() is relevant only as long
as we haven't handled this ino. After that, we are good...I think.

I'm not saying the code has be changed/optimized at this point, just
testing my understanding:)


>> struct btrfs_root_item:
>> what is the difference between existing "generation" field that you
>> mimic in generation_v2 and "ctransid"? (I know I need to study the
>> root tree code).
> Did you read the comments for btrfs_root_item and
> btrfs_read_root_item? They should answer your question.
Yes, I read the comments, but they address only "generation" and
"generation_v2", which I understand. Basically, I don't understand how
"generation" differs from ctransid (I need to dig more there).

Thanks!
Alex.



>>
>> Thank you,
>> Alex.
> Big thanks for your reviews :)
> I pushed a new version of the kernel and progs side. The branches are
> now "for-chris"
