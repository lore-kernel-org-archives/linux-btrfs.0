Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:64935 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaGPKw1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 06:52:27 -0400
Message-ID: <53C658F6.1070301@informatik.uni-bonn.de>
Date: Wed, 16 Jul 2014 12:50:30 +0200
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why does btrfs defrag work worse than making a copy of a file?
References: <53C59A66.7010107@informatik.uni-bonn.de> <20140716075345.GB29931@localhost.localdomain>
In-Reply-To: <20140716075345.GB29931@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16.07.2014 09:53, Liu Bo wrote:
> On Tue, Jul 15, 2014 at 11:17:26PM +0200, Sebastian Ochmann wrote:
>> Hello,
>>
>> I have a VirtualBox hard drive image which is quite fragmented even
>> after very light use; it is 1.6 GB in size and has around 5000
>> fragments (I'm using "filefrag" to determine the number of
>> fragments). Doing a "btrfs fi defrag -f image.vdi" reduced the
>> number of fragments to 3749. Even doing a "btrfs fi defrag -f -t 1
>> image.vdi" which should make sure every extent is rewritten
>> (according to the btrfs-progs 3.14.2 manpage) does not yield any
>> better result and seems to return immediately. Copying the file,
>> however, yields a copy which has only 5 fragments (simply doing a cp
>> image.vdi image2.vdi; sync; filefrag image2.vdi).
>>
>> What do I have to do to defrag the file to the minimal number of
>> fragments possible? Am I missing something?
>
> So usually btrfs thinks of an extent whose size is bigger than 256K as a big
> enough extent.
>
> Another possible reason is that there is something wrong with btrfs_fiemap which
> gives filefrag' a wrong output.
>
> Would you please show us the 'filefrag -v' output?

Sure, I have pasted the output of "filefrag -v" here:

http://pastebin.com/kcZhVhkc

However, I think the problem is merely in the documentation (manpage of 
btrfs-filesystem). The description of the "-t" option is different in 
two locations and doesn't make sense in general, I think. It is first 
described as follows:

"Any extent bigger than threshold given by -t option, will be considered 
already defragged. Use 0 to take the kernel default, and use 1 to say 
every single extent must be rewritten."

So I used "-t 1" because I thought it will defrag as much as possible. 
However when thinking about it, any extent at least 1 byte (or 2 bytes?) 
in size will be ignored this way, am I correct?

Further below, the "-t" option is described as follows:

"-t <size>  defragment only files at least <size> bytes big"

Here, the option suddenly refers to the file size. In any case, doing a 
"btrfs fi defrag -f -t 10G image.vdi" defragged my file to the 5 extents 
I also get by simply copying the file. I think the documentation should 
be updated to reflect what the -t option actually does.

Best regards
Sebastian


> thanks,
> -liubo
>
>>
>> Kernel version 3.15.5, btrfs progs 3.14.2, Arch Linux.
>>
>> Best regards,
>> Sebastian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
