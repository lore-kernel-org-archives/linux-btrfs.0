Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:34402 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbaJ1AjS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 20:39:18 -0400
Message-ID: <544EE5B1.5040704@pobox.com>
Date: Mon, 27 Oct 2014 17:39:13 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Christian Tschabuschnig <tschaboo@gmx.at>, linux-btrfs@vger.kernel.org
Subject: Re: Does btrfs-restore report missing/corrupt files?
References: <trinity-716ca1fa-5a94-4624-9e01-8f4c4b500e46-1414310389248@3capp-gmx-bs26>
In-Reply-To: <trinity-716ca1fa-5a94-4624-9e01-8f4c4b500e46-1414310389248@3capp-gmx-bs26>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2014 12:59 AM, Christian Tschabuschnig wrote:
>
> Hello,
>
> currently I am trying to recover a btrfs filesystem which had a few subvolumes. When running
> # btrfs restore -sx /dev/xxx .
> one subvolume gets restored.

Important Aside: The one time I had to resort to btrfs restore I didn't 
get the contents of _many_ of the really small files. My _guess_ is that 
those where the files small enough to reside entirely within the 
original filesystem's metadata.

You should mount the filesystem read-only and recursively copy the 
hirearchy to another file system as well as doing a restore. The two 
results can then be folded together, or at least the former might help 
you find some of what the latter might miss.

I could be totally wrong, or restore could have been improved since 
then, but it was what seemed to be happening.
