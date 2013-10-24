Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:58922 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3JXV4o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 17:56:44 -0400
Date: Thu, 24 Oct 2013 23:57:15 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Why cannot I move a read-only snapshot around?
Message-ID: <20131024215715.GA14128@kipc2.localdomain>
References: <20131024152955.GA6110@kipc2.localdomain>
 <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

On Thu 131024, Chris Murphy wrote:
> 
> On Oct 24, 2013, at 9:29 AM, Karl Kiniger <karl.kiniger@med.ge.com> wrote:
> 
> > Dear list, (newbie alert)
> > 
> > After sucessfully sending and receiving a dozen of  related snapshots
> > I want to move them all to the readonly folder but I cannot:
> > 
> > ls -l
> > .....
......
> > drwxr-xr-x. 1 root root 734 Oct 24 16:36 @20131023
> > drwxr-xr-x. 1 root root 734 Oct 24 16:41 @20131024
> > drwxr-xr-x. 1 root root 734 Oct 24 16:41 F19
> > drwxr-xr-x. 1 root root   0 Oct 24 17:21 readonly
> > 
> > 
> > mv \@20131024 readonly
> > 
> > mv: cannot move ‘@20131024’ to ‘readonly/@20131024’: Read-only file system
> 
> Are the @ snapshot read only snapshots? And is read only just a regular directory?

Yes they are read only snapshots (just received by btrfs receive) and
"readonly" is a regular directory. I deliberately did not try to move
those snapshots into other snapshots.

I can move r/w snapshots  around without problems
(into some regular directory), just the r/o snapshots refuse moving.

cat /proc/version
Linux version 3.11.6-200.fc19.x86_64

Still curious,

Karl

> 
> I don't know that this is a bug, it seems like it could be intentional because a read only file system wouldn't let you move it out of one tree into another. But there was a bug that prevented moving of subvolumes into subvolumes (untested if moving subvolumes into folders worked) that was fixed in kernel 3.11.6 so that might be worth a shot.
> 
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
