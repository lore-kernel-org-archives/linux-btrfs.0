From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Fri, 10 Jun 2011 09:33:20 -0400
Message-ID: <4DF21D20.8010304@redhat.com>
References: <201106061220.05696.markotahal@gmail.com>	<4DF179ED.1080001@mit.edu> <BANLkTi=-xRoNBQHT+qS9eA_vHQnYOBGGjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Marek Otahal <markotahal@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Andy Lutomirski <luto@mit.edu>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=-xRoNBQHT+qS9eA_vHQnYOBGGjQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2011 10:06 PM, Daniel J Blueman wrote:
> On 10 June 2011 09:57, Andy Lutomirski <luto@mit.edu> wrote:
>> On 06/06/2011 06:19 AM, Marek Otahal wrote:
>>>
>>> Hello,
>>> the issue happens every time when i have to hard power-off my notebook
>>> (suspend problems).
>>> With kernel 2.6.39 the partition is unmountable, solution is to boot
>>> 2.6.38 kernel which
>>> 1/ is able to mount the partition,
>>> 2/ by doing that fixes the problem so later .39 (after clean shutdown) can
>>> mount it also.
>>
>> Same problem here.  Mounting with 2.6.38 says:
>>
>> [   41.906259] Btrfs loaded
>> [   41.906747] device fsid e040a9d60da49596-66c0275e348878bf devid 1 transid
>> 69217 /dev/mapper/vg_midnight_ssd-home
>> [   41.908767] btrfs: disk space caching is enabled
>> [   42.232185] btrfs: unlinked 17 orphans
>> [   42.232189] btrfs: truncated 2 orphans
>>
>> dmesg in 2.6.39.1 says:
> []
>> [   15.004255] kernel BUG at fs/btrfs/inode.c:4676!
> []
> 
> I've been experiencing the same issue also.
> 
> Josef/Chris, would an metadata snapshot or full block snapshot help
> debug this regression? I can probably setup a small testcase to
> trigger this.
> 

If you can come up with a testcase to reproduce I would love you forever
;).  If I get done what I wanted to do today I will try and reproduce.
Thanks,

Josef
