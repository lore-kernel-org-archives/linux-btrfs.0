From: Berke Durak <berke.durak@gmail.com>
Subject: Re: Minimum device size of 256 MiB?
Date: Fri, 11 May 2012 17:02:51 -0400
Message-ID: <CAALTfKCMUCjT0J2BfDZ1PwWQ9QKjCDk8WfE3tthdoq0Neg3PUA@mail.gmail.com>
References: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
	<20120511205032.GV21964@eightyeight.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120511205032.GV21964@eightyeight.xmission.com>
List-ID: <linux-btrfs.vger.kernel.org>

I think I may have found a workaround.

> One very interesting use of dm-zero is for creating "sparse" devices =
in
conjunction with dm-snapshot. A sparse device reports a device-size
larger than the amount of actual storage space
available for that device. A user can write data anywhere within the
sparse device and read it back like a normal
device. Reads to previously unwritten areas will return a zero'd
buffer. When enough data has been written to fill up
the actual storage space, the sparse device is deactivated. This can
be very useful for testing device and filesystem
limitations.

I don't know if that would be useful for your crypto signature analysis=
=2E

On Fri, May 11, 2012 at 4:50 PM, Aaron Toponce <aaron.toponce@gmail.com=
> wrote:
> On Fri, May 11, 2012 at 03:57:24PM -0400, Berke Durak wrote:
>> There seems to be a 256 MiB lower limit on device size : mkfs.btrfs
>> refuses to create a filesystem on a device that is smaller than that=
=2E
>
> I've noticed the same. I'm interested in researching the patterns the
> filesystem puts down on an encrypted container, but would like to use=
 1MB
> files as the block device for the filesystem. Looking for patterns in=
 256MB
> files is too expensive.
>
> --
> . o . =C2=A0 o . o =C2=A0 . . o =C2=A0 o . . =C2=A0 . o .
> . . o =C2=A0 . o o =C2=A0 o . o =C2=A0 . o o =C2=A0 . . o
> o o o =C2=A0 . o . =C2=A0 . o o =C2=A0 o o . =C2=A0 o o o
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
