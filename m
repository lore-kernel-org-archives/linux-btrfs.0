From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: machine gets unresponsive during btrfs balance
Date: Fri, 13 Aug 2010 11:28:11 +0200
Message-ID: <4C65102B.6090202@gmail.com>
References: <4C639F42.3050206@gmail.com> <AANLkTi=B2dr45WmeJop_Te5t55d0trfHP+ZKLE3tBxTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=B2dr45WmeJop_Te5t55d0trfHP+ZKLE3tBxTg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12.08.2010 10:04, Yan, Zheng wrote:
> On Thu, Aug 12, 2010 at 3:14 PM, Andreas Philipp
> <philipp.andreas@gmail.com> wrote:
>   
>> Hi,
>>
>> I am using a btrfs filesystem created with raid0 for data and metadata
>> for (temporary) storage of tv recordings from my vdr. The filesystem was
>> created under kernel version 2.6.34. An initial btrfs balance command
>> succeeded. Since I upgraded to 2.6.35-rcX and 2.6.35 btrfs balance no
>> longer finishes but puts the machine in some unresponsive state.
>> Unfortunately, I do not see any kernel oops or other debug information
>> because even the display freezes. The last thing that happens are that
>> those two lines are written to /var/log/messages:
>> Aug 11 21:42:23 thor kernel: btrfs: found 62911 extents
>> Aug 11 21:42:24 thor kernel: btrfs: relocating block group 1723913469952
>> flags 9
>> After that the machine becomes immediately unresponsive.
>>
>> As I did not see anything that might be related to my problem in the
>> changelog for 2.6.35.1 I did not try again with this version.
>>
>>     
> Do you have more than one machines? would you please setup netconsole
> to see what happen.
>   
Sorry for not responding earlier but I did not find time before this
morning. After I have set up netconsole I am running btrfs balance at
the moment - now on 2.6.35.1.

Yours,
Andreas
