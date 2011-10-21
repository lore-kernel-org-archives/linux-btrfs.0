From: Jim <jim@webstarts.com>
Subject: Re: snapshots changed behavior
Date: Fri, 21 Oct 2011 14:50:08 -0400
Message-ID: <4EA1BEE0.6080306@webstarts.com>
References: <4EA19E66.2020102@webstarts.com> <38803013.ZrEk6jGlKT@venice> <4EA1B9F7.1060001@webstarts.com> <4489587.KaadkGf3Et@venice>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4489587.KaadkGf3Et@venice>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo,
Here is ls -li of /sites:
[root@btrfs ~]# ls -li /btrfs/test/data
total 0
256 drwx------ 1 root root 8 Oct 21 06:21 sites

It is a subvolume but it contains directories and files below it.  The 
file tree is /btrfs (the mounted btrfs)
/test (a subvolume), /data (a subvolume), /sites (a subvolume) then many 
files and directories below /sites.  Is this information any better?
Jim

On 10/21/2011 02:43 PM, Goffredo Baroncelli wrote:
> On Friday, 21 October, 2011 14:29:11 Jim wrote:
>> Goffredo,
>> Thank you very much for your reply.  That was the information I needed
>> to understand the behavior I was observing.  Just to be sure that I
>> understand correctly, you wrote:
>>
>> I am quite sure that the snapshot is NOT recursive. If a subvolume contains
>> another subvolume, and you snapshot the former, the new subvolume shall not
>> contain the "child" subvolume.
>>
>> when I snapshot /data, a subvolume I can see (but not enter) the
>> subvolume /sites below it.
> You should be able to enter; however in the latter case /sites is a
> subdirectory instead of a subvolume.
>
> To check if a directory is a subvolume, you can see its inode number. If the
> inode number is 256, then the directory is a entry point of a subvolume.
>
>
> See this example
>
>
> # btrfs subvolume create a
> Create subvolume './a'
> # btrfs subvolume create a/b
> Create subvolume 'a/b'
> # echo 123>a/b/c
> # btrfs subvolume snapshot a d
> Create a snapshot of 'a' in './d'
> # ls -li d/
> total 0
> 2 drwxr-xr-x 1 root root 0 Oct 21 20:41 b
>
> d/b is a directory, because its inode number is 2
>
> # ls -li a/
> total 0
> 256 drwx------ 1 root root 2 Oct 21 20:41 b
>
> a/b is a subvolume because its inode number is 256
>
> # ls -li a/b
> total 0
> 257 -rw-r--r-- 1 root root 4 Oct 21 20:41 c
> # ls -li d/b/
> total 0
>
> d/b is an empty directory
>
>> When I snapshot subvolume /sites I can see
>> and navigate through all directories (not subvolumes) below it.  I am
>> assuming that this is expected behavior.  Thanks again for taking the
>> time to help me here.
>> Jim
