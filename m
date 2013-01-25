Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kaa.mcnabbs.org ([173.255.195.144]:34981 "EHLO mail.mcnabbs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab3AYUMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 15:12:40 -0500
Date: Fri, 25 Jan 2013 14:05:14 -0600
From: Andrew McNabb <amcnabb@mcnabbs.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs stability
Message-ID: <20130125200514.GD4217@mcnabbs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried creating a multi-device btrfs filesystem for the first time (on
Fedora 18 with 3.7.2-204.fc18.x86_64), and I ran into some problems.  I
had heard that btrfs is now reasonably stable, and though I expected to
possibly see a problem here or there, I was a little surprised at just
how many problems I encountered in such a short period of time.  I now
have about a thousand error messages in my kernel logs related to
several different problems.  Is this roughly the expected level of
stability for btrfs with multiple devices, or am I just particularly
lucky? :)

Am I correct in assuming that I'll need to switch to md for a few months
and try btrfs again later, or are there known problems in the specific
kernel I'm running that I could avoid by trying a different version?

For the sake of being specific, I'll detail a few of the problems I've
hit:

These two may have been caused by a possibly faulty disk (I'm still
trying to determine whether it was faulty or whether the bug was purely
in btrfs):

https://bugzilla.redhat.com/show_bug.cgi?id=903794
https://bugzilla.redhat.com/show_bug.cgi?id=904143

This one was triggered when I tried to remove a possibly faulty disk:

https://bugzilla.redhat.com/show_bug.cgi?id=904197

With a freshly created filesystem, I got a kernel bug, associated with a
hang in most filesystem operations.  This occurred in the middle of
ordinary operation and without any sort of hardware-related errors in
the kernel logs.

https://bugzilla.redhat.com/show_bug.cgi?id=904223

I've noticed that a lot of the reports in the Fedora bugzilla and kernel
bugzilla don't seem to include much discussion; is there any specific
type of information that bug submitters should try to include to make
the reports more helpful?  Thanks.

--
Andrew McNabb
http://www.mcnabbs.org/andrew/
PGP Fingerprint: 8A17 B57C 6879 1863 DE55  8012 AB4D 6098 8826 6868
