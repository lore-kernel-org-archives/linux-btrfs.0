Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:46170 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2FZGlf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 02:41:35 -0400
Date: Tue, 26 Jun 2012 09:41:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch v2] Btrfs: fix error handling in __add_reloc_root()
Message-ID: <20120626064122.GQ5390@mwanda>
References: <4FE473F6.5000109@fusionio.com>
 <20120625111048.GA10393@elgon.mountain>
 <20120625133956.GA2499@localhost.localdomain>
 <20120625135344.GN5390@mwanda>
 <CAOD=uF4h5pqfU3u=fVZu74kEP=HLFQWd2+qPRrT69Jtjn+11bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOD=uF4h5pqfU3u=fVZu74kEP=HLFQWd2+qPRrT69Jtjn+11bw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 06:51:39AM +0530, santosh prasad nayak wrote:
> I am also facing similar issue while applying this patch.
> 
> [santosh@localhost linux-next]$ sudo git am mail_Dan.txt
> Patch format detection failed.
> [santosh@localhost linux-next]$
> 

The problem is not on my end.  It made it to marc.info without
getting corrupted.  Marc.info strips out the From: and Subject:
headers so you'd have to add them in manually.

1) Save this file:
http://marc.info/?l=kernel-janitors&m=134062314509635&q=raw

2) Edit the file and add these two lines add the top:

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] Btrfs: fix error handling in __add_reloc_root()

3) $ git am /home/dcarpenter/tmp/html2/btrfs_raw.txt
Applying: Btrfs: fix error handling in __add_reloc_root()

regards,
dan carpenter


