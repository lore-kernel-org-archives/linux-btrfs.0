From: jim owens <jowens@hp.com>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 11:42:04 -0400
Message-ID: <4899C64C.2040107@hp.com>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218032511.15342.73.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Improved allocator threading

I wanted to work on the allocator with a larger scope
where threading is only a minor part of trying to address
these items from the Project_ideas that I think could change
disk format in some way (to fix it before v1.0):
  - Different sector sizes
  - Multiple chunk trees and extent allocation trees
  - Limiting btree failure domains
and maybe impacting this from Development_timeline
   - Reserved space for online fsck and the ability to add
     storage so that a background extent allocation check can proceed

Maybe this is too ambitious or I am seeing intersections that
are not there, but I am prepared to try doing the allocator.

jim

P.S.  Are there other V1.0 format issues to lock down that
should be worked before the missing features like O_DIRECT?
