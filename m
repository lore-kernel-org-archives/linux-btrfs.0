Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43096 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3B1WA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 17:00:59 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E069D9A0691
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 15:00:58 -0700 (MST)
Date: Thu, 28 Feb 2013 17:00:55 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: Blair Zajac <blair@orcaware.com>,
        Daniel =?iso-8859-1?Q?Koz=E1k?= <kozzi11@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
Message-ID: <20130228220055.GM19641@localhost.localdomain>
References: <op.ws51z2nllpxuyk@kozzifx.lan>
 <20130227132513.GG19641@localhost.localdomain>
 <op.ws6fu8smlpxuyk@kozzifx.lan>
 <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com>
 <512E8FD7.8020700@orcaware.com>
 <20130228154721.GJ19641@localhost.localdomain>
 <op.ws8a2dx4lpxuyk@kozzifx.lan>
 <20130228183521.GK19641@localhost.localdomain>
 <512FA4E0.7040701@orcaware.com>
 <20130228200503.GL19641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130228200503.GL19641@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 28, 2013 at 03:05:03PM -0500, Josef Bacik wrote:
> GK19641@localhost.localdomain>
>  <512FA4E0.7040701@orcaware.com>
> In-Reply-To: <512FA4E0.7040701@orcaware.com>
> Accept-Language: en-US
> Content-Language: en-US
> X-MS-Exchange-Organization-AuthAs: Internal
> X-MS-Exchange-Organization-AuthMechanism: 06
> X-MS-Exchange-Organization-AuthSource: mail1.int.fusionio.com
> X-MS-Has-Attach:
> X-MS-TNEF-Correlator:
> user-agent: Mutt/1.5.21 (2011-07-01)
> Content-Type: text/plain; charset="iso-8859-1"
> Content-Transfer-Encoding: quoted-printable
> MIME-Version: 1.0
> 
> On Thu, Feb 28, 2013 at 11:41:36AM -0700, Blair Zajac wrote:
> > On 02/28/2013 10:35 AM, Josef Bacik wrote:
> > > On Thu, Feb 28, 2013 at 11:31:15AM -0700, Daniel Koz=E1k wrote:
> > >> Dne Thu, 28 Feb 2013 16:47:21 +0100 Josef Bacik <jbacik@fusionio.com>
> > >> napsal(a):
> > >>
> > >>> On Wed, Feb 27, 2013 at 03:59:35PM -0700, Blair Zajac wrote:
> > >>>> On 02/27/2013 02:08 PM, Josef Bacik wrote:
> > >>>>> On Wed, Feb 27, 2013 at 1:19 PM, Daniel Koz=E1k <kozzi11@gmail.com>
> > >>>> wrote:
> > >>>>>>
> > >>>>>> [kozzi@KozziFX ~]$ mkdir derby
> > >>>>>> [kozzi@KozziFX ~]$ cd derby/
> > >>>>>> [kozzi@KozziFX derby]$ wget -c -q
> > >>>>>>
> > >>>> http://mirror.hosting90.cz/apache//db/derby/db-derby-10.9.1.0/db-der=
> by-10.9.1.0-bin.zip
> > >>>>>> [kozzi@KozziFX derby]$ unzip -qq db-derby-10.9.1.0-bin.zip
> > >>>>>> [kozzi@KozziFX derby]$ cd db-derby-10.9.1.0-bin/
> > >>>>>> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ DERBY_HOME=3D`pwd`
> > >>>>>> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
> > >>>>>> $DERBY_HOME/lib/derbyrun.jar server start &
> > >>>>>> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
> > >>>>>> $DERBY_HOME/lib/derbyrun.jar ij
> > >>>>>> verze ij 10.9
> > >>>>>> ij> CONNECT 'jdbc:derby://localhost:1527/seconddb;create=3Dtrue';
> > >>>>>>
> > >>>>>> BTW. after this I must restart my PC, and after restart, my system
> > >>>> doesn't
> > >>>>>> boot anymore :-) (some more btrfs oops).
> > >>>>>> So I must use btrfs check --repair /dev/sdaX.
> > >>>>>>
> > >>>>>
> > >>>>> Sigh and of course I can't reproduce myself, even with importing a
> > >>>>> huge database into derby.  So you are just mounting with -o
> > >>>>> compress=3Dlzo?  What about the mkfs, are you using raid or anythin=
> g?
> > >>>>> Are you on a ssd?  Also when this happens is there any output above
> > >>>>> the --- [ cut here ] ---?  There should be something about length a=
> nd
> > >>>>> such.  Thanks,
> > >>>>
> > >>>> I was able to reproduce on with 3.8 using Ubuntu 13.04 running in KV=
> M
> > >>>> using the commands exactly as given, but it only after stopping and
> > >>>> starting the server again.
> > >>>>
> > >>>> I use the cloud image from here, boot of an Ubuntu CD-ROM ISO to cha=
> nge
> > >>>> from ext4 to btrfs, then installed openjdk.
> > >>>>
> > >>>> http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg=
> -amd64-disk1.img
> > >>>>
> > >>>> I could make my image available for download later if you need it, i=
> n a
> > >>>> pre-failure state.  Let me know.
> > >>>>
> > >>>
> > >>> Yeah I still can't reproduce, can either of you send me your kernel
> > >>> config so I
> > >>> can see if it's something in my config that's causing problems?  Than=
> ks,
> > >>>
> > >>> Josef
> > >>
> > >> Yes, here is it
> > >>
> > >
> > > Great I'll set this up on both of my boxes and see if I can reproduce. =
>  In the
> > > meantime will you try btrfs-next?  I just pushed a tree-log fix that I =
> don't
> > > think will fix your problem but since I don't know what your problem is=
>  yet it
> > > might, so I'd like to at least eliminate it.  Thanks,
> >=20
> > I put a KVM image up at that you can try:
> >=20
> > http://www-devel.orcaware.com/blair/btrfs/2013-02-28/
> >=20
> > Download all three files, make a copy of=20
> > raring-server-cloudimg-amd64-disk1.img since I can only reproduce from=20
> > the initial state, run launch_image.sh, log in as ubuntu/ubuntu.  I had=20
> > most luck getting the issue by running 'sync' and then BTRFS.sh.=20
> > Without the 'sync' it doesn't fail as often.  If it doesn't fail the=20
> > first time, stop the instance, restore the image from your copy and try=20
> > again.  A 'while 

Ok I was running btrfs.sh on my other box while screwing around with KVM and
didn't notice that I had reproduced it there.  Thanks everyobdy for your help,
I'll tackle this tomorrow morning and hopefully will have a patch.  Thanks,

Josef
