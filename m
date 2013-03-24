Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox1.develooper.com ([207.171.7.178]:40903 "EHLO
	mbox1.develooper.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3CXIJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Mar 2013 04:09:44 -0400
Received: from mbox1.develooper.com (mbox1.develooper.com [127.0.0.1])
	by mbox1.develooper.com (Postfix) with ESMTP id 9243D175B39
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2013 01:09:44 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: btrfs "stuck" on
From: =?iso-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
In-Reply-To: <CAKcLGm_mrpm-vZnv9ExsZByTh8BMN+nZCLN6s--=nuJxwwY=Sw@mail.gmail.com>
Date: Sun, 24 Mar 2013 01:09:38 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <41BE4762-F5EE-4072-8103-094762541091@develooper.com>
References: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com> <CAKcLGm_mrpm-vZnv9ExsZByTh8BMN+nZCLN6s--=nuJxwwY=Sw@mail.gmail.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 22, 2013, at 10:37, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:

> If you can, it would be interesting to know how well the cleaner runs
> across iSCSI if nothing else is running.  If you could delete a single
> snapshot, and make note of the space used before and after the cleaner
> finishes and the time required, this might help isolate the issue.

It seems to me like the file system has gotten corrupted in some way.

I think I left out one bit of information that's important:

It's been doing this for ~3 weeks and never finished even with the file system otherwise idle. I left it completely alone for about a week at some point thinking it'd recover but it didn't.  After a week I tried rebooting it and that didn't make a difference, either. :-)

I tried to delete a few more snapshots and the space used didn't change.

I'm checking by running 'btrfs file show'

# btrfs file show tank
failed to read /dev/sr0
Label: 'tank'  uuid: 6df950f2-e3e7-4f07-913b-ee34157e28b3
	Total devices 1 FS bytes used 477.67GB
	devid    1 size 1.17TB used 499.04GB path /dev/sdc

I am using 3.8.2 from fedora 18 (3.8.3 on next reboot), but I'm happy to recompile and try any patches that might reveal what's going on.


Ask