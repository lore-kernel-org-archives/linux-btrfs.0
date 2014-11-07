Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39704 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaKGJ3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 04:29:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XmfrD-0007wg-7k
	for linux-btrfs@vger.kernel.org; Fri, 07 Nov 2014 10:29:27 +0100
Received: from pd953e464.dip0.t-ipconnect.de ([217.83.228.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 10:29:27 +0100
Received: from holger.hoffstaette by pd953e464.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 10:29:27 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: non-atomic xattr replacement in btrfs => rsync random errors
Date: Fri, 7 Nov 2014 09:29:16 +0000 (UTC)
Message-ID: <pan.2014.11.07.09.29.16@googlemail.com>
References: <oroasjals2.fsf@free.home> <orfvdvaix5.fsf@free.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 06 Nov 2014 23:39:02 -0200, Alexandre Oliva wrote:

> [dropping rsync@lists.samba.org, it rejects posts from non-subscribers;
>  refer to https://bugzilla.samba.org/show_bug.cgi?id=10925 instead]
> 
> On Nov  6, 2014, Alexandre Oliva <oliva@gnu.org> wrote:
> 
>> What makes the problem visible is that btrfs appears to have a race in
>> its handling of xattr replacement, leaving a window between the removal
>> of the old value and the insertion of the new one
> 
> The bugs described above occurred with rsync-3.1.0-5.fc20.x86_64 and
> kernel-libre-3.16.7-200.fc20.gnu.x86_64.  The btrfs code in kernel-libre
> is unchanged from the corresponding Fedora kernel.  The distro is BLAG
> 200k/x86_64, under development.

Just a shot in the dark - could this be related to commit:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b0d5d10f41a0f1cd839408dd94427f2db3553bca

I don't think that made it into 3.16.x.

-h

