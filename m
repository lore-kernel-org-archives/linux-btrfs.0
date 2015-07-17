Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37959 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbbGQSMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 14:12:34 -0400
Received: by iggf3 with SMTP id f3so42833106igg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 11:12:33 -0700 (PDT)
Message-ID: <1437156751.22061.4.camel@kepstin.ca>
Subject: Re: Concurrent write access
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>, linux-btrfs@vger.kernel.org
Date: Fri, 17 Jul 2015 14:12:31 -0400
In-Reply-To: <1598536.6uUjd689JJ@discus>
References: <2035607.hrq9oNetle@discus>
	 <20150709220609.GI10539@carfax.org.uk> <1598536.6uUjd689JJ@discus>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2015-07-10 at 00:13 +0200, Wolfgang Mader wrote:
> On Thursday 09 July 2015 22:06:09 Hugo Mills wrote:
> > On Thu, Jul 09, 2015 at 11:34:40PM +0200, Wolfgang Mader wrote:
> > > Hi,
> > > 
> > > I have a btrfs raid10 which is connected to a server hosting
> > > multiple virtual machine. Does btrfs support connecting the same
> > > subvolumes of the same raid to multiple virtual machines for
> > > concurrent read and write? The situation would be the same as, 
> > > say,
> > > mounting user homes from the same nfs share on different 
> > > machines.
> > 
> >    It'll depend on the protocol you use to make the subvolumes 
> > visible
> > within the VMs.
> > 
> 
> Thanks for the overview. It it qmeu/kvm in fact, to this is an 
> option. Right 
> now, however, I connect the discs as virtual discs and not the file 
> system, 
> but only to one virtual machine.

btrfs is *not* a cluster filesystem, so one key thing it does not
support is having the same block device being mounted by multiple
computers at the same time (doesn't matter if they're hardware or
virtual machines).

Note that all the subvolumes on a btrfs filesystem share some core data
structures, so mounting different subvolumes is not a way to work
around this limitation.

If you mount the filesystem on the host machine then use a network
protocol (like nfs,samba,9p mentioned earlier), everything will be ok.

If you actually want to mount a filesystem from the same block device
on multiple VMs, you'll have to look into using a specially-designed
cluster filesystem like OCFS or GFS.

-- 
Calvin Walton <calvin.walton@kepstin.ca>
