Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaIPVfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:35:07 -0400
Message-ID: <5418AD03.4090301@redhat.com>
Date: Tue, 16 Sep 2014 16:34:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
CC: "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: [bug] btrfs check --subvol-extents segfault
References: <BB091951-5382-4788-901D-20E96546548A@colorremedies.com>
In-Reply-To: <BB091951-5382-4788-901D-20E96546548A@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/16/14 4:33 PM, Chris Murphy wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=1142421
> 
> kernel-3.17.0-0.rc5.git0.1.fc22.x86_64
> btrfs-progs-3.16-1.fc21.x86_64
> 
> Steps to Reproduce:
> 1. mkfs.btrfs /dev/sdc
> 2. btrfs check --subvol-extents /dev/sdc
> 
> Results:
> Segmentation fault (core dumped)
> 
> [  632.749774] btrfs[692]: segfault at 0 ip 00007fc9963fdd77 sp 00007fff93450880 error 4 in libc-2.19.90.so[7fc9963c2000+1bd000]
> 
> Eric Sandeed writes in the bugzilla that this was broken by commit
> d34cbe76c723a05a14bbcfdc46e8ede789c3f1f9 which drops the requirement
> to specify a subvolid, but still does arg_strtou64(optarg) ->
> arg_strtou64(NULL) so it crashes.

Yeah, AFAICT (although it's not documented anywhere) the functionality is
*supposed* to take a subvolid as an argument.

The commit lets it pass w/ no args, but still does arg_strtou64(optarg) to get
the subvolid, and boom.

I think the commit just needs to be reverted, and then manpages updated &
testcases written...

-Eric
