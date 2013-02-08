Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946481Ab3BHPF5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 10:05:57 -0500
Date: Fri, 8 Feb 2013 16:05:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Jerry Snitselaar <dev@snitselaar.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: question about error message
Message-ID: <20130208150556.GG12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130206011054.GA1803@cantor.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130206011054.GA1803@cantor.us.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 06:10:54PM -0700, Jerry Snitselaar wrote:
> In some testing that was being done the tester ran into the following:
> 
> --
> 
> /mnt/abo is a filesystem in Raid1-configuration having two disks: /dev/sdg2 
> and /dev/sdg3. When trying to remove one of the devices, you get this error 
> on the console: 
> 
> # btrfs device delete /dev/sdg2 /mnt/abo 
> ERROR: error removing the device '/dev/sdg2' - Invalid argument 
> 
> /var/log/messages shows the real error: 
> Jan 29 13:54:58 ca-ostest202 kernel: btrfs: unable to go below two devices on 
> raid1 
> 
> The error message on the console output is wrong : '/dev/sdg2' is not an 
> invalid argument, there's another reason why the delete-action can't be 
> executed. 
> 
> --
> 
> Looking at it I can see the EINVAL being correct because it is being
> told to remove a member from a raid1 with only 2 members, but I can
> see how that message could be confusing as well. Is there some place
> that tells users to look at /var/log/messages to see the other
> message? Wondering if the error message should point users to
> /var/log/messages to get more details.

The error message means that the action (done via a ioctl() call)
returned EINVAL, and there's no established interface to accompany the
numer with a message. Adding a notice about looking into
/var/log/messages would be better (similar to what a failed mount does).

Also, I think the error code could be changed to EPERM, because this
says that the operation is valid, but not possible to do under current
circumstances.

david
