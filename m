Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40544 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1764753AbcLVK1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 05:27:04 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cK0aN-0002zB-6k
        for linux-btrfs@vger.kernel.org; Thu, 22 Dec 2016 11:26:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [bug or by design ?] btrfs defrag compression does not persist
Date: Thu, 22 Dec 2016 10:26:43 +0000 (UTC)
Message-ID: <pan$aa20d$b26e35f6$8028e3f5$5aebde82@cox.net>
References: <16053303-2857-9729-a94f-d697004f019d@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Thu, 22 Dec 2016 10:28:28 +0800 as excerpted:

> A quick design specific question.
> 
> The following command converts file-data-extents to the specified
> encoder (lzo).
> 
>    $ btrfs filesystem defrag -v -r -f -clzo dir/
> 
> However the lzo property does not persist through the file modify.
> As the above operation does not update the btrfs.compression property.
> 
> Question:
>   I wonder if this should be a bug or if its by design ? What could be
>   the main use case to _associate compression at the time of defrag_ ?
>   The no-conflict fix will be to add another option to make it
>   persistent.

I'd say it's a feature (whether deliberately designed that way or not).  
Presumably, if you want real-time compression, you're using the 
appropriate mount option or already setting the property on the file(s) 
in question.  Which leaves defrag-with-compression runs for one-time 
compression of cold data that's unlikely to change further, or for 
periodic compression runs during slow periods or the like, when you know 
it's not going to be an issue, even if it would be an issue if done in 
real-time production, thus the reason you're not running with the option 
already.

A practical example would be someone using the compress=lzo mount option 
for real-time work, then using defrag-and-compress to compress to zlib 
level either during slow periods, or when files have been rotated out of 
active use and are no longer being actively rewritten/appended.  They 
don't /want/ further modifications compressed to the same level in real-
time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

