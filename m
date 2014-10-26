Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:51100 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbaJZRUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 13:20:46 -0400
Message-ID: <544D2D6D.6050301@nuclearwinter.com>
Date: Sun, 26 Oct 2014 12:20:45 -0500
From: Larkin Lowrey <llowrey@nuclearwinter.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Heavy nocow'd VM image fragmentation
References: <5449898B.4090708@nuclearwinter.com>	<20141024114916.GI12554@merlins.org> <544B0DDC.1020102@pobox.com> <pan$37631$612ebdea$68e82275$b6e96b7b@cox.net>
In-Reply-To: <pan$37631$612ebdea$68e82275$b6e96b7b@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/2014 10:28 PM, Duncan wrote:
> Robert White posted on Fri, 24 Oct 2014 19:41:32 -0700 as excerpted:
>
>> On 10/24/2014 04:49 AM, Marc MERLIN wrote:
>>> On Thu, Oct 23, 2014 at 06:04:43PM -0500, Larkin Lowrey wrote:
>>>> I have a 240GB VirtualBox vdi image that is showing heavy
>>>> fragmentation (filefrag). The file was created in a dir that was
>>>> chattr +C'd, the file was created via fallocate and the contents of
>>>> the orignal image were copied into the file via dd. I verified that
>>>> the image was +C.
>>> To be honest, I have the same problem, and it's vexing:
>> If I understand correctly, when you take a snapshot the file goes into
>> what I call "1COW" mode.
> Yes, but the OP said he hadn't snapshotted since creating the file, and 
> MM's a regular that actually wrote much of the wiki documentation on 
> raid56 modes, so he better know about the snapshotting problem too.
>
> So that can't be it.  There's apparently a bug in some recent code, and 
> it's not honoring the NOCOW even in normal operation, when it should be.
>
> (FWIW I'm not running any VMs or large DBs here, so don't have nocow set 
> on anything and can and do use autodefrag on all my btrfs.  So I can't 
> say one way or the other, personally.)
>

Correct, there were no snapshots during VM usage when the fragmentation
occurred.

One unusual property of my setup is I have my fs on top of bcache. More
specifically, the stack is md raid6  -> bcache -> lvm -> btrfs. When the
fs mounts it has mount option 'ssd' due to the fact that bcache sets
/sys/block/bcache0/queue/rotational to 0.

Is there any reason why either the 'ssd' mount option or being backed by
bcache could be responsible?

--Larkin
