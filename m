Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f68.google.com ([74.125.83.68]:60035 "EHLO
	mail-ee0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3JZVxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 17:53:25 -0400
Received: by mail-ee0-f68.google.com with SMTP id b45so944802eek.11
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 14:53:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C5E10710-8D46-44D4-AC38-FB66B9938BB1@colorremedies.com>
References: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
	<C5E10710-8D46-44D4-AC38-FB66B9938BB1@colorremedies.com>
Date: Sat, 26 Oct 2013 23:53:24 +0200
Message-ID: <CAEezp7uaoZow7vjArHq4E+aD9nxTwEFwvd5VrjUUuNcn4-B1cQ@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 26, 2013 at 11:35 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 26, 2013, at 1:46 PM, Igor M <igork20@gmail.com> wrote:
>>
>> # mount -t btrfs -o compress=lzo,compress-force=lzo /
>
> Why do you have two compression mount options? You need to pick one of these.


I removed one. I was thinking both were needed.

>
>> What to do ?
>
> Are there any kernel messages reported by dmesg at the time the copy starts and fails? What's the exact copy command you're using?

No messages. Just whem mounting:

device fsid c0bfcb22-8b7c-4936-afcd-
7acdf58f1d6c devid 1 transid 622 /dev/sdb
btrfs: force lzo compression
btrfs: disk space caching is enabled

I even added enospc_debug mount option, still no messages.


I'm using simple cp command:

# cp -a /mnt/old_hd/data/gbdata/* /usr/local/mysql/data/gbdata/

or for one file
# cp -a /mnt/old_hd/data/gbdata/parts_0016.MYD /usr/local/mysql/data/gbdata/
cp: writing ‘/usr/local/mysql/data/gbdata/parts_0016.MYD’: No space
left on device
cp: failed to extend ‘/usr/local/mysql/data/gbdata/parts_0016.MYD’: No
space left on device

It's the same error if I try to copy for ex. with midnight commander.

On Sat, Oct 26, 2013 at 11:35 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 26, 2013, at 1:46 PM, Igor M <igork20@gmail.com> wrote:
>>
>> # mount -t btrfs -o compress=lzo,compress-force=lzo /
>
> Why do you have two compression mount options? You need to pick one of these.
>
>> What to do ?
>
> Are there any kernel messages reported by dmesg at the time the copy starts and fails? What's the exact copy command you're using?
>
>
> Chris Murphy
