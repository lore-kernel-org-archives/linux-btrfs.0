Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob07.myregisteredsite.com ([209.17.115.45]:54668 "EHLO
	atl4mhob07.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432Ab3E0QmG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 12:42:06 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.113])
	by atl4mhob07.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4RGg4IB025934
	for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 12:42:04 -0400
Message-ID: <51A38CE5.1010003@chinilu.com>
Date: Mon, 27 May 2013 09:42:13 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: systemd "journalctl" is 1.89sec on ext4, 1.49 min on btrfs
References: <16735484.PAleCPYpY8@noname>
In-Reply-To: <16735484.PAleCPYpY8@noname>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have gotten what appear to be large increases in speed out of btrfs by 
defragmentation of meta data. The manual defragmentation process takes 
forever as you have to defragment incrementally directory by directory.  
I was at the point where KDE startup times were getting abysmal (along 
with journalctl, etc) and the multiple drives would churn incessantly on 
startup.  In the case of KDE, I found almost magical improvement with 
one operation:  `btrfs filesystem defrag /usr/share`.  I am currently 
going through the whole system deframenting directory by directory.  Its 
amazing, it proceeds quite quickly and then hits a directory at random 
where it sits and plods away seemingly forever before moving on.  I am 
convinced that there is something going on here with meta data 
fragmentation that, at times, is seriously affecting performance.  I 
*think* that autodefrag, once its out the door will hopefully solve 
this, in the mean time I am trying to come up with some sort of way to 
schedule an anacron job to deal with this issue.  But my suggestion 
would be that you try defragging your /var filesystem as thoroughly as 
possible on the meta data side.

On 05/27/2013 09:21 AM, Szőts Ákos wrote:
> Dear list,
>
> I have two openSUSE 12.3 systems with kernel 3.9. On one of them there's an
> ext4 partition, while on the other there's a btrfs.
>
> I issued a "time journalctl -b --no-pager" command on both systems. This shows
> the logs from the current boot without passing them to "less".
>
> On ext4 (3.9.3):
> real    0m1.898s
> user    0m0.291s
> sys     0m0.105s
>
> On btrfs (3.9.2):
> real    1m49.698s
> user    0m0.102s
> sys     0m0.470s
>
> Journalctl on btrfs was always this slow, some btrfsck were made on the file
> system too, but I don't think it was corrupted. On just the first run it's
> sluggish, after it's fast as the ext4 one.
>
> Is it a known issue or can I help somehow debugging this further?
>
> Best regards,
>
> Ákos Szőts
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

