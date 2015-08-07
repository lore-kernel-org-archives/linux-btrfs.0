Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36203 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbbHGNFq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 09:05:46 -0400
Received: by lagz9 with SMTP id z9so21664035lag.3
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 06:05:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150805164057.GC31669@twin.jikos.cz>
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20150805164057.GC31669@twin.jikos.cz>
Date: Fri, 7 Aug 2015 16:05:44 +0300
Message-ID: <CAC8ULPad3LTcegecjV6s-HxK8Yn-k72Eh6=AN5VayeraUO4GzQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix for infinite loop on non-empty inode but with no
 file extent
From: Robert Munteanu <robert.munteanu@gmail.com>
To: dsterba@suse.com, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Robert Munteanu <robert.munteanu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Qu Wenruo (3):
>>   btrfs-progs: fsck: Print correct file hole
>>   btrfs-progs: fsck: Fix a infinite loop on discount file extent repair
>>   btrfs-progs: fsck-tests: Add test case for inode lost all its file
>>     extent
>
> Applied, thank you both.

I tried to find a git repo with these patches applied but failed.
Based on the information at [0] I looked at

  http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git
  http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git

but did not find them.

How can I build a version of btrfsprogs with these patches applied?

Thanks,

Robert

[0]: https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#btrfs-progs_git_repository

-- 
http://robert.muntea.nu/
