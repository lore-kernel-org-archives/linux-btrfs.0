Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27709 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3JXRVY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 13:21:24 -0400
Message-ID: <52695702.5000200@oracle.com>
Date: Fri, 25 Oct 2013 01:21:06 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com> <1382421202-18494-2-git-send-email-anand.jain@oracle.com> <20131022143303.GU1032@twin.jikos.cz> <52672F90.8060804@oracle.com> <20131024145100.GC28149@twin.jikos.cz> <20131024145414.GB31029@carfax.org.uk>
In-Reply-To: <20131024145414.GB31029@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for the comments.
I took care of it in the recent patch
  ([PATCH] btrfs-progs: make filesystem show by label work)
with this -d/-m option may accept the argument as well.
except for -m with the argument is of unmounted disk.

Found a new bug.. more than one subvol of a fsid might
have been mounted, then we print as many mount points in
the system - thats not end user desirable. I have drafted
a fix patch, I will be sending it later after a few more tests.

Thanks, Anand

