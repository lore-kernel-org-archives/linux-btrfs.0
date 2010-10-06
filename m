From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: find subvolume (used) size?
Date: Wed, 06 Oct 2010 14:08:12 +0200
Message-ID: <4CAC66AC.60903@wpkg.org>
References: <4CAB0B6C.3050908@wpkg.org> <4CAB4556.7070205@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CAB4556.7070205@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

>>> Maybe you mean du?  df takes almost no time at all and does not care
>>> how many files there are.
>>
>> Yep, I certainly meant du there.
>>
>
> Just be carefull, because for example if you use -o compress, the space
> the files are actually using can be different...

Certainly, one more reason why btrfs reporting subvolume size usage 
would be useful ;)


-- 
Tomasz Chmielewski
http://wpkg.org

