Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52000 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3C1SFx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 14:05:53 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6787F7C0645
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 12:05:53 -0600 (MDT)
Date: Thu, 28 Mar 2013 14:05:48 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: This time HD LED doesn't come up at all :-(
Message-ID: <20130328180548.GQ28030@localhost.localdomain>
References: <51542EB6.7030403@petaramesh.org>
 <20130328131939.GN28030@localhost.localdomain>
 <515467EE.1090105@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <515467EE.1090105@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 28, 2013 at 09:55:26AM -0600, Swâmi Petaramesh wrote:
> Le 28/03/2013 14:19, Josef Bacik a écrit :
> > Can you capture the output and post it somewhere so I can see it?  Thanks,
> Hi Josef,
> 
> I just uploaded the screenshot here: http://dl.free.fr/pRabNdCsf (You
> will need to type in your email address or the list's one to retrieve it)
> 
> Meanwhile I did some more tests, and I'm puzzled :
> 
> - Booting the latest PartedMagic Live (I believe it's a 3.7.9 kernel), I
> can mount the HD BTRFS filesystem wihtout problem (only tried with
> subvolid=0), I can btrfsck it (unmounted), and it looks allright;
> 
> - Still, trying to boot the system the normal way (3.8.0 kernel) fails,
> and I get these errors...
> 
> At least the FS doesn't look plain dead, but I have no clue...
> 

Actually I see the deadlock now, sorry, I'll fix it up and send a patch.
Thanks,

Josef
