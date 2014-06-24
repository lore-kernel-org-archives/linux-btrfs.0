Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54161 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFXFkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 01:40:09 -0400
Received: by mail-qa0-f47.google.com with SMTP id hw13so6471449qab.6
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 22:40:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A8EBEB.1030702@cn.fujitsu.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
 <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <53A8E079.1060803@cn.fujitsu.com>
 <CAB=7dhm4wz7tXm7am0ezNvAiH+YjKBYrL53AQsn9DMQJwaus4Q@mail.gmail.com> <53A8EBEB.1030702@cn.fujitsu.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Tue, 24 Jun 2014 01:39:48 -0400
Message-ID: <CAB=7dh=KejR8HH-uEt0-D8WffEJYOpRop_UVY_CDYQeM9UMZjQ@mail.gmail.com>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> My two cents:-)
>>>
>>> If you really want to use btrfs check  --init-csum-tree
>>> --init-extent-tree,
>>> i'd suggest you use
>>> David Latest btrfs-progs branch which includes some latest bug fixes.
>>
>> I have no particular desire to use it. I just tried everything else
>> first and thought it was worth a shot.
>>
>> If you think that version would help, can you point me to the git
>> repo? The one I grabbed was
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git.
>
> Of course,  You could pull from the following url:
>
> https://github.com/kdave/btrfs-progs.git  integration-20140619

Thanks. I pulled that version and retried everything in my original
transcript, including the "btrfs check --init-csum-tree
--init-extent-tree". Results are identical across the board.
