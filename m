From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: btrfs and apt package manager in ubuntu
Date: Fri, 05 Nov 2010 12:25:03 +0100
Message-ID: <4CD3E98F.7070505@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> On Sun, Oct 31, 2010 at 11:21:36AM -0500, Christian wrote:
>> On Sun, 2010-10-31 at 16:17 +0300, Abdullah Ansari wrote:
>> > it's very slow in installtion with apt in ubuntu
>>
>> I'm seeing the same thing. When installing using apt the disk grinds
>> "forever" before the installation completes. I have two identical
>> laptops running Linux Mint 10 (rc) with similar disk layout except that
>> one has two btrfs partitions while the other only has ext4. The one with
>> btrfs takes at least 10 times longer to install updates on than the ext4
>> one.
>
> That's because dpkg uses sync when unpacking each package.

It's also quite painful when one runs a virtual machine (KVM) which has 
a btrfs filesystem (the virtual machine disk being itself on host's ext4).

While updating or installing a large number of packages (i.e. 50-100 MB) 
on a guest with btrfs filesystem, you can _really_ feel it on the host 
(system load - 10-20 or more) and other virtual machines (i.e. SSH times 
out when trying to log in to other virtual machines).


-- 
Tomasz Chmielewski
http://wpkg.org

