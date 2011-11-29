From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write
 devices V2
Date: Tue, 29 Nov 2011 09:26:01 +0800
Message-ID: <4ED434A9.8020809@cn.fujitsu.com>
References: <1312205910-13053-1-git-send-email-apw@canonical.com> <20111128121041.GA19498@elie.hsd1.il.comcast.net> <20111128122416.GA25996@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Ivan Vilata i Balaguer <ivan@selidor.net>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128122416.GA25996@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

Andy Whitcroft wrote:
> On Mon, Nov 28, 2011 at 06:11:06AM -0600, Jonathan Nieder wrote:
>> Hi,
>>
>> Andy Whitcroft wrote:
>>
>>> When we mount a btrfs filesystem from read-only media there will be no
>>> read/write devices; for example mounting an SD card with its lock enabled.
>>> This triggers an immediate BUG during mount:
>>>
>>>   kernel BUG at .../fs/btrfs/super.c:984!
>> [...]
>>> BugLink: http://bugs.launchpad.net/bugs/816770
>>> Signed-off-by: Andy Whitcroft <apw@canonical.com>
>>> ---
>>
>> Fixes http://bugs.debian.org/649847
>> Tested-by: Ivan Vilata i Balaguer <ivan@selidor.net>
>>
>> This patch fixes a regression introduced by 6d07bcec969a ("btrfs: fix
>> wrong free space information of btrfs"), which hit mainline in
>> v2.6.38-rc1.  Josef Bacik acked the patch, but I can't seem to find it
>> in linux-next, linux-btrfs, or Josef's btrfs-work tree.  Maybe it was
>> just forgotten.
>>
>> What can I do to help this patch get unstuck?
> 
> I had completely forgotten about this one.  I wonder where it did get
> to.  I seem to remember testing this in house successfully.
> 

This patch has the same problem with your previous one, that it will set
f_bavail to 0. I've sent out a new patch yesterday.
