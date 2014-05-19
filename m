Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:54371 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaESNBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 09:01:14 -0400
Received: by mail-ve0-f176.google.com with SMTP id jz11so6297789veb.21
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 06:01:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140519010705.GI10566@merlins.org>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
 <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com>
 <20140519010705.GI10566@merlins.org>
From: Scott Middleton <scott@assuretek.com.au>
Date: Mon, 19 May 2014 21:00:53 +0800
Message-ID: <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com>
Subject: Re: send/receive and bedup
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 May 2014 09:07, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, May 14, 2014 at 11:36:03PM +0800, Scott Middleton wrote:
>> I read so much about BtrFS that I mistaked Bedup with Duperemove.
>> Duperemove is actually what I am testing.
>
> I'm currently using programs that find files that are the same, and
> hardlink them together:
> http://marc.merlins.org/perso/linux/post_2012-05-01_Handy-tip-to-save-on-inodes-and-disk-space_-finddupes_-fdupes_-and-hardlink_py.html
>
> hardlink.py actually seems to be the faster (memory and CPU) one event
> though it's in python.
> I can get others to run out of RAM on my 8GB server easily :(
>
> Bedup should be better, but last I tried I couldn't get it to work.
> It's been updated since then, I just haven't had the chance to try it
> again since then.
>
> Please post what you find out, or if you have a hardlink maker that's
> better than the ones I found :)
>


Thanks for that.

I may be  completely wrong in my approach.

I am not looking for a file level comparison. Bedup worked fine for
that. I have a lot of virtual images and shadow protect images where
only a few megabytes may be the difference. So a file level hash and
comparison doesn't really achieve my goals.

I thought duperemove may be on a lower level.

https://github.com/markfasheh/duperemove

"Duperemove is a simple tool for finding duplicated extents and
submitting them for deduplication. When given a list of files it will
hash their contents on a block by block basis and compare those hashes
to each other, finding and categorizing extents that match each
other. When given the -d option, duperemove will submit those
extents for deduplication using the btrfs-extent-same ioctl."

It defaults to 128k but you can make it smaller.

I hit a hurdle though. The 3TB HDD  I used seemed OK when I did a long
SMART test but seems to die every few hours. Admittedly it was part of
a failed mdadm RAID array that I pulled out of a clients machine.

The only other copy I have of the data is the original mdadm array
that was recently replaced with a new server, so I am loathe to use
that HDD yet. At least for another couple of weeks!


I am still hopeful duperemove will work.

In another month I will put the 2 X 4TB HDDs online in BtrFS RAID 1
format on the production machine and have a crack on duperemove on
that after hours. I will convert the onsite backup machine to BtrFS
with its 2 x 4TB HDDs to BtrFS not long after.

The ultimate goal is to be able to back up on a block level very large
files offsite where maybe a GB is changed on a daily basis. I realise
that I will have to make an original copy and manually take that to my
datacentre but hopefully I can backup multiple clients data after
hours, or possibly,  a trickle, constantly.

Kind Regards

Scott
