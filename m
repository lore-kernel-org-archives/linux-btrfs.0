Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:32964 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab3AYUxZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 15:53:25 -0500
Date: Fri, 25 Jan 2013 15:53:22 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Andrew McNabb <amcnabb@mcnabbs.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stability
Message-ID: <20130125205322.GB3257@localhost.localdomain>
References: <20130125200514.GD4217@mcnabbs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130125200514.GD4217@mcnabbs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 01:05:14PM -0700, Andrew McNabb wrote:
> I tried creating a multi-device btrfs filesystem for the first time (on
> Fedora 18 with 3.7.2-204.fc18.x86_64), and I ran into some problems.  I
> had heard that btrfs is now reasonably stable, and though I expected to
> possibly see a problem here or there, I was a little surprised at just
> how many problems I encountered in such a short period of time.  I now
> have about a thousand error messages in my kernel logs related to
> several different problems.  Is this roughly the expected level of
> stability for btrfs with multiple devices, or am I just particularly
> lucky? :)
> 
> Am I correct in assuming that I'll need to switch to md for a few months
> and try btrfs again later, or are there known problems in the specific
> kernel I'm running that I could avoid by trying a different version?
> 
> For the sake of being specific, I'll detail a few of the problems I've
> hit:
> 
> These two may have been caused by a possibly faulty disk (I'm still
> trying to determine whether it was faulty or whether the bug was purely
> in btrfs):
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=903794
> https://bugzilla.redhat.com/show_bug.cgi?id=904143
> 
> This one was triggered when I tried to remove a possibly faulty disk:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=904197

Actually for this one, how did you remove the disk?  Did you just yank it out
while the box was running?  Did you mount -o degraded and then delete the device
and then remove it?  How exactly did you get to this situation.  Thanks,

Josef
