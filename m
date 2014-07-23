Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:36473 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752810AbaGWNV1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 09:21:27 -0400
Date: Wed, 23 Jul 2014 07:20:54 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Message-ID: <20140723132054.GB28679@pyropus.ca>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
 <53C7CD0F.7070603@fb.com>
 <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
 <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53CE7ACF.7070109@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <clm@fb.com> wrote:
> 
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.

Not me, at least - I'm doing the device aggregation down at the LVM level
(sata-dmcrypt-lvm-btrfs stack), so it's presented to btrfs as a single logical
device.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
