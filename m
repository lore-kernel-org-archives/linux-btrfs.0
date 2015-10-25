Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:40249 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbbJYOK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 10:10:56 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Ed Tomlinson <edt@aei.ca>, <kolcon@kolcon.net>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs double send
Date: Sun, 25 Oct 2015 10:10:51 -0400
MIME-Version: 1.0
Message-ID: <409f0e8e-c295-48c3-ae1e-5dceb44a9add@aei.ca>
In-Reply-To: <CAL3q7H4UGXsOOFoTVcw6=EsEaroT3nCwandenJXOhdxiaBVAdw@mail.gmail.com>
References: <20151024173617.GA26012@nbnb1>
 <CAL3q7H5H_Qdq0NAhiDOVw=JLYPJPuHhhSZPgUSQm=oYN+yXK=g@mail.gmail.com>
 <c84e02ac-4e81-4a11-b8d8-3660d3e0eb77@aei.ca>
 <CAL3q7H4UGXsOOFoTVcw6=EsEaroT3nCwandenJXOhdxiaBVAdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe,

I realize its another bug.  Two additional pieces of info that might help.
One, btrfs-progs was at 4.1.2 (I missed a tag= in my git pull).  Second
is that I have been able to recreate this issue three times over a period 
of
two to three days (tring again with 4.2.3).  My fs is probably a good 
testcase for any patches that appear.

Meanwhile I've been falling back to rsync which always works but is so much
slower.

TIA
Ed 

On Sunday, October 25, 2015 9:42:54 AM EDT, Filipe Manana wrote:
> On Sun, Oct 25, 2015 at 1:38 PM, Ed Tomlinson <edt@aei.ca> wrote:
>> Filipe,
>> 
>> Its still not perfect.  Here I can do sequential sends a few times then I
>> get something like this:
>> 
>> [root@grover snap]# sh -x brh
>> + base=/snap/shot ...
>
> Different and unrelated problem.
> Yes, we know there are still some problems regarding send issuing
> invalid/outdated paths to the send stream. Nothing to do with
> incorrect uuids in the send stream.
>
>> Please let me know if there is anything you would like me to try.  I am
>> running 4.2 with the 4.3 for-linus tree applied and the 4.2.x patches with
>> btrfs fixes removed.  On top of this are a few patches from this list.
>> 
>> TIA
>> Ed Tomlinson ...
>
>
>

