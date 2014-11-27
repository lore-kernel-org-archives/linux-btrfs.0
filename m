Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:43326 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbaK0Apr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:45:47 -0500
Message-ID: <54767437.6020807@pobox.com>
Date: Wed, 26 Nov 2014 16:45:43 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu>	<54765FC2.2050309@pobox.com>	<20141127043337.198d6084@natsu>	<54766E5C.8010909@pobox.com> <20141127052826.04bb45f5@natsu>
In-Reply-To: <20141127052826.04bb45f5@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 04:28 PM, Roman Mamedov wrote:
> On Wed, 26 Nov 2014 16:20:44 -0800
> Robert White <rwhite@pobox.com> wrote:
>> (Trying to clear the NOCOW attribute on a file in BTRFS is _silently_
>> ignored as invalid. That recursive removal only changed the directories.)
>
> And the chattr command even completes with a zero exit code, this is rather
> unexpected.

That's what "silently" means in this context. I didn't pick the result, 
and it's not what I would have done. I've got no idea if this was ever 
discussed at any length for pros-and-cons. I could make an argument for 
the silent result, or against it. Since the attribute is immutable there 
really isn't a "nope, that's just not possible dave" errno value to 
return that isn't as confusing as just skipping it.

The closest result code would be ENOSUP (operation not supported) but 
changing attributes _is_ supported, just not that particular attribute 
in that particular circumstance.

Also, the "set attributes" call sets all the attributes at once so there 
is no way to say which attribute was rejected. As such, a "do what you 
can and let the people check the result" behavior is not at all 
unreasonable.

Life is full of flaws. 8-)

