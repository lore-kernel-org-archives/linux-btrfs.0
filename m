Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:44866 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab2GQUq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 16:46:57 -0400
Message-ID: <5005CF3F.5090204@jan-o-sch.net>
Date: Tue, 17 Jul 2012 22:46:55 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org, sensille@gmx.net
Subject: Re: [PATCH v1 00/15] Btrfs: subvolume quota groups (qgroups)
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net> <CAHf9xvaj8sgku-e9ZSOEiQ2CqZ+xDibs5vuh0cWqv0K418ZTSQ@mail.gmail.com> <5005BC11.2000701@gmx.net>
In-Reply-To: <5005BC11.2000701@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17.07.2012 21:25, Arne Jansen wrote:
> On 07/17/2012 08:33 PM, Alex Lyakas wrote:
>> extent? Also, how do we encounter roots (which is what we need in the
>> output) during this walking? Hope you can shed some light, or you can
> 
> iirc the root backreferences itself, which is the criterion that we
> found a root.

As all the backref walking code, this differs between shared backrefs
and indirect backrefs, too. In general, the criterion is: We've got a
backref with a positive refcount, we've got a root id set for it, and we
determined that this block has no parent block.

See where find_parent_nodes adds to the "roots" ulist.

>> let me continue digging in the code:)

Please do so :-)

-Jan
