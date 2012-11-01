Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40429 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761794Ab2KAPGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 11:06:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TTwM1-00050C-O7
	for linux-btrfs@vger.kernel.org; Thu, 01 Nov 2012 16:06:45 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 16:06:45 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 16:06:45 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: find-new possibility of showing modified and deleted
 files/directories
Date: Thu, 1 Nov 2012 15:06:25 +0000 (UTC)
Message-ID: <k6u35f$o24$1@ger.gmane.org>
References: <CANmUDYsPqS9ZUVWhzxQv4G6fkQaRbGa2M3TTECp+tujJtyN4EA@mail.gmail.com>
	<CAE5mzvi0jLAm_pp0YzD=o2W86jrPSnNw3Z+3UFq9ZY1joynCew@mail.gmail.com>
	<CANmUDYuTLu5M7PAG1_w2bPORMs73yRmfSc0-2Wx7+UU+FPbs-w@mail.gmail.com>
	<50920371.7090601@gmx.net> <k6tkp5$oa5$1@ger.gmane.org>
	<50925D20.7040603@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 01 Nov 2012 12:29:36 +0100, Arne Jansen wrote:
> On 01.11.2012 12:00, Gabriel wrote:
>> On Thu, 01 Nov 2012 06:06:57 +0100, Arne Jansen wrote:
>>> On 11/01/2012 02:28 AM, Shane Spencer wrote:
>>>> That's Plan B.  I'll be making a btrfs stream decoder and doing in
>>>> place edits.  I need to move stuff around to other filesystem types
>>>> otherwise I'd just store the stream or apply the stream to a remote
>>>> snapshot.
>> 
>>> That's the whole point of the btrfs-send design: It's very easy to
>>> receive on different filesystems. A generic receiver is in
>>> preparation.
>>> And to make it even more generic: A sender using the same stream
>>> format is also in preparation for zfs.
>> 
>> Consider the rsync bundle format as well.
>> That should provide interoperability with any filesystem.
> 
> Rsync is an interactive protocol. The idea with send/receive is that the
> stream can be generated without any interactions with receiver. You can
> store the stream somewhere, or replay it to many destinations.

Same with rsync's batch mode. Here is more about it:

http://manpages.ubuntu.com/manpages/precise/man1/rsync.1.html#contenttoc21


