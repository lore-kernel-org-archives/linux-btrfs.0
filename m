Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30798 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752585AbbCWMgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 08:36:55 -0400
Date: Mon, 23 Mar 2015 08:36:47 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: Recursive subvolume snapshots and deletion?
To: Lennart Poettering <mzerqung@0pointer.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1427114207.5707.2@mail.thefacebook.com>
In-Reply-To: <20150323045718.GE19498@gardel-login>
References: <20150323045718.GE19498@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 12:57 AM, Lennart Poettering 
<mzerqung@0pointer.de> wrote:
> Heya!
> 
> So what's the story on recursive btrfs snapshotting and snapshot
> removal? Since a while systemd has now by default creating btrfs
> subvolumes for /var/lib/machines for example. Now, if that code is run
> inside a container, and the container itself already is stored in a
> subvolume we end up with a subvolume inside a subvolume, which
> currently breaks snapshotting and deletion of the outer container
> subvolume.
> 
> What's the plan regarding recursive versions of the operations? Any
> plan to add this? We could work around this in userspace, of course,
> but it would not be atomic, and I'd much prefer if the kernel could do
> this on its own!

Hi Lennart,

I've got a patch to btrfs-progs that can do the recursive snapshotting, 
let me clean it up and submit to Dave.  For recursive deletion I think 
the same method can be used.

-chris



