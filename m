Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33987 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab3BEUp3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 15:45:29 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5F33D7C044A
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Feb 2013 13:45:28 -0700 (MST)
Date: Tue, 5 Feb 2013 15:45:23 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marguerite Su <i@marguerite.su>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: Error removing orphan entry, stopping orphan cleanup.
 could not do orphan cleanup -22
Message-ID: <20130205204523.GD26092@localhost.localdomain>
References: <CAK0PdAkGdGWg8TzrDK0hRgcrqqkTF7XrcOHX2wh_7DLG3G0CLA@mail.gmail.com>
 <20130205193549.GC26092@localhost.localdomain>
 <CAK0PdAmnZgE2+nRzrrK_FLa1xcpZPLHyUN69Kx7W5rRVV2bvTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAK0PdAmnZgE2+nRzrrK_FLa1xcpZPLHyUN69Kx7W5rRVV2bvTA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 01:37:50PM -0700, Marguerite Su wrote:
> On Wed, Feb 6, 2013 at 3:35 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> > Eesh can you fpaste this, it got wrapped by your mailer and I can't read it.
> > Thanks,
> 
> Hi, Josef,
> 
> Of course, http://paste.opensuse.org/80508108
> 
> I at first thought pasting here may help archive. but Gmail sucks...sorry!
> 

Ok so I think we've fixed this already, can you build btrfs-next and try
mounting with that and see if it fixes the problem?  Thanks,

Josef
