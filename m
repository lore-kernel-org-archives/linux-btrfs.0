Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:34393 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaBTTUT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 14:20:19 -0500
Message-ID: <53065583.4020607@inwind.it>
Date: Thu, 20 Feb 2014 20:20:35 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>,
        Kostia Khlebopros <kkhlebopros@netgear.com>
Subject: Re: [PATCH][BTRFS-PROGS][v4] Enhance btrfs fi df
References: <52FD1A72.5060307@libero.it> <20140220180857.GW16073@twin.jikos.cz> <53064A42.7000703@fb.com>
In-Reply-To: <53064A42.7000703@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On 02/20/2014 07:32 PM, Josef Bacik wrote:
>> > Yes for 3), we may also export the information through the
>> > existing ioctls if possible (eg. IOC_FS_INFO).
>> > 
> For _right now_ I'd say just not do the raid56 stuff if we don't
> notice any raid56 chunks from the normal load_space_info, and then if
> there are raid56 we try and run the tree search ioctl and notice if we
> get back EPERM or whatever you get when you don't have permissions.
> Then just spit out as much information that you can about the fs with
> a little note at the bottom that available calculation isn't 100% and
> you need to run as root if you want that info.
> 
> Then what we could do is add another flag type for the existing
> SPACE_INFO ioctl to spit out the information you need about the
> raid5/6 chunks and then just test for those flags and make the
> adjustment necessary.  This way we avoid adding yet another ioctl and
> stuff will still work nicely for old kernels that don't have the
> updated ioctl.  Thanks,
> 
> Josef

Good suggestion ! I will take it

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
