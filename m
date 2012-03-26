From: Travis Shivers <ttshivers@gmail.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Mon, 26 Mar 2012 18:15:44 -0500
Message-ID: <CAPeorG9QVfQC7cAFOZ7t2RVG-ojxuhQ5eLDDP-Dt1UwBAG9OaA@mail.gmail.com>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com> <20120229025027.GB15383@shiny>
 <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
 <CAE5mzvixYURzdNX3snjjJESUNUBz316YjzDxfZe6-Q2TGBMYww@mail.gmail.com>
 <CAPeorG9E0SDXqoa7VeUASxAbtBf+voQVRgfZ_FtOb3d6nbe-ZQ@mail.gmail.com>
 <20120229135926.GB5054@shiny> <CAPeorG9u6Z-Z5QnxAc5QB3ZzrR17+3Y2t-UQFd8v_aqN-rVwTA@mail.gmail.com>
 <20120229221414.GS5054@shiny> <CAPeorG-rC6_bM+vX0Jyap74TdRr7cgQjBfb_PBvNHDz-yyQkWw@mail.gmail.com>
 <20120229234437.GT5054@shiny> <CAPeorG8xpyeetBRSAt092Ac2qMcvFLLi2utXvfSgYWbzt0M3zw@mail.gmail.com>
 <CAPeorG-Zrr-fTaYmHHKQ5=0jL9ZqjbTypGzo7je3g=MJDPmXcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Travis Shivers <ttshivers@gmail.com>,
	cwillu <cwillu@cwillu.com>, Gurudas Pai <gurudas.pai@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPeorG-Zrr-fTaYmHHKQ5=0jL9ZqjbTypGzo7je3g=MJDPmXcA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was just wondering what the status of the patch that would fix my
problem is. I have not heard from anyone in over a month, and I just
wanted to check in and see how it is progressing, or if you have put
it on hold for more important work like kernel 3.4. Thank you again
for helping me.

On Fri, Mar 16, 2012 at 12:26 PM, Travis Shivers <ttshivers@gmail.com> =
wrote:
>
> When you finish the patch, where should I get it from? Is it a genera=
l btrfs patch, and I would grab it in the next kernel release, or is it=
 a specific patch for me, and I would grab it from a btrfs repository? =
Thanks again for all of your help.
>
>
> On Wed, Feb 29, 2012 at 5:58 PM, Travis Shivers <ttshivers@gmail.com>=
 wrote:
>>
>> I was running a fairly old version of the kernel:
>> Linux server 3.0.0-16-generic #28-Ubuntu SMP Fri Jan 27 17:44:39 UTC
>> 2012 x86_64 x86_64 x86_64 GNU/Linux
>>
>> On Wed, Feb 29, 2012 at 5:44 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > On Wed, Feb 29, 2012 at 05:11:24PM -0600, Travis Shivers wrote:
>> >> Thank you all for helping. My btrfs array consists of 4 disks: 2 =
(2
>> >> TB) disks and 2(500 GB) disks. Since I have disks of different si=
zes,
>> >> I have the array being mirrored so that there are two copies of a=
 file
>> >> on two separate disks. The data and metadata are mirrored.
>> >>
>> >> I originally made the array by using this command:
>> >>
>> >> # mkfs.btrfs -m raid1 -d raid1 /dev/sd[abcd]
>> >> (The drives were originally those letters)
>> >>
>> >>
>> >> All of the disks sit in an external 4 bay ESATA enclosure going i=
nto a
>> >> PCI-E RAID card set up as JBOD, so I can use btrfs' software
>> >> mirroring. This is the enclosure that I have:
>> >> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132029
>> >>
>> >> The corruption was unexpected. I am not entirely sure what caused=
 it,
>> >> but a few days before the corruption, there were several power
>> >> outages. I do not think that the problem is with the actual hard =
drive
>> >> hardware since they are fairly new (6 months old) and they pass a=
ll
>> >> SMART tests. After a reboot, the btrfs array refused to mount and
>> >> started giving off errors. I do weekly scrubs, balances, and
>> >> defragmentation.
>> >
>> > Ok, all of this should have worked. =A0Which kernel were you runni=
ng when
>> > you had the power outages?
>> >
>> > I'm testing out the patch to skip the extent allocation tree at mo=
unt.
>> > That will be the easiest way to get to the data (readonly, but it'=
ll
>> > work).
>> >
>> > -chris
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
