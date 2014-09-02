Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaIBLci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 07:32:38 -0400
Date: Tue, 2 Sep 2014 13:32:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: canonicalize dm device name before
 update kernel
Message-ID: <20140902113234.GE5888@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1408016420-29221-1-git-send-email-guaneryu@gmail.com>
 <1408016420-29221-2-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408016420-29221-2-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 07:40:20PM +0800, Eryu Guan wrote:
> [root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
> Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
>         Total devices 1 FS bytes used 384.00KiB
>         devid    1 size 15.00GiB used 2.04GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv1
> 
> Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
>         Total devices 2 FS bytes used 112.00KiB
>         devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
>         devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3
> 
> Btrfs v3.14.2

The commit b276e4bc50b6ca99056a45315ea859c68d58fc1b
"canonicalize pathnames for device commands" supposedly fixes the same
problem, added in 3.16. Can you please test that it works in your case
as well? Thanks.
