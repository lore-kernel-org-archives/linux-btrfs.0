From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: curious writes on mounted, not used btrfs filesystem
Date: Sun, 22 May 2011 11:52:37 +0200
Message-ID: <4DD8DCE5.6070703@wpkg.org>
References: <4DD7B6ED.5040403@wpkg.org> <20110522093352.GA22491@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110522093352.GA22491@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On 22.05.2011 11:34, Stephane Chazelas wrote:
> 2011-05-21 14:58:21 +0200, Tomasz Chmielewski:
>> I have a btrfs filesystem (2.6.39) which is mounted, but otherwise, not used:
>>
>> # lsof -n|grep /mnt/btrfs
>
> processes with open fds are one thing. You could also have loop
> devices setup on it for instance.

I know.
It's _not_ used by anything.


>> #
>>
>>
>> I noticed that whenever I do "sync", btrfs will write for around 6.5s and write 13 MB (see below).
> [...]
>
> You could try and play with /proc/sys/vm/block_dump to see what
> is being written (remember to disable logging of kernel messages
> by syslog).

It doesn't give me any hints, really.


Can you try running these commands yourself:

iostat -k 1 </your/btrfs/device>


And in a second terminal:

while true; do sync ; done


To see if your btrfs makes writes on sync each time?


-- 
Tomasz Chmielewski
http://wpkg.org
