Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:55414 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab2EWRbv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 13:31:51 -0400
Message-ID: <4FBD1F05.4080000@libero.it>
Date: Wed, 23 May 2012 19:31:49 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Rogerio Bastos <rogeriobastos@dcc.ufba.br>
CC: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Cant mount multi-subvolume via fstab
References: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
In-Reply-To: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Rogerio,

On 05/23/2012 05:00 PM, Rogerio Bastos wrote:
> Hi,
> 
> I'm trying mount many subvolume during boot via fstab:
> 
> UUID=xxx /usr btrfs subvol=usr,ro,nodev 0 0
> UUID=xxx /home btrfs subvol=home,nodev,nosuid 0 0
> UUID=xxx /var btrfs subvol=var,nodev 0 0
> UUID=xxx /var/tmp btrfs subvol=var-tmp,nodev,noexec,nosuid 0 0
> 
> But only the first one is mounted. When try to mount the others
> subvolumes, I get this error:

I did some tests. It seems that the problem is that you want to mount
different subvolumes *of the same filesystem* (/dev/sda3) both in RO
(first entry) and RW (the other entries).

Please try to removing the 'RO' for the first entry, and let know us
what happens.

BR
Goffredo

> 
> mount: /dev/sda3 already mounted or /home busy
> mount: according to mtab, /dev/sda3 is mounted on /usr
> mount: /dev/sda3 already mounted or /var busy
> mount: according to mtab, /dev/sda3 is mounted on /usr
> mount: mount point /var/tmp does not exist
> 
> I'm using linux kernel 3.3.6 and mount 2.20 in Debian 7.
> 

