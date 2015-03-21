Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34339 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbCUSQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 14:16:48 -0400
Received: by iedfl3 with SMTP id fl3so12761995ied.1
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2015 11:16:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+4EQ5cWV-HaKGnmsn73Bif-w4otyz8JD_LRHeO=-Que+cRaYg@mail.gmail.com>
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
	<20150321180846.GE31762@carfax.org.uk>
	<CA+4EQ5cWV-HaKGnmsn73Bif-w4otyz8JD_LRHeO=-Que+cRaYg@mail.gmail.com>
Date: Sat, 21 Mar 2015 19:16:47 +0100
Message-ID: <CA+4EQ5chrXyaoLs09TdK09npfCxvLKDTZor5Bqc9wqqX3xpKkA@mail.gmail.com>
Subject: Re: New tool to recursive compress / decompress of files
From: Petr Bena <benapetr@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Petr Bena <benapetr@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am just wondering, does that defragment trick work for non-root users?

Also, even if it did work, I could as well make my tools use this
defragment trick instead, because I will probably never remember that
hacky syntax of defrag command :P doing something like compress -r
<folder> or decompress -r <folder> is just much more easy to remember
than multiple commands.

That thing I made is just a wrapper for other commands anyway

On Sat, Mar 21, 2015 at 7:12 PM, Petr Bena <benapetr@gmail.com> wrote:
> I would be certainly useful if this kind of tricks were mentioned on
> https://btrfs.wiki.kernel.org/index.php/Compression or anywhere on
> wiki
>
> On Sat, Mar 21, 2015 at 7:08 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Sat, Mar 21, 2015 at 06:56:12PM +0100, Petr Bena wrote:
>>> Hi, I like the compress feature, but unlike NTFS, compressing files in
>>> btrfs is not so simple. Just changing the flags using chattr will not
>>> compress anything, only newly written data would be.
>>>
>>> For this reason I decided to create a new tool that makes this simple,
>>> you can find it here: https://github.com/benapetr/compress
>>>
>>> It's very simple to use, for example to compress whole folder, you would do
>>>
>>> compress -rv <folder_name>
>>>
>>> the tool would recursively scan the folder, change all folders to +c
>>> and copy all files, preserving attributes to a temporary file within
>>> folder, then removes the original and move the copied, now fully
>>> compressed file back.
>>
>>    What does it do that this doesn't?
>>
>> $ chattr -R +c $dir
>> $ btrfs fi defrag -r -c $dir
>>
>>    (Sorry to do this to you, but better early in the life of the
>> project than later).
>>
>>    Hugo.
>>
>>> It's written in python despite I loathe it (I am a C++ programmer),
>>> because most of people love it for some reason, any because this would
>>> make it more simple for people to deploy it and modify it.
>>>
>>> The tool right now is in early alpha stage, probably full of bugs, I
>>> made it few hours ago, but I would like to hear any feedback, whether
>>> there would be any use for such a tool, feature requests etc :)
>>
>> --
>> Hugo Mills             | You shouldn't anthropomorphise computers. They
>> hugo@... carfax.org.uk | really don't like that.
>> http://carfax.org.uk/  |
>> PGP: 65E74AC0          |
