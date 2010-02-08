From: jim owens <jowens@hp.com>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
 	available size?
Date: Mon, 08 Feb 2010 09:33:35 -0500
Message-ID: <4B7020BF.4010302@hp.com>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org>	 <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com>	 <4B63634F.6090600@computer.org> <4B63735E.1060609@hp.com>	 <c67eed301001291553m8d59819oaab942b42e10c35d@mail.gmail.com>	 <4B645215.6060006@hp.com> <c67eed301002071954n2c8500adrd634b914cfe34484@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: RK <rkasl@computer.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
To: 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301002071954n2c8500adrd634b914cfe34484@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

0bo0 wrote:
> On Sat, Jan 30, 2010 at 7:36 AM, jim owens <jowens@hp.com> wrote:
>> So Josef Bacik has sent patches to btrfs and btrfs-progs that
>> allow you to see raid-mode data and metadata adjusted values
>> with btrfs-ctrl -i instead of using "df".
>>
>> These patches have not been merged yet so you will have to pull
>> them and apply yourself.
> 
> Where exactly can these be pulled from? Is there a separate git tree?
> I just built from the btrfs & btrfs-progs heads, and still do not see
> these add'l features.

Chris does not merge patches into the tree until they are
pushed to Linus. Sometimes he creates "experimental" branches
with code for testing but I don't think he has done that recently.

You can find proposed unmerged patches at:

http://patchwork.kernel.org/project/linux-btrfs/list/

jim
