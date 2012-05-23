Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.dcc.ufba.br ([200.128.57.5]:45735 "EHLO jordan.dcc.ufba.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2EWPIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 11:08:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by jordan.dcc.ufba.br (Postfix) with ESMTP id 9E25D4A6D7D
	for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 12:15:03 -0300 (BRT)
Received: from jordan.dcc.ufba.br ([127.0.0.1])
	by localhost (dcc.ufba.br [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W-QD5UY7-3nd for <linux-btrfs@vger.kernel.org>;
	Wed, 23 May 2012 12:15:03 -0300 (BRT)
Received: from hercules.fisnuc.intranet.ufba.br (oceano.fis.ufba.br [200.128.63.19])
	by jordan.dcc.ufba.br (Postfix) with ESMTPSA id 7D1EE4A6D7A
	for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 12:15:03 -0300 (BRT)
Date: Wed, 23 May 2012 12:00:02 -0300
From: Rogerio Bastos <rogeriobastos@dcc.ufba.br>
To: linux-btrfs@vger.kernel.org
Subject: Cant mount multi-subvolume via fstab
Message-ID: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying mount many subvolume during boot via fstab:

UUID=xxx /usr btrfs subvol=usr,ro,nodev 0 0
UUID=xxx /home btrfs subvol=home,nodev,nosuid 0 0
UUID=xxx /var btrfs subvol=var,nodev 0 0
UUID=xxx /var/tmp btrfs subvol=var-tmp,nodev,noexec,nosuid 0 0

But only the first one is mounted. When try to mount the others
subvolumes, I get this error:

mount: /dev/sda3 already mounted or /home busy
mount: according to mtab, /dev/sda3 is mounted on /usr
mount: /dev/sda3 already mounted or /var busy
mount: according to mtab, /dev/sda3 is mounted on /usr
mount: mount point /var/tmp does not exist

I'm using linux kernel 3.3.6 and mount 2.20 in Debian 7.

-- 

Rogerio de Carvalho Bastos

http://wiki.dcc.ufba.br/Main/RogerioBastos
