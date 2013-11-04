Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:37841 "EHLO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3KDLho (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 06:37:44 -0500
Date: Mon, 4 Nov 2013 12:38:01 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive do not keep inode ctimes
Message-ID: <20131104113801.GB19724@kipc2.localdomain>
References: <20131025131216.GA14134@kipc2.localdomain>
 <527379A9.3070602@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <527379A9.3070602@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan + list

On Fri 131101, Jan Schmidt wrote:
> Hi Karl,
> 
> On Fri, October 25, 2013 at 15:12 (+0200), Karl Kiniger wrote:
> > is there low level support to change inode ctimes somehow?
> > (on ext[234] it can be done using debugfs)
> 
> No.

Yes :-), offline only of course

> 
> > It would be nice to make received snapshots as similar as
> > possible to their send source. (I am not talking about
> > uuids and such, just ls -lc output)
> 
> This is not planned. Currently, we do not even preserve the inode number. Can
> you give a short explanation of your use case, why do you need to keep the ctime?
> 
> Thanks,
> -Jan

I just wanted to clone a btrfs with many snapshots and at the same time
be able to mount both original and clone on the same computer.
(I did not even try because I dont know what kind of pain the duplicate
 uuids will cause)

Is there a known way to re-UUID such a cloned btrfs?

I don't really "need" the ctime, its just  convenient for looking whats
new in some folder - wget adjusts the mtime and unix/linux lacks the
"file creation time" time stamp.

Greetings,
Karl

