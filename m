Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:57923 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab3GZQs0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 12:48:26 -0400
Received: by mail-la0-f44.google.com with SMTP id fo12so1400876lab.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 09:48:24 -0700 (PDT)
Message-ID: <51F2A853.3000006@gmail.com>
Date: Fri, 26 Jul 2013 12:48:19 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@redhat.com>
Subject: Re: [PATCH 0/4] btrfs: offline dedupe v3
References: <1374856212-11228-1-git-send-email-mfasheh@suse.de>
In-Reply-To: <1374856212-11228-1-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/26/2013 12:30 PM, Mark Fasheh wrote:
> Hi,
>
> The following series of patches implements in btrfs an ioctl to do
> offline deduplication of file extents.
>
> To be clear, "offline" in this sense means that the file system is
> mounted and running, but the dedupe is not done during file writes,
> but after the fact when some userspace software initiates a dedupe.

I think that you might want to use the terms "inband" and "out of band" which 
seem to be used in the "de dup" storage space a bit more often.  Offline 
definitely carries the wrong connotation :)

ric

>
> The primary patch is loosely based off of one sent by Josef Bacik back
> in January, 2011.
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/8508
>
> I've made significant updates and changes from the original. In
> particular the structure passed is more fleshed out, this series has a
> high degree of code sharing between itself and the clone code, and the
> locking has been updated.

