From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 12/12] Btrfs: Fix file clone when source offset is not
 0
Date: Thu, 02 Feb 2012 22:00:30 +0100
Message-ID: <4F2AF96E.3040201@jan-o-sch.net>
References: <4D412FE6.7050101@cn.fujitsu.com>	<4D4130D4.2000001@cn.fujitsu.com>	<4F215AA0.8040505@jan-o-sch.net>	<4F2639BF.80702@cn.fujitsu.com>	<4F266AEB.6030403@jan-o-sch.net> <CAAM7YAkWj2Avf8zA_Vb-QC-YL8wOBuPPXOEENkSB9vmx5vbEHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAM7YAkWj2Avf8zA_Vb-QC-YL8wOBuPPXOEENkSB9vmx5vbEHA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



On 02.02.2012 05:31, Yan, Zheng wrote:
> On Mon, Jan 30, 2012 at 6:03 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>> On 30.01.2012 07:33, Li Zefan wrote:
>>> Jan Schmidt wrote:
>>>> [...]
>>> Unfortunately this is expected. The calculation is:
>>>
>>> extent_item.extent_data_ref.offset = file_pos - file_extent.extent_offset
>>>
>>> so you may get negative offset.
>>
>> I see where the negative offset comes from. But what can this offset be
>> used for?
>>
> 
> The offset in backref isn't equal to the offset of the file extent,
> it's just a hint for searching
> file extents

I see. Thanks for clarifying.

And, Li: Thanks for bringing the old thread back to my mind.

Nevertheless, that still seems quite a strange choice to me. Is there a
deep sense behind it that is deeper than I'm currently looking?

-Jan
