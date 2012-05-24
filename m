Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.dcc.ufba.br ([200.128.57.5]:48566 "EHLO jordan.dcc.ufba.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011Ab2EXXdU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 19:33:20 -0400
Date: Thu, 24 May 2012 20:33:16 -0300
From: Rogerio Bastos <rogeriobastos@dcc.ufba.br>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Cant mount multi-subvolume via fstab
Message-ID: <20120524233315.GA2838@matrix>
References: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
 <4FBD1F05.4080000@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBD1F05.4080000@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2012 at 07:31:49PM +0200, Goffredo Baroncelli wrote:
> Hi Rogerio,
> 
> On 05/23/2012 05:00 PM, Rogerio Bastos wrote:
> > Hi,
> > 
> > I'm trying mount many subvolume during boot via fstab:
> > 
> > UUID=xxx /usr btrfs subvol=usr,ro,nodev 0 0
> > UUID=xxx /home btrfs subvol=home,nodev,nosuid 0 0
> > UUID=xxx /var btrfs subvol=var,nodev 0 0
> > UUID=xxx /var/tmp btrfs subvol=var-tmp,nodev,noexec,nosuid 0 0
> > 
> > But only the first one is mounted. When try to mount the others
> > subvolumes, I get this error:
> 
> I did some tests. It seems that the problem is that you want to mount
> different subvolumes *of the same filesystem* (/dev/sda3) both in RO
> (first entry) and RW (the other entries).
> 
> Please try to removing the 'RO' for the first entry, and let know us
> what happens.

You are right, without RO I can mount all subvolume.
Thank you.

> BR
> Goffredo
> 
> > 
> > mount: /dev/sda3 already mounted or /home busy
> > mount: according to mtab, /dev/sda3 is mounted on /usr
> > mount: /dev/sda3 already mounted or /var busy
> > mount: according to mtab, /dev/sda3 is mounted on /usr
> > mount: mount point /var/tmp does not exist
> > 
> > I'm using linux kernel 3.3.6 and mount 2.20 in Debian 7.
> > 
> 

-- 

Rogerio Bastos
