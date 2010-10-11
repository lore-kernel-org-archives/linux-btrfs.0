From: Nathan Caza <mastercactapus@gmail.com>
Subject: Re: On-Disk Format
Date: Mon, 11 Oct 2010 02:28:32 -0500
Message-ID: <AANLkTikq4RmGB7VZG3poS_Qd_d7y=jD++aFEKvA_yaw5@mail.gmail.com>
References: <AANLkTi=6cFSe9Fmg6U35qHYRav-=rTBoGH1BmPNVJkDY@mail.gmail.com>
	<20101011044035.GA2090@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Nathan Caza <mastercactapus@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101011044035.GA2090@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

How is a device checked (when being scanned) to contain a btrfs
filesystem? I have a filesystem spread across two devices; one of them
is not being detected; the first (@64KiB) superblock is missing (not
sure why); but the second one (64MiB) seems valid (fs uuid + dev uuid
and all); would i have to create a superblock for the beginging of the
drive? (or mirror the 64mb one and change the physical address and
checksum)??

On Sun, Oct 10, 2010 at 11:40 PM, Sean Bartell
<wingedtachikoma@gmail.com> wrote:
> On Sun, Oct 10, 2010 at 10:43:56PM -0500, Nathan Caza wrote:
>> Is this up-to-date? if not, has anyone put together something like
>> this more recent??
>>
>> https://btrfs.wiki.kernel.org/index.php/User:Wtachi/On-disk_Format
>
> It should be up-to-date, to the extent that it contains any useful
> information at all. It's basically a sketch I wrote when I was first
> figuring out btrfs, and I haven't gotten around to filling in the
> details.
>
