Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:55460
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753415AbdAZRrA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:47:00 -0500
Subject: Re: Announcing btrfs-dedupe 1.1.0
To: Robert Krig <robert.krig@render-wahnsinn.de>, linux-btrfs@vger.kernel.org
References: <b81e1e04-394b-06a8-d4cb-acfe436a8423@pharaoh.uk>
 <08ac7d06-367e-a2ec-dc15-ee71aa3dada2@render-wahnsinn.de>
 <18c395fe-3f32-9433-622e-e2ba5148bb2e@pharaoh.uk>
 <aaa3a289-940b-a799-421e-f4bb17cdabea@render-wahnsinn.de>
From: James Pharaoh <james@pharaoh.uk>
Message-ID: <2856fd95-d771-3081-4a45-b900fcf6b3f0@pharaoh.uk>
Date: Thu, 26 Jan 2017 18:44:53 +0100
MIME-Version: 1.0
In-Reply-To: <aaa3a289-940b-a799-421e-f4bb17cdabea@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, ok, can you create an account on my souce tracker and create an 
issue for this please?

https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe

I am fairly sure I can fix this without too much difficulty. ;-)

James

On 26/01/17 18:16, Robert Krig wrote:
> I've tried your binaries, which also seem to work fine on Debian
> Stretch. (At least using the latest ubuntu xenial binary).
>
> I've only run into one little issue, btrfs-dedupe will abort with
> "Serialization error: invalid value: Path contains invalid UTF-8
> characters at line 0 column 0" if I run it on some large top level
> directories. Unfortunately it doesn't list which directory it has a
> problem with. Wouldn't it be better if btrfs-dedupe simply ignores
> directories it has a problem with, and continues with the rest?
>
>
> On 13.01.2017 20:08, James Pharaoh wrote:
>> Did you try the binaries? I can build binaries for other platforms if
>> you let me know what you are interested in.
>>
>> In any case, you'll need to install rust:
>>
>> https://www.rust-lang.org/install.html
>>
>> Which will tell you to do this on Linux, and presumably all unix
>> platforms:
>>
>> curl https://sh.rustup.rs -sSf | sh
>>
>> You can either log in and out or reload your profile to get the
>> installed software in your PATH:
>>
>> source ~/.profile
>>
>> Then you can checkout btrfs-dedupe, eg from my gitlab public https,
>> I'll assume you have git installed:
>>
>> git clone
>> https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe.git
>>
>> Then cd in and build using cargo:
>>
>> cd btrfs-dedupe
>> cargo build --release
>>
>> There is basically just one binary which will end up in
>> target/release/btrfs-dedupe.
>>
>> I'll add these instructions to the README later.
>>
>> James
>>
>> On 13/01/17 13:56, Robert Krig wrote:
>>> Hi, could you include some build instructions for people that are
>>> unfamiliar with compiling rust code?
>>>
>>>
>>> On 08.01.2017 17:57, James Pharaoh wrote:
>>>> Hi everyone,
>>>>
>>>> I'm pleased to announce a new version of my btrfs-dedupe tool, written
>>>> in rust, available here:
>>>>
>>>> http://btrfs-dedupe.com/
>>>>
>>>> Binary packages built on ubuntu (probably will work elsewhere, but
>>>> haven't tried this), are available at:
>>>>
>>>> https://dist.wellbehavedsoftware.com/btrfs-dedupe/
>>>>
>>>> This version is considered ready for production use. It maintains a
>>>> compressed database of the filesystem state, and it tracks file
>>>> metadata, hashes file contents, and the extent-map contents, in order
>>>> to work out what needs to be deduplicated.
>>>>
>>>> This is a whole-file deduplication tool, similar to bedup, but since
>>>> it is written in Rust, and designed to work with the dedupe ioctl, I
>>>> think it's more suitable for production use.
>>>>
>>>> As normal for open source, this comes without any warranty etc, but
>>>> the only updates are performed via the defragment and deduplication
>>>> ioctls, and so assuming they work correctly then this should not cause
>>>> any corruption.
>>>>
>>>> Please feel free to contact me with any questions/problems.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
