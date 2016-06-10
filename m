Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41071 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbcFJV4f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 17:56:35 -0400
Subject: Re: Cannot balance FS (No space left on device)
To: ojab // <ojab@ojab.ru>, Henk Slager <eye1tm@gmail.com>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
 <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <575B378E.8050304@mendix.com>
Date: Fri, 10 Jun 2016 23:56:30 +0200
MIME-Version: 1.0
In-Reply-To: <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2016 11:33 PM, ojab // wrote:
> On Fri, Jun 10, 2016 at 9:00 PM, Henk Slager <eye1tm@gmail.com> wrote:
>> I have seldom seen an fs so full, very regular numbers :)
>>
>> But can you provide the output of this script:
>> https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py
>>
>> It gives better info w.r.t. devices and it is then easier to say what
>> has to be done.
>>
>> But you have btrfs raid0 data (2 stripes) and raid1 metadata, and they
>> both want 2 devices currently and there is only one device with place
>> for your 2G chunks. So in theory you need 2 empty devices added for a
>> balance to succeed. If you can allow reduces redundancy for some time,
>> you could shrink the fs used space on hdd1 to half, same for the
>> partition itself, add a hdd2 parttition and add that to the fs. Or
>> just add another HDD.
>> Then your 50Gb of deletions could get into effect if you start
>> balancing. Also have a look at the balance stripe filters I would say.
>
> Output of show_usage.py:
> https://gist.githubusercontent.com/ojab/850276af6ff3aa566b8a3ce6ec444521/raw/4d77e02d556ed0edb0f9823259f145f65e80bc66/gistfile1.txt
> Looks like I only have smaller spare drives at the moment (largest is
> 100GB), is it ok to use? Or there is some minimal drive size needed
> for my setup?

You can work around it by either adding two disks (like Henk said), or 
by temporarily converting some chunks to single. Just enough to get some 
free space on the first two disks to get a balance going that can fill 
the third one. You don't have to convert all of your data or metadata to 
single!

Something like:

btrfs balance start -v -dconvert=single,limit=10 /mnt/xxx/

New allocated chunks will go to the third disk, because it has the most 
free space.

After this, you can convert the single data back to raid0:

btrfs balance start -v -dconvert=raid0,soft /mnt/xxx/

soft is important, because it only touches everything that is not raid0 yet.

And in the end there should be a few GB of free space on the first two 
disks, so you can do the big balance to spread all data over the three 
disks, just btrfs balance start -v -dusage=100 /mnt/xxx/

Review the commands before doing anything, as I haven't tested this 
here. The man page for btrfs-balance contains all info :)

Looking at btrfs balance status, btrfs fi show etc, in another terminal 
while it's working is always nice, so you see what's happening, and you 
can always stop it when you think it moved around enough data with btrfs 
balance cancel.

Moo,

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
