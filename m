Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:21829 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754747Ab3JXRK0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 13:10:26 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:56728 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VZOQP-002iyE-Jc
	for linux-btrfs@vger.kernel.org; Thu, 24 Oct 2013 11:10:22 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Why cannot I move a read-only snapshot around?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131024152955.GA6110@kipc2.localdomain>
Date: Thu, 24 Oct 2013 11:10:20 -0600
Message-Id: <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com>
References: <20131024152955.GA6110@kipc2.localdomain>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2013, at 9:29 AM, Karl Kiniger <karl.kiniger@med.ge.com> wrote:

> Dear list, (newbie alert)
> 
> After sucessfully sending and receiving a dozen of  related snapshots
> I want to move them all to the readonly folder but I cannot:
> 
> ls -l
> .....
> drwxr-xr-x. 1 root root 682 Oct 24 16:01 @20131001
> drwxr-xr-x. 1 root root 682 Oct 24 16:07 @20131004
> drwxr-xr-x. 1 root root 682 Oct 24 16:10 @20131008
> drwxr-xr-x. 1 root root 682 Oct 24 16:16 @20131010
> drwxr-xr-x. 1 root root 682 Oct 24 16:23 @20131014
> drwxr-xr-x. 1 root root 706 Oct 24 16:24 @20131018
> drwxr-xr-x. 1 root root 706 Oct 24 16:31 @20131021
> drwxr-xr-x. 1 root root 734 Oct 24 16:36 @20131023
> drwxr-xr-x. 1 root root 734 Oct 24 16:41 @20131024
> drwxr-xr-x. 1 root root 734 Oct 24 16:41 F19
> drwxr-xr-x. 1 root root   0 Oct 24 17:21 readonly
> 
> 
> mv \@20131024 readonly
> 
> mv: cannot move ‘@20131024’ to ‘readonly/@20131024’: Read-only file system

Are the @ snapshot read only snapshots? And is read only just a regular directory?

I don't know that this is a bug, it seems like it could be intentional because a read only file system wouldn't let you move it out of one tree into another. But there was a bug that prevented moving of subvolumes into subvolumes (untested if moving subvolumes into folders worked) that was fixed in kernel 3.11.6 so that might be worth a shot.


Chris Murphy