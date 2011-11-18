From: Stefan Kleijkers <stefan@unilogicnetworks.net>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Fri, 18 Nov 2011 20:30:51 +0100
Message-ID: <4EC6B26B.1020000@unilogicnetworks.net>
References: <4EBA54F2.3030801@unilogicnetworks.net> <20111109153552.GB1810@localhost.localdomain> <4EBBBFFA.5090000@unilogicnetworks.net> <20111114160342.GB1947@localhost.localdomain> <4EC2B9E7.7020609@unilogicnetworks.net> <20111115192926.GB1944@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111115192926.GB1944@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

I've two new dmesg's (ceph osd 0 and 1). Both filesystems wheren't 
responding anymore. Please let me know if you need more information or 
another run. Both are made with the 3.1.1 kernel and your patches 
applied (the patches with the extra warning messages).

Paste:
OSD.0: http://pastebin.com/tPjMk0kH
OSD.1: http://pastebin.com/ef7A16g2

Stefan

On 11/15/2011 08:29 PM, Josef Bacik wrote:
> On Tue, Nov 15, 2011 at 08:13:43PM +0100, Stefan Kleijkers wrote:
>> Hello Josef,
>>
>> We have patched the 3.1.1 kernel with your patch and after a short
>> time one of the ceph osds crashed (core dumped) and I found this in
>> the dmesg, please let me know if that's enough information or if you
>> need more.
>>
> Yeah I was hoping for a WARN_ON() that should have shown up before that, do you
> have the entire dmesg?  Thanks,
>
> Josef

