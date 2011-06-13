From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: use the normal checksumming infrastructure for
 free space cache
Date: Mon, 13 Jun 2011 10:10:04 +0800
Message-ID: <4DF5717C.2080700@cn.fujitsu.com>
References: <1307734827-10697-1-git-send-email-josef@redhat.com> <4DF56D60.4070208@cn.fujitsu.com> <1307929964-sup-6781@shiny> <4DF57065.3090109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF57065.3090109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan wrote:
> Chris Mason wrote:
>> Excerpts from Li Zefan's message of 2011-06-12 21:52:32 -0400:
>>> Josef Bacik wrote:
>>>> We used to store the checksums of the space cache directly in the space cache,
>>>> however that doesn't work out too well if we have more space than we can fit the
>>>> checksums into the first page.  So instead use the normal checksumming
>>>> infrastructure.  There were problems with doing this originally but those
>>>> problems don't exist now so this works out fine.  Thanks,
>>>>
>>>
>>> This looks great, so I'll drop my patch that extends the original code to
>>> allow more than 1 crc page.
>>
>> I do like them a lot, but what happens when a special case crc kernel
>> mounts a free space cache created by this patch?
>>
> 
> So we need a check, like the one in load_free_space_cache():
> 

oh I misunderstood your question..
