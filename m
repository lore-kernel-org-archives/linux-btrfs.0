Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:36502 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754214AbbAGVDB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 16:03:01 -0500
Message-ID: <54AD9F85.1010608@inwind.it>
Date: Wed, 07 Jan 2015 22:05:09 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, Lennart Poettering <lennart@poettering.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
References: <20150107174315.GA21865@gardel-login> <54AD929E.608@fb.com>
In-Reply-To: <54AD929E.608@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
>> I am trying to understand the pros and cons of turning this bit
>> on, before I can make this change. So far I see one big pro, but I
>> wonder if there's any major con I should think about?
>> 
> 
> Nope there's no real con other than you don't get csums, but that
> doesn't really matter for you.  Thanks,

In a btrfs-raid setup, in case of a corrupted sector, is BTRFS able to 
rebuild the sector ?
I suppose no; if so this has to be add to the cons I think.

>From my tests [1][2] I was unable to get bigger difference between doing a defrag 
and setting chattr -C the log directory. Did you get other results, if so I am 
interested to know more.

BR
G.Baroncelli



[1] http://kreijack.blogspot.it/2014/06/btrfs-and-systemd-journal.html
[2] http://lists.freedesktop.org/archives/systemd-devel/2014-June/020141.html
