Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48588 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab2JCQp7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 12:45:59 -0400
Received: by bkcjk13 with SMTP id jk13so6260726bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 09:45:58 -0700 (PDT)
Message-ID: <506C6BC8.5050809@gmail.com>
Date: Wed, 03 Oct 2012 18:46:00 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <20121003150117.GA1978@zambezi.lan>
In-Reply-To: <20121003150117.GA1978@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 05:01 PM, Ilya Dryomov wrote:
> "Type" for the first column is probably enough.
>
> Why is the third column called Chunk-size?  If my understanding is
> correct, it's just a break down of Disk_allocated from the summary
> section.  If so, why not call it Disk_allocated to avoid confusion?

Using everywhere Disk_<something> was my first attempt. But after some 
thoughts I decided that these are two different kind of information. It 
is true that Disk_allocated is the sum of Chunk-Sizes... But my feels is 
that this is a kind of "implementation details". If some other type of 
allocation unit will be added to BTRFS, then these will be added to 
Disk_allocated, but not to Chunk list...
I prefer to not change the wording until an enough critical mass of 
people converge to a unique solution .

>
> Also, why do you use dashes instead of underbars for table headers?

Yes, also Hugo noticed that.
>
> Thanks,

