Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:38878 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3KJHie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 02:38:34 -0500
Message-ID: <527F37F4.2070904@libero.it>
Date: Sun, 10 Nov 2013 08:38:28 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume list: what is the meaning of "top level"
References: <527E7A99.2070207@inwind.it> <35C9C3FD-BB32-4D8E-ADDA-1A5E23923442@colorremedies.com>
In-Reply-To: <35C9C3FD-BB32-4D8E-ADDA-1A5E23923442@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-09 21:18, Chris Murphy wrote:
> 
> On Nov 9, 2013, at 11:10 AM, Goffredo Baroncelli <kreijack@inwind.it>
> wrote:
>> 
>> 1	ID 256 gen 5 top level 5 path sub1 2	ID 257 gen 6 top level 5
>> path dir/sub2 3	ID 258 gen 8 top level 5 path dir/sub3 4	ID 259 gen
>> 8 top level 5 path dir/sub3/sub4 5	ID 260 gen 10 top level 5 path
>> sub5 6	ID 261 gen 10 top level 5 path sub5/sub6
> 
>> 
>> 
>> I expected that in the line 4, the top level should be 258; the
>> same for the line 6: top level should be 260. So my question is:
>> what is the meaning of the "top level" value ?
> 
> If you mount -o subvol=sub5 and then create a new subvolume, and then
> do a listing, you'll see something like what you describe. It would
> look something like:
> 
> 6	ID 262 gen 4 top level 260 path sub6
> 
> The "top level" is in a sense a prefix. So top level 5 means there is
> no prefix, the path listed is the full path. Whereas if the top level
> is e.g. 260, the implied prefix is sub5/.

Chris, many thanks, not it is clear.

> 
> If you were to mount subvolid=259 and create a subvolume in at the
> root of the mountpoint, then do a subvolume listing, it would be
> listed with top level 259 and a path of merely "newname" rather than
> dir/sub3/sub4/newname.
> 
> So just consider the top level a prefix for the listed path, and if
> the top level is 5, there is no prefix for path, the path is the full
> path.
> 
> 
> Chris Murphy-- To unsubscribe from this list: send the line
> "unsubscribe linux-btrfs" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
