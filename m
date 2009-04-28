From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 07:22:15 +0200
Message-ID: <20090428052215.GA22921@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240839448.26451.13.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

> There is a btrfs ioctl to clone individual files, and this could be used
> to implement an online dedup.  But, since it is happening from userland,
> you can't lock out all of the other users of a given file.

> So, the dedup application would be responsible for making sure a given
> file was not being changed while the dedup scan was running.

I see, does that mean that I can not do ,,dedup'' for files that are
currently opened by a userland program?

        Thomas
