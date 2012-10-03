Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43044 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2JCUBA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 16:01:00 -0400
Received: by bkcjk13 with SMTP id jk13so6363426bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 13:00:59 -0700 (PDT)
Message-ID: <506C997C.5070301@gmail.com>
Date: Wed, 03 Oct 2012 22:01:00 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <20121003150117.GA1978@zambezi.lan> <506C6BC8.5050809@gmail.com> <20121003174643.GB2890@zambezi.lan>
In-Reply-To: <20121003174643.GB2890@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 07:46 PM, Ilya Dryomov wrote:
> On Wed, Oct 03, 2012 at 06:46:00PM +0200, Goffredo Baroncelli wrote:
>> On 10/03/2012 05:01 PM, Ilya Dryomov wrote:
>>> "Type" for the first column is probably enough.
>>>
>>> Why is the third column called Chunk-size?  If my understanding is
>>> correct, it's just a break down of Disk_allocated from the summary
>>> section.  If so, why not call it Disk_allocated to avoid confusion?
>>
>> Using everywhere Disk_<something>  was my first attempt. But after
>> some thoughts I decided that these are two different kind of
>> information. It is true that Disk_allocated is the sum of
>> Chunk-Sizes... But my feels is that this is a kind of
>> "implementation details". If some other type of allocation unit will
>> be added to BTRFS, then these will be added to Disk_allocated, but
>> not to Chunk list...
>> I prefer to not change the wording until an enough critical mass of
>> people converge to a unique solution .
>
> It is the chunks that is the implementation detail that we want to hide.
> Average Btrfs user wouldn't want to know anything about chunks, the only
> thing he'd be interested in is Disk_allocated and similar fields.

The "df" standard tool id sufficient for the "average user".
We need only to export these information via the standard syscall 
stat[v]fs. Basically we should try to implement the algorithm of the 
Free_(Estimated) space for the statfs(2) syscall.
Who uses btrfs tools, is an user with knowledge of btrfs higher than the 
average.

> Moreover, I am pretty sure "Chunk-Size" would actually confuse people.
> I stared at your example output for a few seconds trying to comprehend a
> 21GB Chunk-Size on a 72GB partition.  What you call "Chunk-Size" is
> actually a sum of sizes of chunks of that particular type, and a few
> lines above you call the same exact sum (only this time over all types
> of chunks) "Disk_allocated".  So I think it's only logical to rename the
> column in question to "Disk_allocated" to match the summary section.

What about
[...]
Details:
   Chunk_type  Mode      Size_(disk) Size_(logical)     Used
   Data        Single       21.01GB      21.01GB     10.53GB
   System      DUP          80.00MB      40.00MB      4.00KB
[...]

?

Still I am still not entirely satisfied; I am open to other suggestions, 
but until now every people has a different opinion. If we reach an 
agreement between two/three persons (even different from my opinion) I 
will update the patches. Otherwise I suggest to accept these patches "as 
is" because there no is a "general" consensus to a wording...

> Thanks,
>
> 		Ilya
>
Ciao
Goffredo
