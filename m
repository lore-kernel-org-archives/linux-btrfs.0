From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC] Btrfs design defect in extent backref ?
Date: Fri, 26 Aug 2011 11:04:39 +0800
Message-ID: <4E570D47.2080207@cn.fujitsu.com>
References: <4E560018.9060005@cn.fujitsu.com>	<CAAM7YAkxNcC_dk4uUnYFUoynkzb2Mx2KmJrNT+GJ8oZGKp3JqA@mail.gmail.com>	<4E56FE4B.80606@cn.fujitsu.com> <CAAM7YA=o0pALbSpHqPHwM+3M2DEmShzxcpUXReVD=vjOt=fhuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Zheng <zheng.z.yan@intel.com>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAM7YA=o0pALbSpHqPHwM+3M2DEmShzxcpUXReVD=vjOt=fhuQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng wrote:
> On Fri, Aug 26, 2011 at 10:00 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Yan, Zheng wrote:
>>> On Thu, Aug 25, 2011 at 3:56 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>> We have an offset in file extent to indicate its position in the
>>>> corresponding extent item in extent tree. We also have an offset in
>>>> extent item to indicate the start position of the file extent that
>>>> uses this item.
>>>>
>>>> The math is:
>>>>
>>>>    extent_item.extent_data_ref.offset = file_pos - file_extent.extent_offset.
>>>>
>>>>                       e1
>>>> disk extents:    |--------------|
>>>>                 ^
>>>>                 |                  e2
>>>>                 |          |-----------------|
>>>>                 |          |   ^
>>>>                 |          |   |
>>>>                 v          v   |
>>>> file extents:    |----- f1 -----|----- f2 -----|
>>>>
>>>> So it looks like e2.offset points to f1 not f2. Therefore given an extent item,
>>>> we'll have to search through all the file extents in an inode to find the
>>>> relative file extent in the worst case, which makes this field somewhat useless.
>>>>
>>>
>>> The reason for this is reducing number of file extent backref itmes.
>>
>> It seems to me a rare case, which isn't worth the complexity and inconvenience
>> it brings, and it requires an extra field (.count).
>>
> Random write workload isn't a rare case.
> 

Ah, I was thinking about the clone ioctl, and ignoring other situations.

Thanks for your clarification.
