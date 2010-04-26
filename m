From: C Anthony Risinger <anthony@extof.me>
Subject: Re: list subvolumes with new btrfs command
Date: Mon, 26 Apr 2010 15:51:35 -0500
Message-ID: <r2kbe6460751004261351vdfefc756zf095207a6588ef65@mail.gmail.com>
References: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
	 <l2n9bd6b5361004252022wceaf4c6bj3d62a48f389331d2@mail.gmail.com>
	 <p2qbe6460751004261023s24fe1f84xd80738387c1a3da8@mail.gmail.com>
	 <201004261958.56440.hka@qbs.com.pl>
	 <r2sbe6460751004261210m1c098d37ia4c424059a4e1c34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: sniper <s3c24xx@gmail.com>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <r2sbe6460751004261210m1c098d37ia4c424059a4e1c34@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 26, 2010 at 2:10 PM, C Anthony Risinger <anthony@extof.me> =
wrote:
> On Mon, Apr 26, 2010 at 12:58 PM, Hubert Kario <hka@qbs.com.pl> wrote=
:
>> On Monday 26 April 2010 19:23:21 C Anthony Risinger wrote:
>>> > I am using ubuntu-10.04-rc with kernel compiled from the almost
>>> > lastest source , the btrfs-progs is latest too.
>>> >
>>> > You can modify line
>>> >
>>> > =A0fprintf(stderr, "ERROR: can't perform the search\n");
>>> > to
>>> > =A0fprintf(stderr, "ERROR: can't perform the search: %s\n",
>>> > strerror(errno));
>>> >
>>> > to see what happened on earth.
>>>
>>> nice:
>>>
>>> $ sudo btrfs subvolume list /
>>> ERROR: can't perform the search: Inappropriate ioctl for device
>>>
>>> i'm not really familiar with C, or anything this low level, does th=
is
>>> help you diagnose my problem?
>>
>> Have you tried to run it on the device with the btrfs, not the mount=
 point?
>>
>> It looks like the ioctl was made too restrictive about its arguments=
=2E
>
> ah yes i missed mentioning that to, tried that:
>
> $ sudo btrfs sub list /dev/sda2
> ERROR: '/dev/sda2' is not a subvolume
>
> no dice :(

i tried setting up loopback with a newly formatted btrfs image +
mounting, same result: Inappropriate ioctl for device.  same error
whether i point the command at the default subvolume or a snapshot.
is there anything (missing) i should check in regards to my kernel
(module/progs mismatch)?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
