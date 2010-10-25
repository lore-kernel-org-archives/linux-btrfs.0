From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Determine if a given fs is a btrfs fs
Date: Mon, 25 Oct 2010 08:29:58 -0500
Message-ID: <AANLkTimdQPmn_VPzs6H_HT_+m9uM2PCno1W_D0mib8Yx@mail.gmail.com>
References: <20101024202410.GA2830@scooter>
	<AANLkTikB06jNR-QmkXjWWFE6fO=cTZvEDFbY5V98Pu6g@mail.gmail.com>
	<AANLkTina9g610_FLHHsOG3KSn5pgeiHCgaNtE7NnvH7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTina9g610_FLHHsOG3KSn5pgeiHCgaNtE7NnvH7g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 6:31 AM, J=E9r=F4me Poulin <jeromepoulin@gmail.=
com> wrote:
> On Sun, Oct 24, 2010 at 5:32 PM, J=E9r=F4me Poulin <jeromepoulin@gmai=
l.com> wrote:
> ...
>> p4 jerome # btrfs device scan /dev/dm-22
>> Scanning for Btrfs filesystems in '/dev/dm-22'
>> p4 jerome # echo $?
>> 0
> This is OK.
>
>> p4 jerome # btrfs device scan /dev/sda
>> Scanning for Btrfs filesystems in '/dev/sda'
>> ERROR: unable to scan the device '/dev/sda'
>> p4 jerome # echo $?
>> 11
> ...
> But isn't that error misleading, btrfs scan was succesfully able to
> scan /dev/sda, but, it doesn't contain btrfs, right?

imo, the best way is:

# root must be btrfs else silent return
[ "$(blkid -s TYPE -o value ${root})" =3D btrfs ] || return 0

at least that the way i do it in my initramfs hook; seems to be reliabl=
e.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
