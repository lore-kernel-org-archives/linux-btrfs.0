Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:51975 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbaLEX3E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 18:29:04 -0500
Message-ID: <54823FBA.9000707@pobox.com>
Date: Fri, 05 Dec 2014 15:28:58 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: General Question: ctime, mtime, and xattrs
References: <54822CEE.5070603@pobox.com> <CAE5mzvgrdYSNWSWLrnmHMz2fSgPSJV_ocYr_ZSBGPwLWBshH-g@mail.gmail.com>
In-Reply-To: <CAE5mzvgrdYSNWSWLrnmHMz2fSgPSJV_ocYr_ZSBGPwLWBshH-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ah...

I've been thinking "ctime" is/was (still) "create time". It seems that 
somewhere in the last couple decades it became "change time"; Or that I 
picked up that incorrect "create time" idea back in the UNIX Sys V R 3 
days and just never had cause to think about it again...

Never mind. /sigh...

What a maroon. 8-)

On 12/05/2014 03:03 PM, cwillu wrote:
> xattrs are commonly used to implement acls, which wouldn't typically be
> considered a content modification.
> On Dec 5, 2014 4:08 PM, "Robert White" <rwhite@pobox.com> wrote:
>
>> So I was reading the wiki on the internal layout. The INODE description
>> says "st_ctime. Also updated when xattrs change."
>>
>> Why isn't changing the xattrs a modification (st_mtime) event?

