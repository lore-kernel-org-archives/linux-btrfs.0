Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:38768 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750972Ab2KAFGL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 01:06:11 -0400
Message-ID: <50920371.7090601@gmx.net>
Date: Thu, 01 Nov 2012 06:06:57 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Shane Spencer <shane@bogomip.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: find-new possibility of showing modified and deleted files/directories
References: <CANmUDYsPqS9ZUVWhzxQv4G6fkQaRbGa2M3TTECp+tujJtyN4EA@mail.gmail.com> <CAE5mzvi0jLAm_pp0YzD=o2W86jrPSnNw3Z+3UFq9ZY1joynCew@mail.gmail.com> <CANmUDYuTLu5M7PAG1_w2bPORMs73yRmfSc0-2Wx7+UU+FPbs-w@mail.gmail.com>
In-Reply-To: <CANmUDYuTLu5M7PAG1_w2bPORMs73yRmfSc0-2Wx7+UU+FPbs-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2012 02:28 AM, Shane Spencer wrote:
> That's Plan B.  I'll be making a btrfs stream decoder and doing in
> place edits.  I need to move stuff around to other filesystem types
> otherwise I'd just store the stream or apply the stream to a remote
> snapshot.

That's the whole point of the btrfs-send design: It's very easy to
receive on different filesystems. A generic receiver is in preparation.
And to make it even more generic: A sender using the same stream
format is also in preparation for zfs.

> 
> On Wed, Oct 31, 2012 at 4:13 PM, cwillu <cwillu@gmail.com> wrote:
>> Probably easier to decode the btrfs-send stream, or even just use btrfs-send
>> itself instead.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

