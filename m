Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:36763 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbaJQUIV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 16:08:21 -0400
Message-ID: <1413576485.22256.5.camel@linux-t7sj.site>
Subject: Re: btrfs soft lockups: locks gone crazy
From: Davidlohr Bueso <dave@stgolabs.net>
To: Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Date: Fri, 17 Oct 2014 13:08:05 -0700
In-Reply-To: <54416EF6.1050403@fb.com>
References: <1413271664.27233.13.camel@linux-t7sj.site>
	 <54416EF6.1050403@fb.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-10-17 at 15:33 -0400, Josef Bacik wrote:
> On 10/14/2014 03:27 AM, Davidlohr Bueso wrote:
> > Hello,
> >
> > I'm getting massive amounts of cpu soft lockups in Linus's tree for
> > today. This occurs almost immediately and is very reproducible in aim7
> > disk workloads using btrfs:
> >
> 
> I'm trying to reproduce but it's not popping for me.  What is the setup 
> of your fs?  mkfs options, mount options etc.  And how are you running 
> aim7?  I'm using reaim with the default reaim.config and workfile,disk, 
> is this what you are using?  If not please attach your config and 
> workfile so I can be sure to be doing the same thing as you.  Thanks,

The steps I used are:

Download mmtests: https://github.com/gormanm/mmtests.git

cp configs/config-global-dhp__reaim-io config

edit the new config and just leave 'workfile.shared workfile.disk'
workloads as the REAIM_WORKFILES parameter.

./run-mmtests --no-monitor testname

Just a few mins into the test you should start getting the lockups. fwiw
I have not had the time to try other setups of reaim that are not
bundled with mmtests.

Thanks,
Davidlohr

