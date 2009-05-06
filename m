From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [BUG] fallocate behavior when crossing end-of-file
Date: Wed, 06 May 2009 17:36:14 +0200
Message-ID: <4A01AE6E.1050400@gmail.com>
References: <4A018A90.7050109@mccme.ru> <4A01A5DF.5050406@gmail.com> <4A01A8C4.20205@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Michael Raskin <7c6f434c@mail.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A01A8C4.20205@mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

Michael Raskin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Edward Shishkin wrote:
>   
>>> Desired: something (probably, one block) is allocated/reserved for the
>>> file. File length is set to 1 byte.
>>>       
>>              
>> Where is it documented?
>>
>> IMHO we should only guarantee that writes
>> to [0, 1] won't fail because of lack of disk space.
>> Other things (including file size) are up to implementation.
>>     
>
> POSIX, SUS.
>
> http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html
>
> <<<
> If the offset+ len is beyond the current file size, then
> posix_fallocate() shall adjust the file size to offset+ len. Otherwise,
> the file size shall not be changed.
>   

fallocate (2) is something different from posix_fallocate:

"...This default behavior closely resembles the behavior
of the posix_fallocate(3) library function, and is intended
as a method of optimally implementing that function."
