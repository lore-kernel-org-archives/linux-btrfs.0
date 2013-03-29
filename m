Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58372 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3C2Lff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 07:35:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 1EAE17C042F
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 05:35:35 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <orwqsqr0ll.fsf@livre.home>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home>
 <20130322180705.27874.96638@localhost.localdomain>
 <20130322203142.27874.84834@localhost.localdomain>
 <20130326000840.14340.30047@localhost.localdomain>
 <orwqsqr0ll.fsf@livre.home>
Message-ID: <20130329113532.17260.20870@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Fri, 29 Mar 2013 07:35:32 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Alexandre Oliva (2013-03-29 05:56:06)
> On Mar 25, 2013, Chris Mason <chris.mason@fusionio.com> wrote:
> 
> > This patch changes our compression code to call clear_page_dirty_for_io
> > before we compress, and then redirty the pages if the compression fails.
> 
> > Alexandre, many thanks for tracking this down into a well defined use
> > case. 
> 
> Thanks for the patch, it's run flawlessly since I started gradually
> rolling it out onto my ceph OSDs on Monday!  Ship it! :-)

Awesome, it's in my for-linus and will go out to Linus today.

-chris

