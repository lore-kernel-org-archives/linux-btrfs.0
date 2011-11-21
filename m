From: =?UTF-8?Q?Ren=C3=A9_Vangsgaard?= <rene.vangsgaard@gmail.com>
Subject: Re: mount errors
Date: Tue, 22 Nov 2011 00:29:53 +0100
Message-ID: <CAPWZyXZPVXVxGo3XwTc0j6o3exk7+HnNtsaAoa0JsyrAML_CVQ@mail.gmail.com>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
	<ad43919226351cd8f695a0dfc44adc81@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ad43919226351cd8f695a0dfc44adc81@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for answering.

2) I get this error when mounting:
couldn't open because of unsupported option features (8).
fsck.btrfs: disk-io.c:679: open_ctree_fd: Assertion `!(1)' failed.

My current mount options are
defaults,compress=3Dlzo,subvol=3D@home
I have tried removing the compress=3Dlzo with no difference.

-Ren=C3=A9

On 21 November 2011 17:27, Ken D'Ambrosio <ken@jots.org> wrote:
> 1) As of right now, btrfs's fsck is "done when it's done." =C2=A0So d=
on't hold your
> breath, I'm afraid.
>
> 2) What errors do you get on mount? =C2=A0It may be as simple as chan=
ging your fstab
> entry such that fsck isn't attempted to be run. =C2=A0(Change the las=
t column to
> "0".)
>
> -Ken
>
>
> On Sat, 19 Nov 2011 14:01:41 +0100 Ren=C3=A9 Vangsgaard <rene.vangsga=
ard@gmail.com>
> wrote
>
>> Hi - I have been using btrfs on /home for 2 weeks, and now it mounts
>> with errors. I know that no fsck is available yet. I ignore the erro=
r
>> and it still works, for now. Can I do anything to help you debug thi=
s
>> problem with btrfs?
>> Any news on fsck for btrfs?
>>
>> I am running Ubuntu 11.10.
>> Thank you, Ren=C3=A9
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
