Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:41469 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2KFNtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 08:49:17 -0500
Date: Tue, 6 Nov 2012 14:49:15 +0100
From: Sander <sander@humilis.net>
To: ching <lsching17@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs defrag problem
Message-ID: <20121106134915.GA24383@panda>
Reply-To: sander@humilis.net
References: <508FBE50.6070300@gmail.com>
 <20121031004027.GE3102@twin.jikos.cz>
 <50919550.3090800@gmail.com>
 <20121105225716.GO3102@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121105225716.GO3102@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote (ao):
> On Thu, Nov 01, 2012 at 05:17:04AM +0800, ching wrote:
> > when a device is mounted under a directory, files in the directory
> > is "hidden", and files in the device is "available", right?  when a
> > directory is polyinstantied, files in the original directory is
> > "hidden", and files in the polyinstantied directory is "available",
> > 
> > How to get past them and pass those "hidden" files to defrag
> > command?
> 
> I hope I get it right, so unless you have a reference to the directory
> with hidden files (using your term), there's no way to access them.
> And this is a more generic question, not related to btrfs itself. The
> hidden files may also belong to a different filesystem.

What Ching means (I think), is that if you have directories in /home,
and you mount a device onto /home, you cannot see the original
directories in /home anymore.

You can still access them though, with a 'mount -o bind':

# mount -o bind / /mnt
# ls /mnt/home

	Sander
