From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [RFC-PATCH] Re: mounting arbitrary directories
Date: Fri, 3 Dec 2010 03:41:02 -0600
Message-ID: <AANLkTi=CbrdRaMCtRjrfZs5vP_gjrfQ2aekEdd5jc0vh@mail.gmail.com>
References: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com>
	<1290918133.14274.20.camel@nayuki>
	<-3532760747667207688@unknownmsgid>
	<AANLkTikvt1_kuJjF7w7toK-Mwu0kDNWm2p4yrfERZ3P3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikvt1_kuJjF7w7toK-Mwu0kDNWm2p4yrfERZ3P3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 11:42 AM, C Anthony Risinger <anthony@extof.me>=
 wrote:
> On Sun, Nov 28, 2010 at 4:07 AM, C Anthony Risinger <anthony@extof.me=
> wrote:
>> On Nov 27, 2010, at 10:22 PM, Calvin Walton <calvin.walton@gmail.com=
>
>> wrote:
>>> On Sat, 2010-11-27 at 21:19 -0600, C Anthony Risinger wrote:
>>>
>>>> eg. if i have a "regular" directory (not a subvolume) in the top-
>>>> level:
>>>>
>>>> /__boot
>>>>
>>>> i can mount it with:
>>>>
>>>> mount -o subvol=3D__boot /dev/sda /mnt
>>>
>>> The 'subvol' option actually works using the same mechanism as a bi=
nd
>>> mount. The fact that it works using a directory is purely a
>>> coincidence
>>> - I would not expect it to be officially supported, and you shouldn=
't
>>> rely on it.
>>
>> Hrrrm... Well I thought I'd be clever and use this little trick one
>> time to update my kernel... Anyways I oops out like 3 times in a row
>> (last func was <something>.clone in each IIRC) and now I'm stuck wit=
h
>> only my mobile since my server isn't set up yet and my =A0SSD just
>> failed on my netbook yesterday :-(
>>
>> Sooooo, if anyone can help me recover this partition long enough to
>> grab a few things... I would be most grateful :-) I think I have
>> everything critical, but I'd rather take another look :-) Right now =
I
>> can't mount; mount is failing w/bad superblock.
>>
>> /me promises to never recklessly sabotage himself after being warned=
 <
>> 6 hrs earlier
>
> any suggestions for me? =A0i dd'ed the corrupt partition to an extern=
al
> disk because i need the machine back up and running, but if possible
> i'd like to get the image running again. =A0i mounted it via loopback
> and as expected got the same errors:
>
> (will post the dmesg output next message -- left at home)
> open_ctree_fd failed....
> wanted XXXX found YYYY instead
>
> the mount command itself fails with "bad superblock or ..."
>
> i have seen others withe similar crash reports and IIRC correctly wer=
e
> able to recover it (seems like something just didn't get updated righ=
t
> before it locked...)
>
> any ideas?

dmesg output was:

------------------------------------------------------
device label root devid 1 transid 61235 /dev/loop0
parent transid verify failed on 11335634944 wanted 61235 found 61237
parent transid verify failed on 11335634944 wanted 61235 found 61237
parent transid verify failed on 11335634944 wanted 61235 found 61237
btrfs: open_ctree failed
------------------------------------------------------

i tried btrfsck as suggested in the recent thread:

------------------------------------------------------
# sudo losetup /dev/loop0 /mnt/btrfs.img

# sudo btrfsck -s 1 /dev/loop0
using SB copy 1, bytenr 67108864
parent transid verify failed on 11335634944 wanted 61235 found 61237
parent transid verify failed on 11335634944 wanted 61235 found 61237
parent transid verify failed on 11335634944 wanted 61235 found 61237
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' =
failed.

# sudo btrfsck -s 2 /dev/loop0
using SB copy 2, bytenr 274877906944
No valid Btrfs found on /dev/loop0
------------------------------------------------------

soooo... does this mean i'm totally boned for ever mounting this image
again?  or should i keep it around for later?  or anything else i can
try/do?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
