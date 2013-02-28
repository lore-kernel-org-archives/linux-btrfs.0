Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:49561
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3B1U22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 15:28:28 -0500
Message-ID: <512FBDE7.5000906@orcaware.com>
Date: Thu, 28 Feb 2013 12:28:23 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: =?ISO-8859-1?Q?Daniel_Koz=E1k?= <kozzi11@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
References: <op.ws51z2nllpxuyk@kozzifx.lan> <20130227132513.GG19641@localhost.localdomain> <op.ws6fu8smlpxuyk@kozzifx.lan> <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com> <512E8FD7.8020700@orcaware.com> <20130228154721.GJ19641@localhost.localdomain> <op.ws8a2dx4lpxuyk@kozzifx.lan> <20130228183521.GK19641@localhost.localdomain> <512FA4E0.7040701@orcaware.com> <20130228200503.GL19641@localhost.localdomain>
In-Reply-To: <20130228200503.GL19641@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/28/2013 12:05 PM, Josef Bacik wrote:
>
> Ok so now that I have it reproducing, how do I go about getting a custom kernel
> on there?  I'm used to libvirt where all the networking stuff is done for me,
> this doesn't seem to connect to the network at all and it also doesn't seem to
> have mount.nfs so I can't do what I normally do and mount my local drive as nfs
> and install the new kernel.  What is the best way to go about doing this?

I run these images in OpenStack or with kvm.  Its a very bare OS, so 
you'll need to install NFS and anything else you need on it.

Did it not come up with networking?  I was able to do an 'apt-get 
update' on it.  It needs to boot with the seed.iso for it to get proper 
networking, as it uses the cloud-init package to configure itself (it's 
meant to be deployed into EC2 or OpenStack).

Blair

