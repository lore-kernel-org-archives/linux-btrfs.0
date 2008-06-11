From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: FileSystem level compression support.
Date: Wed, 11 Jun 2008 09:42:34 -0400
Message-ID: <484FD64A.8000106@redhat.com>
References: <f058a9c30806110413y39102d33t98cd685f289beb2d@mail.gmail.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30806110413y39102d33t98cd685f289beb2d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Miguel Sousa Filipe wrote:
> Hi there,
>
> Providing compression and/or encryption at the file system layer has
> proven to be contentious and polemic, at least in the linux kernel
> world.
>
> However, I would like to probe you guys (specially Chis Mason) about
> your thoughts on the issue.
> I have seen quite a few benchs were compression provides better
> performance, since it reduces the amount of IO.
> It seems to be a cpu/io trade-off. And given that cpu power is more
> easily accessible than fast IO.. it is starting to look a good idea
> that should be more deeply explored.
>
> Is compression for data on BTRFS a feature that is:
> - completely out of the table - it will not happen at the BTRFS layer
> - considered, but no efforts on developing this feature are planed.
> - considered, and design decisions are contemplating it.. but no code
> yet.. not this soon. (not for 1.0)
>
>
> Kind regards!
>
>   
One big issue with compression is that it is very workload dependent. 
For example, if you are storing lots of video, sound or image files, the 
format itself it normally already compressed so you end up doing nothing 
but burning CPU cycles ;-) Also, for very small files, compression works 
best when you bunch them up (say compress the contents of a subdirectory).

Also note that some storage devices can do compression for you beneath 
the file system or do other fancy features like block level data 
de-duplication.

ric

