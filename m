Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36945 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757232Ab2KALaC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 07:30:02 -0400
Message-ID: <50925D20.7040603@gmx.net>
Date: Thu, 01 Nov 2012 12:29:36 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Gabriel <g2p.code@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: find-new possibility of showing modified and deleted files/directories
References: <CANmUDYsPqS9ZUVWhzxQv4G6fkQaRbGa2M3TTECp+tujJtyN4EA@mail.gmail.com>	<CAE5mzvi0jLAm_pp0YzD=o2W86jrPSnNw3Z+3UFq9ZY1joynCew@mail.gmail.com>	<CANmUDYuTLu5M7PAG1_w2bPORMs73yRmfSc0-2Wx7+UU+FPbs-w@mail.gmail.com>	<50920371.7090601@gmx.net> <k6tkp5$oa5$1@ger.gmane.org>
In-Reply-To: <k6tkp5$oa5$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01.11.2012 12:00, Gabriel wrote:
> On Thu, 01 Nov 2012 06:06:57 +0100, Arne Jansen wrote:
>> On 11/01/2012 02:28 AM, Shane Spencer wrote:
>>> That's Plan B.  I'll be making a btrfs stream decoder and doing in
>>> place edits.  I need to move stuff around to other filesystem types
>>> otherwise I'd just store the stream or apply the stream to a remote
>>> snapshot.
> 
>> That's the whole point of the btrfs-send design: It's very easy to
>> receive on different filesystems. A generic receiver is in preparation.
>> And to make it even more generic: A sender using the same stream format
>> is also in preparation for zfs.
> 
> Consider the rsync bundle format as well.
> That should provide interoperability with any filesystem.

Rsync is an interactive protocol. The idea with send/receive is that
the stream can be generated without any interactions with receiver.
You can store the stream somewhere, or replay it to many destinations.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

