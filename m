Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57360 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaLOX1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 18:27:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 16 Dec 2014 00:27:34 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <548F3F8E.408@fb.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
 <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548F3F8E.408@fb.com>
Message-ID: <d379f4ba6d50c50137078817fa44e8ff@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-15 21:07, Josef Bacik wrote:
> On 12/12/2014 09:37 AM, Tomasz Chmielewski wrote:
>> FYI, still seeing this with 3.18 (scrub passes fine on this 
>> filesystem).
>> 
>> # time btrfs balance start /mnt/lxc2
>> Segmentation fault
>> 
>> real    322m32.153s
>> user    0m0.000s
>> sys     16m0.930s
>> 
>> 
> 
> Sorry Tomasz, you are now at the top of the list.  I assume the images
> you sent me before are still good for reproducing this?  Thanks,

I've sent you two URL back then, they should still work. One of these 
filesystems did not crash the 3.18.0 kernel anymore (though there were 
many files changed / added / removed since I've uploaded the images); 
the other still did.


Tomasz

