From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: can't unmount
Date: Thu, 12 Aug 2010 10:57:10 -0700
Message-ID: <4C6435F6.6030708@noir.com>
References: <4C641969.9070405@noir.com> <4C641A31.4090603@noir.com> <-3215279523596534788@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <-3215279523596534788@unknownmsgid>
List-ID: <linux-btrfs.vger.kernel.org>

  On 8/12/10 10:46 , C Anthony Risinger wrote:
> On Aug 12, 2010, at 10:58 AM, "K. Richard Pixley"<rich@noir.com>  wrote:
>> And should I be worried about what umount -l might be leaving
>> behind?  (eg, any unfreed kernel resources)  Or is that a reasonable
>> way to deal with this situation on an ongoing basis?
>>
>> On 8/12/10 08:55 , K. Richard Pixley wrote:
>>> I'm running into a situation where I can't unmount a mounted
>>> snapshot.  It shows "busy" even though neither lsof nor fuser show
>>> any open files.  Umount -f doesn't work although umount -l does.
>>>
>>> Is there anything else I can do to debug this scenario or to clear
>>> the busy status myself?  Or am I down to rebooting each time?
>>>
>>> This is on stock ubuntu-10.04, x86.
> You are lazy unmounting, as I understand, you are essentially just
> hiding the fact that the mount was busy to userspace... The mount will
> remain active in the kernel until you resolve whatever was stopping
> umount in the first place; kernel will then silently unmount.
Understood.
> Does this affect all of your mounted snapshots, or only a particular
> one?
I'm only mounting one at a time so I haven't noticed.  Will check next 
time it occurs.

--rich
