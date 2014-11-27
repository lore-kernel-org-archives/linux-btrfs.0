Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:49008 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbaK0AUw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:20:52 -0500
Message-ID: <54766E5C.8010909@pobox.com>
Date: Wed, 26 Nov 2014 16:20:44 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu>	<54765FC2.2050309@pobox.com> <20141127043337.198d6084@natsu>
In-Reply-To: <20141127043337.198d6084@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 03:33 PM, Roman Mamedov wrote:
> Finished with no rewriting necessary. After that I recursively-removed the +C
> attribute from all newly reflinked files, and cp --reflink as well as
> snapshotting of those works fine.

I did some double checking and I think you'll find that if you lsattr 
those files they still have the C (NoCOW) attribute, which also means 
they are still unsummed.

Which also means that when you cp --reflink them the target files you 
create are also NoCOW.

So you harmonized the lack of checksums with the linux-level C 
attribute. This has hidden your problem but not fixed it.

(Trying to clear the NOCOW attribute on a file in BTRFS is _silently_ 
ignored as invalid. That recursive removal only changed the directories.)
