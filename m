From: sniper <s3c24xx@gmail.com>
Subject: Re: list subvolumes with new btrfs command
Date: Mon, 26 Apr 2010 11:22:46 +0800
Message-ID: <l2n9bd6b5361004252022wceaf4c6bj3d62a48f389331d2@mail.gmail.com>
References: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
	 <q2j9bd6b5361004251909j8dcf6ccbzd978d627e137fadb@mail.gmail.com>
	 <z2tbe6460751004251947ve533479ax174cc4f8bff50c01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <z2tbe6460751004251947ve533479ax174cc4f8bff50c01@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/4/26 C Anthony Risinger <anthony@extof.me>:
>> need super root? in my ubuntu10.04 with latest btrfs-progs:
>>
>> $ ./btrfs subvolume list /media/sda3-100g/
>> ERROR: can't perform the search
>> $ sudo ./btrfs subvolume list /media/sda3-100g/
>> ID 258 top level 5 path misc/snap/snap-4-26
>
> ah sorry, i forgot to mention that it doesn't work as super user
> either, same result:
>
> $ sudo btrfs subvolume list /
> ERROR: can't perform the search
>
> the btrfs-progs in ubuntu is probably slightly behind git HEAD (what
> i'm using in Arch package), maybe it broke recently, i might try to
> bisect and see it i can pinpoint to problem commit. =C2=A0i am also u=
sing
> kernel 2.6.33 (ubuntu is .32 i think) that's why i thought maybe ther=
e
> was an issue there; it seems like the ioctl() call is failing no
> matter what in my case.
>
I am using ubuntu-10.04-rc with kernel compiled from the almost
lastest source , the btrfs-progs is latest too.

You can modify line

 fprintf(stderr, "ERROR: can't perform the search\n");
to
 fprintf(stderr, "ERROR: can't perform the search: %s\n", strerror(errn=
o));

to see what happened on earth.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
