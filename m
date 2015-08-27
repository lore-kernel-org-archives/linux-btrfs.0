Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36216 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbH0DEI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 23:04:08 -0400
Received: by oiev193 with SMTP id v193so3831722oie.3
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 20:04:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABW1wHSQTy2C6NqFkdRnoOH5NhL6rvv=u+TauCRtTZJW7wZHjQ@mail.gmail.com>
References: <20150826040442.GC10927@Juns-MacBook-Pro.local>
 <55DDBE12.1020104@suse.com> <CABW1wHSQTy2C6NqFkdRnoOH5NhL6rvv=u+TauCRtTZJW7wZHjQ@mail.gmail.com>
From: Jun He <jhe@cs.wisc.edu>
Date: Wed, 26 Aug 2015 22:03:27 -0500
Message-ID: <CABW1wHQXjDsbAmgGazwdjGE+YyAmaPngkzFgeBE6sp_Qo3FiCg@mail.gmail.com>
Subject: Re: btrfs -o discard bug in latest dev branches
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, the filefrag -b option was not used correctly. Here are the new output:
https://gist.github.com/junhe/b6ce39eeb6de8887e66a#file-btrfs-debug-tree-out
https://gist.github.com/junhe/b6ce39eeb6de8887e66a#file-filefrag-out

After doing fstrim /mnt/fsonloop
https://gist.github.com/junhe/b6ce39eeb6de8887e66a#file-filefrag-after-fstrim-out

On Wed, Aug 26, 2015 at 11:02 AM, Jun He <jhe@cs.wisc.edu> wrote:
> jun@jun-VirtualBox:~/workdir/b6ce39eeb6de8887e66a$ uname -r
> 4.2.0-rc5-integration-4.3+
>
> https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/1cd84e6bb138eeb08dc07af2c44dedf99866bde0/btrfs-debug-tree.out
>
> https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/1cd84e6bb138eeb08dc07af2c44dedf99866bde0/filefrag.out
>
> https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/1cd84e6bb138eeb08dc07af2c44dedf99866bde0/filefrag.after.fstrim.out
>
>
>
> On Wed, Aug 26, 2015 at 8:24 AM, Jeff Mahoney <jeffm@suse.com> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 8/26/15 12:04 AM, Jun He wrote:
>>> Hi, I have been playing with btrfs discard for a while and found
>>> that btrfs may fail to discard some extents with 'mount -o
>>> discard'. I am aware of Jeff Mahoney's patches (
>>> https://patchwork.kernel.org/patch/6609491/ ). It seems that the
>>> patches do not fix the problem. I have seen the same problematic
>>> behavior for the following versions
>>>
>>> - https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/
>>> integration-4.3 commit:477594f93c43b1ee685 - 3.16.0 - 4.2.0-rc7
>>>
>>> The problem can be reproduced by writing and fsyncing a 4MB file
>>> for 50 times on a 256MB empty FS (mount option: -o discard). You
>>> will find that some extents are not discarded (my expected behavior
>>> is that, after overwriting, an old version of a file extent should
>>> be discarded). I use several ways to confirm this:
>>>
>>> 1. I created a loop device back by a sparse file in tmpfs. After
>>> running the workload, I found the file is 29MB (ls -lsh). If you
>>> fstrim the file system, the sparse file will become 4.1MB. This
>>> proves that there are a lot of data not discarded.
>>
>> Can you capture the output of 'filefrag -b -v' for the sparse file in
>> tmpfs both before and after trim?  Also btrfs-debug-tree output for it.
>>
>>> 2. I collected blktrace + blkparse output and plotted the write and
>>> discard operations in a space-time graph, where you can intuitively
>>> see some extents are overwritten but not discarded. Here is the
>>> space-time graph
>>> https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/825a
>> 3c2946b52a50c2b6032a98d637f5a32bc5c3/integration-4.3.png
>>>
>>>  Is it a known problem or is it not a problem? If it is a known
>>> problem and there exists a patch that I am not aware of, can
>>> somebody direct me to it? If it is specifically designed this way,
>>> can the designers give the rationale of discarding some, but not
>>> all of, old extents?
>>>
>>> The reproducer can be run by: git clone
>>> https://gist.github.com/b6ce39eeb6de8887e66a.git cd
>>> b6ce39eeb6de8887e66a sudo python main.py
>>>
>>> It also has a readme.
>>
>> I tested my discard patches the other day against 4.2-rc8 and it
>> passed my 326 test.  I'll check out your reproducer.
>>
>> - -Jeff
>>
>>
>>
>> - --
>> Jeff Mahoney
>> SUSE Labs
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
>>
>> iQIcBAEBAgAGBQJV3b4SAAoJEB57S2MheeWyTUMP/R2mF2/6RcXO0iXNJw466/qI
>> VzEV09C5Cs04NnDSfY0ZPk3W6iD1B4iOnHB1HF+lK8ENeF/Ug+0Tnb1uJpEo4lvn
>> +yTxUx+qYwo737SU9oTjmvpr4aXzmV3I223gylcPnaXCQu8w80BsldIBvL98ExIq
>> Ad/ZzuPMAfc3jvhcEZrDTN6L77rIyhXkhGT/fMnRcycW/26myd8HbJDjE0lebmvY
>> 9+L15Ykgm52V4zpW5wSQh1xww8WWsKv/K6nF3shuNPlhmovOwtAAEJhLRQcpJp5e
>> +jSijexTsd9so5smwc+JJ+sW86zZ6G6opL/K96MJNEXZ4UMBQPaOYNrewAHTh8Xe
>> V4WzvbL/JWcKAAzPugvhRGjP2xjM+E1oBQGvZEGEmZb0lneW5Fouao9xGXtftRr9
>> NAc7A8D/WkqSxDb7qhEdmQpexsQNfPMQi4JmTj0/kGCjYAhxCuVlPgNjorE70BW/
>> nze9Fg1zydZZs0XeQW4Bh4+HU3yjexLshQCgXjnhabmc9+VwBnEuizYVtcjFgm8r
>> vBCj80cAID7n7PtPhDNE7DfFHLuigpA6hTw+vgUxL1zd4yHEjQ3pGZ0lZuVK42oZ
>> EIqKX7r0maU24pQGj1v9NL8QPqYQmrj9ljUmk3QSlvjTUGVv5y8U+KVX7h3cGJRO
>> YMs7n+5BMmI6WKZBn+fr
>> =StBb
>> -----END PGP SIGNATURE-----
