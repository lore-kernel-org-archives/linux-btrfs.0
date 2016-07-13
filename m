Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbcGMPqz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 11:46:55 -0400
Date: Wed, 13 Jul 2016 17:46:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Benedikt Morbach <benedikt.morbach@googlemail.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] receive: strip root subvol path during process_clone
Message-ID: <20160713154642.GN10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160614225541.18140-1-benedikt.morbach@googlemail.com>
 <1465945606.18810.1.camel@googlemail.com>
 <20160617171807.GI4915@twin.jikos.cz>
 <CAC-H7H=_SaLg_w0uuXpG+yfxjo2zkumzhh+DQ34AqGfQj4rOXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC-H7H=_SaLg_w0uuXpG+yfxjo2zkumzhh+DQ34AqGfQj4rOXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 04:07:25PM +0200, Benedikt Morbach wrote:
> Hi David,
> 
> On Fri, Jun 17, 2016 at 7:18 PM, David Sterba <dsterba@suse.cz> wrote:
> > thanks for the fix. The mail thread holds enough information to
> > reproduce the issue, I'll get to that on Monday. I'm not sure about the
> > use of strstr to match the subvolume name so I want to write the tests
> > first and craft some paths to see how it works.
> 
> any update on this? I've been running this patch for a few weeks now
> with my hourly backups.
> I could also take a stab at writing a test case but I think I'd need
> some pointers for that. ;-)

Sorry, I got distracted. The things with paths are a bit complicated,
there's chroot support, explicit mountpoint (-m), so stripping the
root_path would not work in all cases.

Apparently the full_clone_path is wrong there as it's not relative to
root_path and thus openat(mnt_fd, ...) will fail, so instead of
stripping the path, we would need to provide the clone path relative to
root_path directly.

> I took a look at the send/receive patches that Filipe sent earlier and
> afaict this isn't fixed in those.

No, this is not related to kernel.
