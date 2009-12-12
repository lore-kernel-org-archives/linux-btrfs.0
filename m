From: Andy Lutomirski <luto@mit.edu>
Subject: Re: Snapshot mysteries (and an oops)
Date: Sat, 12 Dec 2009 13:37:21 -0500
Message-ID: <4B23E2E1.4020103@mit.edu>
References: <cb0375e10912111116w284bfc33p3bc2bad00b20a9b1@mail.gmail.com> <200912112040.18415.kreijack@alice.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912112040.18415.kreijack@alice.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> Hi Andrew
> 
> On Friday 11 December 2009, Andrew Lutomirski wrote:
>> Hi all-
>>
>> [test]# rm -rf snap1
>> rm: cannot remove directory `snap1': Directory not empty
>> [test]# ls snap1
>> [test]#
>>
>> OK, so rmdir can't remove snapshots.  (Is there any good reason for that?)
> The volume is like a filesystem: you cannot remove a directory where is 
> mounted a filesystem
> 

Currently an unprivileged user can create snapshots but can't remove 
them.  Of course, allowing rmdir on an empty snapshot wouldn't help, but 
at least the admin wouldn't be confused when rm -rf fails.

>  
>> [test]# btrfsctl -D snap1
>> ioctl:: No such file or directory
>> [test]# btrfsctl -D snap1 .
>> operation complete
>> Btrfs v0.19-4-gab8fb4c
>>
>> I can't make any sense of that.  What's the second parameter to -D
>> supposed to do?
>>
>> [test]# btrfsctl -D subvol1 .
>> operation complete
>> Btrfs v0.19-4-gab8fb4c
>>
>> Phew.  That worked :)
> 
> Yes the docs may be improved. The syntax is:
> 
> btrfsctl -D <snapshotname> <directory>
> 	<snapshotname>		snapshot name
> 	<directory>		where the snapshot is
> 

What's the point of the last parameter?  Can't either btrfsctl or the 
filesystem figure that out on its own?

(Can a subvolume be "mounted" in two places at once?  If so, maybe the 
second parameter makes a tiny bit of sense.)

--Andy
