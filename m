Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaJQPja (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 11:39:30 -0400
Date: Fri, 17 Oct 2014 17:39:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/1] btrfs-progs: introduce a proper structure on which
 cli will call register-device ioctl
Message-ID: <20141017153928.GM22943@suse.cz>
Reply-To: dsterba@suse.cz
References: <1413333974-25579-1-git-send-email-anand.jain@oracle.com>
 <20141016100841.GZ22943@twin.jikos.cz>
 <20141016102035.GA22943@twin.jikos.cz>
 <543FDCA5.9060908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <543FDCA5.9060908@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2014 at 10:56:37PM +0800, Anand Jain wrote:
> Quite strange. I didn't see that problem here.

Thanks for checking.

Yeah, it must be some oddity in my setup. Wiping all the devices makes
no change and I don't see anyting strange when scratch is mounted:

# btrfs fi show -m
Label: 'TestLabel.006'  uuid: 831545ca-35de-4485-94f0-dae2bb9fb6a7
        Total devices 4 FS bytes used 192.00KiB
        devid    1 size 10.00GiB used 20.00MiB path /dev/sda9
        devid    2 size 10.00GiB used 256.00MiB path /dev/sda10
        devid    3 size 10.00GiB used 0.00B path /dev/sda11
        devid    4 size 10.00GiB used 0.00B path /dev/sda12

same without -m.
