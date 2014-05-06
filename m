Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40190 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbaEFGKw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 02:10:52 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id A6F2A21ABB
	for <linux-btrfs@vger.kernel.org>; Tue,  6 May 2014 02:10:51 -0400 (EDT)
Date: Mon, 5 May 2014 23:10:54 -0700
From: David Brown <davidb@davidb.org>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0rc3: did not find backref in send_root
Message-ID: <20140506061053.GA17689@davidb.org>
References: <20140225063652.GD3521@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20140225063652.GD3521@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 10:36:52PM -0800, Marc MERLIN wrote:
>I got this during a btrfs send:
>BTRFS error (device dm-2): did not find backref in send_root. inode=22672, offset=524288, disk_byte=1490517954560 found extent=1490517954560
>
>I'll try a scrub when I've finished my backup, but is there anything I
>can run on the file I've found from the inode?
>
>gargamel:/mnt/dshelf1/Sound# btrfs inspect-internal inode-resolve  -v 22672 file.mp3
>ioctl ret=0, bytes_left=3998, bytes_missing=0, cnt=1, missed=0
>file.mp3

I've just seen this error:

   BTRFS error (device sda4): did not find backref in send_root. inode=411890, offset=307200, disk_byte=48100618240 found extent=48100618240

during a send between two snapshots I have.

after moving to 3.14.2.  I've seen it on two filesystems now since
moving to 3.14.  I have the two readonly snapshots if there is
anything helpful I can figure out from them.

Scrub reports no errors, but I don't seem to be able to back up
anything now.

David
