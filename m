From: jim owens <jowens@hp.com>
Subject: Re: Reporting free space to userspace programs
Date: Fri, 30 Oct 2009 09:21:14 -0400
Message-ID: <4AEAE84A.5080003@hp.com>
References: <23a15590910300458y677692bbua62d2b41e9141bc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Leszek Ciesielski <skolima@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15590910300458y677692bbua62d2b41e9141bc7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Leszek Ciesielski wrote:
> Hi,
> 
> the results of running 'df' against a btrfs volume are somewhat
> unintuitive from a user point of view. On a single drive btrfs volume,
> created with 'mkfs.btrfs -m raid1 -d raid1 /dev/sda6', I am getting
> the following result:
> 
> /dev/sda6             1.4T  594G  804G  43% /mnt
> 
> while 'btrfs-show' displays much more expected result:
> 
> Label: none  uuid: 46e2f2b6-e3a6-4b02-8fdc-f9d0fb0882e0
>         Total devices 1 FS bytes used 593.15GB
>         devid    1 size 1.36TB used 1.26TB path /dev/sda6
> 
> IMHO it would be more intuitive for df in this case to show 699GB
> total capacity (based on the fact that data is mirrored, and users
> probably are not concerned with metadata handling during normal
> usage), the 'used space' probably should include the space taken up by
> metadata in addition to data usage (after all, this space is not
> available for user data) and free space should report only data space
> available (because this is what the user is usually expecting). Or, in
> other words: the result of 'df' should not concern the user with the
> details of raid0/raid1/raid10 used either for data or metadata.

I agree that df output sucks... but I've been there before with
another filesystem on another OS.  The sad fact is df output is
too simplistic for the features of modern (last 20 years) systems.

There is no way to make df report a value other than "raw space"
(which is what btrfs reports today) that will be accurate under
all possible raid conditions.  The problem is each file can be
stored in a different raid (OK not done now, but permitted) and
different COW state.  That means space_used_per_user_file_block
is not constant.

So btrfs can only report "best case" or "worst case", but neither
will be true.

jim

