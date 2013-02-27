Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40736 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B0WIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 17:08:51 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so924339wgl.30
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 14:08:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.ws6fu8smlpxuyk@kozzifx.lan>
References: <op.ws51z2nllpxuyk@kozzifx.lan>
	<20130227132513.GG19641@localhost.localdomain>
	<op.ws6fu8smlpxuyk@kozzifx.lan>
Date: Wed, 27 Feb 2013 17:08:49 -0500
Message-ID: <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
From: Josef Bacik <josef@toxicpanda.com>
To: =?ISO-8859-1?Q?Daniel_Koz=E1k?= <kozzi11@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 1:19 PM, Daniel Kozák <kozzi11@gmail.com> wrote:
>
> [kozzi@KozziFX ~]$ mkdir derby
> [kozzi@KozziFX ~]$ cd derby/
> [kozzi@KozziFX derby]$ wget -c -q
> http://mirror.hosting90.cz/apache//db/derby/db-derby-10.9.1.0/db-derby-10.9.1.0-bin.zip
> [kozzi@KozziFX derby]$ unzip -qq db-derby-10.9.1.0-bin.zip
> [kozzi@KozziFX derby]$ cd db-derby-10.9.1.0-bin/
> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ DERBY_HOME=`pwd`
> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
> $DERBY_HOME/lib/derbyrun.jar server start &
> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
> $DERBY_HOME/lib/derbyrun.jar ij
> verze ij 10.9
> ij> CONNECT 'jdbc:derby://localhost:1527/seconddb;create=true';
>
> BTW. after this I must restart my PC, and after restart, my system doesn't
> boot anymore :-) (some more btrfs oops).
> So I must use btrfs check --repair /dev/sdaX.
>

Sigh and of course I can't reproduce myself, even with importing a
huge database into derby.  So you are just mounting with -o
compress=lzo?  What about the mkfs, are you using raid or anything?
Are you on a ssd?  Also when this happens is there any output above
the --- [ cut here ] ---?  There should be something about length and
such.  Thanks,

Josef
