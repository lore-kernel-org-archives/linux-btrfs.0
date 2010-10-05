From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how can I copy files bigger than ~32 GB when using compress-force?
Date: Tue, 05 Oct 2010 08:16:54 +0200
Message-ID: <4CAAC2D6.3010201@wpkg.org>
References: <4CAA4A34.80701@wpkg.org> <20101004222837.GD9759@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101004222837.GD9759@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.10.2010 00:28, Chris Mason wrote:
> On Mon, Oct 04, 2010 at 11:42:12PM +0200, Tomasz Chmielewski wrote:
>>> I'm assuming this works without compress-force?  I can make a guess at
>>> what is happening, the compression forces a relatively small extent
>>> size, and this is making our worst case metadata reservations get upset.
>>
>> Yes, it works without compress-force.
>>
>> Interesting is that cp or rsync sometimes just exit quite fast with
>> "no space left".
>>
>> Sometimes, they just "hang" (waited up to about an hour) - file size
>> does not grow anymore, last modified time is not updated, iostat
>
> Sorry is this hang/fast exit with or without compress-force.

It only seems to happen with compress-force.


-- 
Tomasz Chmielewski
http://wpkg.org
