From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: find subvolume (used) size?
Date: Tue, 5 Oct 2010 19:15:38 +0000 (UTC)
Message-ID: <i8ftgq$3tp$1@dough.gmane.org>
References: <4CAB0B6C.3050908@wpkg.org> <4CAB4556.7070205@cfl.rr.com>
	<4CAB4D5E.4070807@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski, Tue, 05 Oct 2010 18:07:58 +0200:

> On 05.10.2010 17:33, Phillip Susi wrote:
>> On 10/5/2010 7:26 AM, Tomasz Chmielewski wrote:
>>> There is a standard df tool, but it can be a lengthy process for
>>> filesystems with lots of files.
>>
>> Maybe you mean du?  df takes almost no time at all and does not care
>> how many files there are.
> 
> Yep, I certainly meant du there.
> 

Just be carefull, because for example if you use -o compress, the space
the files are actually using can be different...

Lubos

