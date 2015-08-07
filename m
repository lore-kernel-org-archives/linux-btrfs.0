Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36047 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbbHGORg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 10:17:36 -0400
Received: by lbbpu9 with SMTP id pu9so34298584lbb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 07:17:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150807140043.GA10756@suse.cz>
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20150805164057.GC31669@twin.jikos.cz>
	<CAC8ULPad3LTcegecjV6s-HxK8Yn-k72Eh6=AN5VayeraUO4GzQ@mail.gmail.com>
	<20150807140043.GA10756@suse.cz>
Date: Fri, 7 Aug 2015 17:17:34 +0300
Message-ID: <CAC8ULPbMGFigOhP_NwwD4-qYWEBOwKwgxyzWA5V_su5UtO1-FQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix for infinite loop on non-empty inode but with no
 file extent
From: Robert Munteanu <robert.munteanu@gmail.com>
To: dsterba@suse.cz, Robert Munteanu <robert.munteanu@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 7, 2015 at 5:00 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Aug 07, 2015 at 04:05:44PM +0300, Robert Munteanu wrote:
>> >> Qu Wenruo (3):
>> >>   btrfs-progs: fsck: Print correct file hole
>> >>   btrfs-progs: fsck: Fix a infinite loop on discount file extent repair
>> >>   btrfs-progs: fsck-tests: Add test case for inode lost all its file
>> >>     extent
>> >
>> > Applied, thank you both.
>>
>> I tried to find a git repo with these patches applied but failed.
>> Based on the information at [0] I looked at
>>
>>   http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git
>>   http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git
>>
>> but did not find them.
>>
>> How can I build a version of btrfsprogs with these patches applied?
>
> The patches are collected to the branch named devel. The branch master
> is updated only at release time so the recent patches cannot be found
> there.
>
>> [0]: https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#btrfs-progs_git_repository
>
> Given that you came from the wiki and still was not able to find the
> answer, I'll update it. Thanks.

Thanks for the update. Reading it looks to me like the patches should be at

  http://repo.or.cz/w/btrfs-progs-unstable/devel.git/shortlog/refs/heads/devel

but they don't seem to be . Am I long in the wrong place again :-) ?

Thanks,

Robert



-- 
http://robert.muntea.nu/
