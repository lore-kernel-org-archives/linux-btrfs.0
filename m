Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60178 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3B1PrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 10:47:24 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5423A7C0424
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 08:47:24 -0700 (MST)
Date: Thu, 28 Feb 2013 10:47:21 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Blair Zajac <blair@orcaware.com>
CC: Josef Bacik <josef@toxicpanda.com>,
        Daniel =?iso-8859-1?Q?Koz=E1k?= <kozzi11@gmail.com>,
        Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
Message-ID: <20130228154721.GJ19641@localhost.localdomain>
References: <op.ws51z2nllpxuyk@kozzifx.lan>
 <20130227132513.GG19641@localhost.localdomain>
 <op.ws6fu8smlpxuyk@kozzifx.lan>
 <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com>
 <512E8FD7.8020700@orcaware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <512E8FD7.8020700@orcaware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 03:59:35PM -0700, Blair Zajac wrote:
> On 02/27/2013 02:08 PM, Josef Bacik wrote:
> > On Wed, Feb 27, 2013 at 1:19 PM, Daniel Kozák <kozzi11@gmail.com> wrote:
> >>
> >> [kozzi@KozziFX ~]$ mkdir derby
> >> [kozzi@KozziFX ~]$ cd derby/
> >> [kozzi@KozziFX derby]$ wget -c -q
> >> http://mirror.hosting90.cz/apache//db/derby/db-derby-10.9.1.0/db-derby-10.9.1.0-bin.zip
> >> [kozzi@KozziFX derby]$ unzip -qq db-derby-10.9.1.0-bin.zip
> >> [kozzi@KozziFX derby]$ cd db-derby-10.9.1.0-bin/
> >> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ DERBY_HOME=`pwd`
> >> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
> >> $DERBY_HOME/lib/derbyrun.jar server start &
> >> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
> >> $DERBY_HOME/lib/derbyrun.jar ij
> >> verze ij 10.9
> >> ij> CONNECT 'jdbc:derby://localhost:1527/seconddb;create=true';
> >>
> >> BTW. after this I must restart my PC, and after restart, my system doesn't
> >> boot anymore :-) (some more btrfs oops).
> >> So I must use btrfs check --repair /dev/sdaX.
> >>
> >
> > Sigh and of course I can't reproduce myself, even with importing a
> > huge database into derby.  So you are just mounting with -o
> > compress=lzo?  What about the mkfs, are you using raid or anything?
> > Are you on a ssd?  Also when this happens is there any output above
> > the --- [ cut here ] ---?  There should be something about length and
> > such.  Thanks,
> 
> I was able to reproduce on with 3.8 using Ubuntu 13.04 running in KVM 
> using the commands exactly as given, but it only after stopping and 
> starting the server again.
> 
> I use the cloud image from here, boot of an Ubuntu CD-ROM ISO to change 
> from ext4 to btrfs, then installed openjdk.
> 
> http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img
> 
> I could make my image available for download later if you need it, in a 
> pre-failure state.  Let me know.
> 

Yeah I still can't reproduce, can either of you send me your kernel config so I
can see if it's something in my config that's causing problems?  Thanks,

Josef
