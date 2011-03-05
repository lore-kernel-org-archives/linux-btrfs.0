From: Alexey A Nikitin <moonwalker@syrius.us>
Subject: Re: BTRFS fsck tool
Date: Fri, 4 Mar 2011 21:27:16 -0600
Message-ID: <AANLkTi=jxsr6W1LZ6g0_Ex4nBGeSpQJY+LdPkqjeD2Qx@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
 <AANLkTin=2=bhmdzUHV-poMwEx9et6y2m3OSba-1Rc9=v@mail.gmail.com>
 <AANLkTim7q=xxPH_OoEu9HW9_RAXgD=-XdS3BHoHm0wNv@mail.gmail.com> <AANLkTimLvU4+1s1pMCJ_ysmFp9=k3zOhJ++KHVWfrC0Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimLvU4+1s1pMCJ_ysmFp9=k3zOhJ++KHVWfrC0Y@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/3/4 cwillu <cwillu@cwillu.com>:
> On Fri, Mar 4, 2011 at 7:20 PM, Alexey A Nikitin <moonwalker@syrius.us> wrote:
>> all I get is
>>
>> btrfs-select-super: disk-io.c:739: open_ctree_fd: Assertion
>> `!(!tree_root->node)' failed
>
> Make sure you run it as root, and try both -s 1 and -s 2.
>

Done that - commands were ran from root shell and I tried both -s 1
and -s 2. It gives same error with both parameters for both
btrfs-select-super and btrfsck.

>> PS: I subscribed to this list now, so there is no more need to cc me.
>
> Reply to all does it automatically.
>

Indeed it does, I didn't know that.


Best,

Alexey

--
This message was created with 100% recycled electrons
