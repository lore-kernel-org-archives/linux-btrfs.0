Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:55960 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759800Ab3EOSpr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 14:45:47 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: I/O errors block the entire filesystem
References: <orhajmb7kc.fsf@livre.home>
	<20130515024857.GB20202@liubo.jp.oracle.com>
Date: Wed, 15 May 2013 15:45:05 -0300
In-Reply-To: <20130515024857.GB20202@liubo.jp.oracle.com> (Liu Bo's message of
	"Wed, 15 May 2013 10:48:58 +0800")
Message-ID: <ora9nwqdzi.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 14, 2013, Liu Bo <bo.li.liu@oracle.com> wrote:

>> In one of the failures that caused machine load spikes, I tried to
>> collect info on active processes with perf top and SysRq-T, but nothing
>> there seemed to explain the spike.  Thoughts on how to figure out what's
>> causing this?

> Although I've seen your solution patch in this thread, I'm still curious
> about this senario, could you please share the reproducer script or
> something?

I'm afraid I don't have one.  I just use the filesystem on various
disks, with ceph osds and other non-ceph subvolumes and files, and
occasionally I run into one of these bad blocks and the filesystem gets
into these odd states.

> I guess that you're using '-l 64k -n 64k' for mkfs.btrfs

That is correct, but IIUC this should only affect metadata, and metadata
recovery from the DUP block works.  It's data (single copy) that fails
as described.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
