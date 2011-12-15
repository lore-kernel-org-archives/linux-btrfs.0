From: dima <dolenin@parallels.com>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Thu, 15 Dec 2011 10:09:01 +0900
Message-ID: <4EE948AD.9040001@parallels.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com> <CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com> <CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2011 03:51 AM, Wilfred van Velzen wrote:
> On Wed, Dec 14, 2011 at 7:21 PM, Mitch Harder
> <mitch.harder@sabayonlinux.org>  wrote:
>> On Wed, Dec 14, 2011 at 7:00 AM, Wilfred van Velzen<wvvelzen@gmail.com>  wrote:
>>>
>>> What is best practice when partitioning a device that holds one or
>>> more btr-filesystems
>>>
>>
>> When it comes to "best practices" in btrfs filesystem layouts, your
>> primary consideration should be to make yourself robust to potential
>> filesystem failure.
>>
>> Of course this should be true of any storage arrangement.
>>
>> But if you're going to be playing with rc kernels and applying patches
>> off the list, you might want to break it up into multiple partitions
>> so as to mitigate the problem if one partition picks up a
>> inconsistency.
>>
>> On the other hand, it's also good for people to use the volume and
>> subvolume features.  There's many different ways for people to make
>> use of volumes and subvolumes, and it's good to explore those
>> features.
>
> Well, of course there are different usecases for different situations.
>
> What I want to find out is, if you should partition differently when
> you are using btrfs compared to partitioning for the other
> older/regular filesystems for linux, for regular (production)
> usecases.

Maybe just skip partitioning altogether ;)  - format the device to btrfs 
and use subvolumes instead of your usual partitions (some /boot 
restrictions apply). You won't be able to use grub2 though, but syslinux 
will work.
