From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 12:03:42 +0000
Message-ID: <245edecbf26891c3e4368476af2bb26a@localhost>
References: <4B97F7CE.4030405@bobich.net>	 <ef88cc6b1003101314g4a8cdbccuaf0a965d908ee187@mail.gmail.com>	 <4B98277E.2080103@bobich.net> <6278d2221003110235u6d75849bj4b356875ece8a01f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2221003110235u6d75849bj4b356875ece8a01f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 10:35:45 +0000, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
>>>> [...]
>>>> Are there similar optimizations available in BTRFS?
>>>
>>> There is an SSD mount option available[1].
>>>
>>> [1]
http://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options
>>
>> But what _exactly_ does it do?
> 
> Chris explains the change to favour spatial locality in allocator
> behaviour in with '-o ssd'. '-o ssd_spread' does the opposite, where
> RMW cycles are higher penalty. Elsewhere IIRC, Chris also said BTRFS
> attempts to submit 128KB BIOs where possible (or wishful thinking?):
> 
> http://markmail.org/message/4sq4uco2lghgxzzz

Thanks, that's useful info.

What about FS block and metadata alignment, though? Is there a way to
leverage the knowledge of erase block size in order to reduce wear and
increase performance?

Gordan
