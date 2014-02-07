Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:61691 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBGSD6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 13:03:58 -0500
Received: by mail-vb0-f52.google.com with SMTP id p14so2833718vbm.25
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 10:03:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140207175415.GA16073@twin.jikos.cz>
References: <CALOYprUjGn0rEEJAUw+ggnsazL_F5x4KUMCg2n_+ZeAZT=RJ-w@mail.gmail.com>
	<20140207175415.GA16073@twin.jikos.cz>
Date: Fri, 7 Feb 2014 18:03:55 +0000
Message-ID: <CALOYprW9Oj8jazghJ9x0NWT6KaZiqf4-tYsG4mTpytdjwxUYPA@mail.gmail.com>
Subject: Re: integration-20140206 build failure
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 February 2014 17:54, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Feb 07, 2014 at 12:38:22AM +0000, WorMzy Tykashi wrote:
>> Building the latest integration snapshot, I get the following failure:
>>
>> ----
>> ...
>>     [CC]     cmds-filesystem.o
>> cmds-filesystem.c: In function 'cmd_show':
>> cmds-filesystem.c:740:12: error: invalid storage class for function 'cmd_sync'
>>  static int cmd_sync(int argc, char **argv)
>>             ^
>> cmds-filesystem.c:770:12: error: invalid storage class for function
>
> Thanks. A mismerged patch, fixed in next integration.

Cheers.

I did briefly get the following failure from integration-20140207:

    [CC]     cmds-filesystem.o
cmds-filesystem.c: In function 'handle_print':
cmds-filesystem.c:434:5: error: too few arguments to function 'print_one_fs'
     space_info_arg, label, mnt);
     ^
cmds-filesystem.c:361:12: note: declared here
 static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
            ^
Makefile:113: recipe for target 'cmds-filesystem.o' failed
make: *** [cmds-filesystem.o] Error 1

Though I can't reproduce it now.
