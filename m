Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27139 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756113AbdACKMZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 05:12:25 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH] recursive defrag cleanup
To: "Janos Toth F." <toth.f.janos@gmail.com>
References: <20161206043938.3249-1-anand.jain@oracle.com>
 <20161212171927.GY12522@twin.jikos.cz>
 <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com>
 <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <9fdde3f9-e2ed-b3d3-a8ec-da6ae27dfe95@oracle.com>
Date: Tue, 3 Jan 2017 18:16:15 +0800
MIME-Version: 1.0
In-Reply-To: <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks for the comments.

  We are in the midst of making defrag better. For now, -r option picks
  up files of the dir specified, there is no way to defrag all subvol
  tree with out scripting, something like this.

  If /mnt is mounted with subvolid=5 (default).
  for all s subvol in /mnt
  do
	btrfs fi defrag /mnt/$s
  done
  btrfs fi defrag /mnt
  btrfs fi defrag -vr /mnt (file defrag)

> In my personal experience Btrfs filesystems tend to get slower over
> time, up to the point where it takes several minutes to mount them or
> to delete some big files (observed on HDDs, not on SSDs where the
> sheer speed might masks the problem and filesystem tends to be smaller
> anyway). When it gets really bad, Gentoo's localmount script starts to
> time out on boot and Samba based network file deletions tend to freeze
> the client Windows machine's file explorer.
> It only takes 3-6 months and/or roughly 10-20 times of the total
> disk(s) capacity's worth of write load to get there.

  IMO. The solution has to be reviewed against the use case here,
  and certainly it takes a lot of time.

  In some cases the access pattern for write may be different
  from accessed for read-only. Need to understand the context in
  which the the access leads to the timeout. And then tuning
  might help.


> Defrag doesn't
> seem to help with that but running a balance on each and every
> metadata blocks (data and system blocks can be skipped) seems to
> "renew" it (no more timeouts or noticeable delays on mount, metadata
> operation are as fast as expected, it works like a young
> filesystem...).

  Whats the defrag command you found didn't help but the above
  balance command helped ?

Thanks Anand
