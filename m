From: Morey Roof <moreyroof@gmail.com>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 13:09:55 -0600
Message-ID: <48A33183.7000305@gmail.com>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com> <48A32F68.90102@techmonkeys.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A32F68.90102@techmonkeys.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was hoping to have it specified as a set of mount options or defaults 
controlled in the super block so that if you want to use it you can 
otherwise it doesn't exist.

-Morey

Jeff Fisher wrote:
>> Don't do it!!!
>>
>> OK, I know Chris has described some block sharing.  But I hate it.
>>
>> If I copy "resume" to "resume.save", it is because I want 2 copies
>> for safety.  I don't want the fs to reduce it to 1 copy.  And
>> reducing the duplicates is exactly opposite to Chris's paranoid
>> make-multiple-copies-by-default.
>>
>> Now feel free to tell me I'm an idiot (other people do) :)
>
> I would imagine that it would be optional and at worst, a specialized 
> fork of btrfs that follows the mainline but adds the deduplication bits.
>
> Jeff
>

